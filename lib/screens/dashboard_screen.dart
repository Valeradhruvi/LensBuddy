import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lens_buddy/lens_operations/lens_operations.dart';
import 'package:lens_buddy/screens/add_lens_page.dart';
import 'package:lens_buddy/screens/add_records.dart';
import 'package:lens_buddy/screens/feedback_form.dart';
import 'package:lens_buddy/utills/string.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
  static LensOperations lensOperations = LensOperations();

  dynamic recentLogs = lensOperations.getRecentRecords();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Logic remains unchanged.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      extendBodyBehindAppBar: true,
      extendBody: true, // Allows body to extend behind the BottomNav as well
      appBar: _buildAppBar(context),
      // --- MODIFICATION START: Added BottomNavigationBar ---
      bottomNavigationBar: _buildBottomNavigationBar(context),
      // --- MODIFICATION END ---
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SingleChildScrollView(
            // Padding added to ensure content is not hidden by the app bar or bottom nav bar
            padding: EdgeInsets.fromLTRB(
                16,
                kToolbarHeight + 40,
                16,
                // Add padding to the bottom to avoid the bottom nav bar
                kBottomNavigationBarHeight + 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLensInfoCard(context),
                const SizedBox(height: 30),
                _buildAddLogButton(context),
                const SizedBox(height: 30),
                Text(
                  "Recent Activity",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // const SizedBox(height: 12),
                _buildRecentLogsList(context),
              ],
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
    );
  }

  // --- UI Builder Methods ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent, // Important for the glass effect
      elevation: 0,
      child: ClipRRect(
        // Using ClipRRect to avoid content spilling out of rounded corners if you add them
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF161b22).withOpacity(0.8),
              border: Border(right: BorderSide(color: Colors.white.withOpacity(0.2))),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerHeader(),
                ListTile(
                  leading: const Icon(Icons.dashboard_rounded, color: Color(0xFF00f5d4)),
                  title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Just close the drawer, we are already on this screen
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.feedback_outlined, color: Colors.white.withOpacity(0.7)),
                  title: Text('Send Feedback', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer first
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FeedbackPage(),
                    ));
                  },
                ),
                const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.white.withOpacity(0.7)),
                  title: Text('About', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                  onTap: () {
                    // Placeholder for an 'About' page
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.0),
        ),
      ),
      child: const Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Lens Buddy', // Your Application Name
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(
        APPBAR_OF_DASHBOARD_SCREEN,
        style:
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.white.withOpacity(0.05),
      elevation: 0,
      // --- MODIFICATION: The 'actions' property has been removed from here ---
    );
  }

  // --- MODIFICATION START: New method to build the BottomNavigationBar ---
  Widget _buildBottomNavigationBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.0),
            ),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_rounded),
                label: 'Add Lens',
              ),
            ],
            currentIndex: 0, // Always highlight "Dashboard" as we are on this screen
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF00f5d4), // Neon accent color
            unselectedItemColor: Colors.white.withOpacity(0.7),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            onTap: (index) {
              // We only care about the tap on the "Add Lens" button (index 1)
              if (index == 1) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) => AddLensPage()))
                    .then((_) => setState(() {
                  // Refresh state if needed when returning from AddLensPage
                  widget.recentLogs =
                      DashboardScreen.lensOperations.getRecentRecords();
                }));
              }
            },
          ),
        ),
      ),
    );
  }
  // --- MODIFICATION END ---

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

  Widget _buildLensInfoCard(BuildContext context) {
    final String lensBrand = "AquaLens";
    final DateTime expiryDate = DateTime(2026, 1, 14);
    final int daysLeft = expiryDate.difference(DateTime.now()).inDays;
    final int totalDays = 365;

    return GlassmorphicContainer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lensBrand,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.hourglass_bottom_rounded,
                    color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                Text(
                  "$daysLeft Days Left",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  "Expires: ${DateFormat('dd MMM yyyy').format(expiryDate)}",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value:
                (daysLeft > 0) ? (totalDays - daysLeft) / totalDays : 1.0,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF00f5d4)),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddLogButton(BuildContext context) {
    return Container(
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
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddRecords()))
              .then((_) => setState(() {
            widget.recentLogs =
                DashboardScreen.lensOperations.getRecentRecords();
          }));
        },
        icon: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: const Icon(Icons.add_circle_outline, color: Color(0xFF0D1117)),
        ),
        label: Padding(
          padding: const EdgeInsets.fromLTRB(8.0,3,8,3),
          child: const Text("Add Wear Log"),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: const Color(0xFF0D1117), // Dark text color
          textStyle:
          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildRecentLogsList(BuildContext context) {
    if (widget.recentLogs.isEmpty) {
      return GlassmorphicContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 20),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.list_alt_rounded,
                    size: 50, color: Colors.white.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text(
                  "No wear logs recorded yet.",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.recentLogs.length,
      itemBuilder: (context, index) {
        final log = widget.recentLogs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassmorphicContainer(
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) =>
                        AddRecords(user: log, index: index)))
                    .then((_) => setState(() {
                  widget.recentLogs =
                      DashboardScreen.lensOperations.getRecentRecords();
                }));
              },
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.watch_later_outlined,
                        color: Color(0xFF00f5d4), size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log["date"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16)),
                          const SizedBox(height: 4),
                          Text("${log["hours"]} hours worn",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          _showDeleteConfirmationDialog(context, index),
                      icon: Icon(Icons.delete_forever_outlined,
                          color: const Color(0xFFff4d6d).withOpacity(0.8)),
                      tooltip: "Delete Log",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: const Color(0xFF161b22).withOpacity(0.85),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.white.withOpacity(0.2))),
            title: const Text("Confirm Deletion",
                style: TextStyle(color: Colors.white)),
            content: const Text("This action cannot be undone.",
                style: TextStyle(color: Colors.white70)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child:
                const Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  DashboardScreen.lensOperations.deleteRecentLogs(index);
                  setState(() => widget.recentLogs =
                      DashboardScreen.lensOperations.getRecentRecords());
                  Navigator.of(context).pop();
                },
                child: const Text("Delete",
                    style: TextStyle(color: Color(0xFFff4d6d))),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Reusable Glassmorphic Container
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  const GlassmorphicContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}