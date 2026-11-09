import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/sovereign_button.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isOtpSent = false;
  int _countdown = 45;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onSendOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .sendOtp(_phoneController.text.trim());
      if (success) {
        setState(() => _isOtpSent = true);
        context.showSnackBar('Verification code sent to +91 ${_phoneController.text}');
      }
    }
  }

  void _onVerifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      context.showSnackBar('Please enter complete 6-digit OTP', isError: true);
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).verifyOtp(
          phoneNumber: '+91${_phoneController.text.trim()}',
          otp: otp,
        );

    if (success && mounted) {
      context.showSnackBar('Welcome to GruhaSankalp Clearinghouse');
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('Investor Verification'),
        backgroundColor: AppColors.navy950,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Monogram
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.navy950,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.gold500,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sovereign Identity Access',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Role: ${authState.selectedPersona.name.toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gold600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Enter Your Mobile Number',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy950,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'We will transmit an encrypted 6-digit OTP for instant biometric clearing.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24),

                // Phone Number Input
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: !_isOtpSent,
                  validator: FormValidators.validatePhone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: '98765 43210',
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      child: const Text(
                        '+91 🇮🇳',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    suffixIcon: _isOtpSent
                        ? IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => setState(() => _isOtpSent = false),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                if (_isOtpSent) ...[
                  // OTP Section
                  const Text(
                    '6-Digit Verification Code',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      letterSpacing: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy950,
                    ),
                    decoration: const InputDecoration(
                      hintText: '••••••',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Resend in 00:$_countdown',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context.showSnackBar('OTP dispatched via WhatsApp');
                        },
                        icon: const Icon(Icons.chat_bubble_outline,
                            size: 15, color: Colors.green),
                        label: const Text(
                          'Get via WhatsApp',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Action Button
                SovereignButton(
                  text: _isOtpSent ? 'Verify & Enter Vault' : 'Send Sovereign OTP',
                  isLoading: authState.isLoading,
                  style: SovereignButtonStyle.primaryNavy,
                  onPressed: _isOtpSent ? _onVerifyOtp : _onSendOtp,
                ),

                const SizedBox(height: 28),

                // Biometric Quick Unlock
                Center(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _phoneController.text = '9876543210';
                          _otpController.text = '123456';
                          _onVerifyOtp();
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.gold500, width: 1.5),
                            color: AppColors.gold50,
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            color: AppColors.navy950,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'One-Tap Biometric Demo Bypass',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

