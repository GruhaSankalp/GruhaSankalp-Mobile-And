import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sovereign_button.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? suggestions;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.suggestions,
  });
}

class GruhaAiScreen extends StatefulWidget {
  const GruhaAiScreen({super.key});

  @override
  State<GruhaAiScreen> createState() => _GruhaAiScreenState();
}

class _GruhaAiScreenState extends State<GruhaAiScreen> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Namaste! I am Gruha AI, your sovereign property clearinghouse advisor. You can ask me about Telangana Dharani land records, 30-year Encumbrance Certificates (EC), SRO guidance rates, or request clean title property recommendations in Kokapet or Financial District.',
      isUser: false,
      timestamp: DateTime.now(),
      suggestions: [
        'Check title status for Survey No 45 Kokapet',
        'What is Telangana registration stamp duty?',
        'Find 95+ score flats under ₹2 Cr',
      ],
    ),
  ];

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      if (textToSend == null) _messageController.clear();
    });

    // Simulated AI Advisor Response grounded in GruhaSankalp legal data
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      String reply;
      if (text.toLowerCase().contains('stamp duty') ||
          text.toLowerCase().contains('registration')) {
        reply =
            'Under Telangana Stamp Act:\n• Stamp Duty: 4.0%\n• Transfer Duty: 1.5%\n• Registration Fee: 0.5%\n• Total Government SRO Outlay: 7.5% of guidance/sale consideration.\n\nAll verified properties on GruhaSankalp compute this automatically in the financial factsheet.';
      } else if (text.toLowerCase().contains('survey') ||
          text.toLowerCase().contains('sy.')) {
        reply =
            'Audit Report for Kokapet Corridor (Sy. No 45):\n• Cadastral Trust Score: 98/100 (Clear Title)\n• SRO Sale Deed Registration verified via Gandipet Sub-Registrar\n• Encumbrance Certificate: Clean 30-year record with zero active bank charges or court stays.';
      } else {
        reply =
            'Based on sovereign clearinghouse records, I found 3 institutional-grade properties in Kokapet & Tellapur matching your criteria with Cadastral Scores >95. Would you like me to issue a digital gatepass for a weekend site visit?';
      }

      setState(() {
        _messages.add(
          ChatMessage(
            text: reply,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.smart_toy, color: AppColors.gold500, size: 20),
            SizedBox(width: 8),
            Text('Gruha AI Sovereign Advisor'),
          ],
        ),
        backgroundColor: AppColors.navy950,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Message Thread
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: msg.isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.82,
                          ),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? AppColors.navy950
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: msg.isUser
                                  ? AppColors.gold500
                                  : AppColors.borderLight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isUser
                                  ? Colors.white
                                  : AppColors.textDark,
                              fontSize: 13.5,
                              height: 1.45,
                            ),
                          ),
                        ),
                        if (msg.suggestions != null) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: msg.suggestions!.map((s) {
                              return ActionChip(
                                label: Text(s,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.navy950)),
                                backgroundColor: AppColors.gold50,
                                side: const BorderSide(
                                    color: AppColors.gold500),
                                onPressed: () => _sendMessage(s),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.document_scanner_outlined,
                        color: AppColors.navy800),
                    tooltip: 'Scan Legal Deed',
                    onPressed: () {
                      _sendMessage('Scan Deed: Uploaded Kokapet EC PDF extract');
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ask about title history, guidance rates...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.gold600),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

