// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lazy_lens_notes/database/database.dart';
// import 'package:lazy_lens_notes/screens/add_lens_page.dart';
// import 'package:lazy_lens_notes/utills/string.dart';
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final MyDatabase _database = MyDatabase();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(APPBAR_OF_DASHBOARD_SCREEN),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blue, Colors.blueAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//               return AddLensPage();
//             },));
//           }, icon: Icon(Icons.add))
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _database.selectAllLens(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             // Read first lens record
//             final lensData = snapshot.data![0];
//
//             final lensBrand = lensData['brand'] ?? '';
//             final purchaseDateStr = lensData['purchased_date'] as String;
//             final expiryDateStr = lensData['expiry_date'] as String;
//
//             final purchaseDate = DateTime.parse(purchaseDateStr);
//             final expiryDate = DateTime.parse(expiryDateStr);
//             final daysLeft = expiryDate.difference(DateTime.now()).inDays;
//
//             // Dummy recent logs for now (replace later from DB)
//             // List<Map<String, dynamic>> recentLogs = [
//             //   {"date": DateTime(2025, 6, 27), "hours": 8},
//             //   {"date": DateTime(2025, 6, 26), "hours": 6},
//             //   {"date": DateTime(2025, 6, 25), "hours": 9},
//             // ];
//
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Lens Info Card
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             lensBrand,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Days Left: $daysLeft",
//                             style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Expiry Date: ${DateFormat('dd MMM yyyy').format(expiryDate)}",
//                             style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Add Lens Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => AddLensPage()),
//                         ).then((value) {
//                           setState(() {});
//                         });
//                       },
//                       child: const Text("Add Wear Log"),
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Recent Wear Logs
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Recent Wear Logs",
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       final log = snapshot.data![index];
//                       return Card(
//                         child: ListTile(
//                           leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
//                           title: Text(DateFormat('dd MMM yyyy').format(log["date"])),
//                           subtitle: Text("${log["hours"]} hours worn"),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(child: Text("No Lens Data Found"));
//           }
//         },
//       ),
//     );
//   }
// }
//
// remove database things