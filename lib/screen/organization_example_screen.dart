// import 'package:cherry_feed/appbar/custom_app_bar.dart';
// import 'package:flutter/material.dart';
//
// import 'package:permission_handler/permission_handler.dart';
//
// class OrganizationExampleScreen extends StatefulWidget {
//   const OrganizationExampleScreen({Key? key}) : super(key: key);
//
//   @override
//   State<OrganizationExampleScreen> createState() => _OrganizationExampleScreenState();
// }
//
// class _OrganizationExampleScreenState extends State<OrganizationExampleScreen> {
//   void checkPermission () async {
//     // var status = await Permission.camera.status;
//     // if (status.isGranted) {
//     //   // We didn't ask for permission yet.
//     // }
//     PermissionStatus notificationStatus = await Permission.notification.request();
//     PermissionStatus locationStatus = await Permission.location.request();
//     PermissionStatus photoStatus = await Permission.photos.request();
// // You can can also directly ask the permission about its status.
// //     if (await Permission.location.isRestricted) {
// //       // The OS restricts access, for example because of parental controls.
// //     }
// //     if (await Permission.contacts.request().isGranted) {
// //       // Either the permission was already granted before or the user just granted it.
// //     }
//   print(notificationStatus);
//   print(locationStatus);
//   print(photoStatus);
// // You can request multiple permissions at once.
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.notification,
//       Permission.location,
//       Permission.photos
//     ].request();
//     print(statuses[Permission.location]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(isShow: true, isBorder: false),
//       body: TextButton(
//         child: Text('hi'),
//         onPressed: checkPermission,
//       ),
//     );
//   }
// }
