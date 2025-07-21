import 'dart:ui'; // <<< ADD THIS IMPORT for ImageFilter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <<< ADD THIS IMPORT for DateFormat
import 'package:lens_buddy/database/database.dart';
import 'package:lens_buddy/screens/dashboard_screen.dart';

// Converted to a StatefulWidget for correct state and controller management.
class AddRecords extends StatefulWidget {
  final dynamic user;
  final int? index;

  const AddRecords({super.key, this.index, this.user});

  @override
  State<AddRecords> createState() => _AddRecordsState();
}

class _AddRecordsState extends State<AddRecords> {
  final _dateController = TextEditingController();
  final _hoursController = TextEditingController();

  // The logic to pre-fill fields is moved to initState, the correct lifecycle method.
  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _dateController.text = widget.user["date"];
      _hoursController.text = widget.user["hours"];
    }
  }

  @override
  void dispose() {
    // It's crucial to dispose of controllers to prevent memory leaks.
    _dateController.dispose();
    _hoursController.dispose();
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
            bottom: -150,
            left: -200,
            child: _buildAuroraBlob(const Color(0xFF00796B), 400),
          ),
          Positioned(
            top: -100,
            right: -150,
            child: _buildAuroraBlob(const Color(0xFF303F9F), 300),
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

  /// A special text field that opens a date picker on tap.
  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Date",
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
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2040),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF00f5d4),
                  onPrimary: Color(0xFF0D1117),
                  onSurface: Colors.white,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF00f5d4),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            _dateController.text = formattedDate;
          });
        }
      },
    );
  }

  /// A styled text field for numeric input.
  Widget _buildHoursField() {
    return TextFormField(
      controller: _hoursController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number, // Optimized for number entry
      cursorColor: const Color(0xFF00f5d4),
      decoration: InputDecoration(
        labelText: "Hours Worn",
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon:
        Icon(Icons.timer_outlined, color: Colors.white.withOpacity(0.7)),
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

  /// The glowing, styled save button.
  Widget _buildSaveButton(BuildContext context) {
    // Determine if we are editing or adding
    final isEditing = widget.user != null;

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
          // The core logic remains exactly the same.
          if (isEditing) {
            DashboardScreen.lensOperations.editRecentLogs(
              widget.index!,
              _dateController.text.toString(),
              _hoursController.text.toString(),
            );
          } else {
            DashboardScreen.lensOperations.addRecentRecords(
              date: _dateController.text.toString(),
              hours: _hoursController.text.toString(),
            );
          }
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: const Color(0xFF0D1117),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        // Adapt button text based on the mode.
        child: Text(isEditing ? "UPDATE LOG" : "SAVE LOG"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Adapt title based on the mode.
        title: Text(
          isEditing ? "Edit Wear Log" : "Add Wear Log",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                  _buildDateField(context),
                  const SizedBox(height: 20),
                  _buildHoursField(),
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