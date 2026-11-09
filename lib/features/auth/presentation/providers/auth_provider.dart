import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

// Providers for Clean Architecture dependencies
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient: apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(secureStorageServiceProvider);
  return AuthRepositoryImpl(remoteDataSource: remote, storageService: storage);
});

// Auth State class
class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? errorMessage;
  final bool hasSeenOnboarding;
  final UserPersona selectedPersona;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.hasSeenOnboarding = false,
    this.selectedPersona = UserPersona.buyer,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? errorMessage,
    bool? hasSeenOnboarding,
    UserPersona? selectedPersona,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      selectedPersona: selectedPersona ?? this.selectedPersona,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState()) {
    checkInitialState();
  }

  Future<void> checkInitialState() async {
    state = state.copyWith(isLoading: true);
    final seen = await _repository.hasSeenOnboarding();
    final user = await _repository.getCurrentUser();
    state = state.copyWith(
      isLoading: false,
      hasSeenOnboarding: seen,
      user: user,
    );
  }

  void setPersona(UserPersona persona) {
    state = state.copyWith(selectedPersona: persona);
    _repository.updatePersona(persona);
  }

  Future<void> completeOnboarding() async {
    await _repository.setHasSeenOnboarding();
    state = state.copyWith(hasSeenOnboarding: true);
  }

  Future<bool> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final success = await _repository.sendOtp(phoneNumber);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send OTP. Please try again.',
      );
      return false;
    }
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
        persona: state.selectedPersona,
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid OTP. Please check the code and retry.',
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = state.copyWith(user: null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository: repo);
});

