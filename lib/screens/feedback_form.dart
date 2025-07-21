import 'dart:ui';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // --- MODIFICATION: Removed subject controller ---
  // final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // --- MODIFICATION: Added state for star rating ---
  int _rating = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    // --- MODIFICATION: Removed subject controller from dispose ---
    _messageController.dispose();
    super.dispose();
  }

  // Helper method to build the themed text fields (unchanged)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field cannot be empty';
          }
          return null;
        },
      ),
    );
  }

  // --- MODIFICATION START: New widget to build the star rating UI ---
  Widget _buildStarRating() {
    return Column(
      children: [
        Text(
          "Your Rating",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
              icon: Icon(
                index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                size: 36,
              ),
              color: index < _rating
                  ? const Color(0xFF00f5d4) // Active star color
                  : Colors.white.withOpacity(0.5), // Inactive star color
            );
          }),
        ),
      ],
    );
  }
  // --- MODIFICATION END ---

  void _submitFeedback() async {
    // --- MODIFICATION START: Added validation for rating ---
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a star rating.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return; // Stop submission if no rating is given
    }
    // --- MODIFICATION END ---

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      // In a real app, you would send the rating and message:
      // final message = _messageController.text;
      // await ApiService.sendFeedback(rating: _rating, message: message);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Thank you for your feedback!'),
            backgroundColor: const Color(0xFF00f5d4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Send Feedback",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // --- MODIFICATION: Replaced subject field with star rating ---
                    _buildStarRating(),
                    const SizedBox(height: 30),

                    // Message Field
                    _buildTextField(
                      controller: _messageController,
                      hintText: "Tell us more (optional)...",
                      maxLines: 6,
                    ),
                    const SizedBox(height: 40),

                    // Submit Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00f5d4), Color(0xFF00bfa5)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00f5d4).withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFF0D1117),
                            strokeWidth: 3,
                          ),
                        )
                            : const Text(
                          "Submit",
                          style: TextStyle(
                            color: Color(0xFF0D1117),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Background Widgets (unchanged) ---
  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF161b22), Color(0xFF0d1137)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -150,
            child: _buildAuroraBlob(const Color(0xFF303F9F), 300),
          ),
          Positioned(
            bottom: -150,
            left: -200,
            child: _buildAuroraBlob(const Color(0xFF00796B), 400),
          ),
        ],
      ),
    );
  }

  Widget _buildAuroraBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.5),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}