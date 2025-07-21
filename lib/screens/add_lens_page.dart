import 'dart:ui'; // <<< ADD THIS IMPORT for ImageFilter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <<< ADD THIS IMPORT for DateFormat
import 'package:lens_buddy/database/database.dart';
import 'package:lens_buddy/screens/dashboard_screen.dart';

// Converted to a StatefulWidget for better state management of controllers
class AddLensPage extends StatefulWidget {
  AddLensPage({super.key});

  @override
  State<AddLensPage> createState() => _AddLensPageState();
}

class _AddLensPageState extends State<AddLensPage> {
  final _brandNameController = TextEditingController();
  final _purchasedDateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  // final MyDatabase _database = MyDatabase();

  @override
  void dispose() {
    // It's crucial to dispose of controllers to prevent memory leaks
    _brandNameController.dispose();
    _purchasedDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  // --- UI Builder Methods ---

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
            left: -150,
            child: _buildAuroraBlob(const Color(0xFF303F9F), 300),
          ),
          Positioned(
            bottom: -150,
            right: -200,
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

  /// A reusable, styled text field for our form.
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: const Color(0xFF00f5d4),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00f5d4)),
        ),
      ),
    );
  }

  /// A special text field that opens a date picker on tap.
  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Prevents keyboard from appearing
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(Icons.calendar_today_outlined,
            color: Colors.white.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00f5d4)),
        ),
      ),
      onTap: () async {
        // Hide keyboard if it's somehow open
        FocusScope.of(context).requestFocus(FocusNode());

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2040),
          // Dark theme for the date picker
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF00f5d4), // header background color
                  onPrimary: Color(0xFF0D1117), // header text color
                  onSurface: Colors.white, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor:
                    const Color(0xFF00f5d4), // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          // Use setState to update the UI with the new date
          setState(() {
            controller.text = formattedDate;
          });
        }
      },
    );
  }

  /// The glowing, styled save button.
  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
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
        onPressed: () {
          // Logic remains unchanged
          DashboardScreen.lensOperations.addLens(
            bName: _brandNameController.text.toString(),
            pDate: _purchasedDateController.text.toString(),
            eDate: _expiryDateController.text.toString(),
          );
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: const Color(0xFF0D1117), // Dark text color
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text("SAVE LENS"),
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Add New Lens",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.05),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _brandNameController,
                    labelText: "Brand Name",
                    icon: Icons.local_offer_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildDateField(
                    controller: _purchasedDateController,
                    labelText: "Purchased Date",
                    context: context,
                  ),
                  const SizedBox(height: 20),
                  _buildDateField(
                    controller: _expiryDateController,
                    labelText: "Expiry Date",
                    context: context,
                  ),
                  const SizedBox(height: 40),
                  _buildSaveButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}