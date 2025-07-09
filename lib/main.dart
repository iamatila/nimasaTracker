// 1 start

// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:device_information/device_information.dart';
// import 'dart:math';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Request required permissions
//   if (Platform.isAndroid) {
//     await Geolocator.requestPermission();
//   }
  
//   final monitor = DeviceMonitor();
//   await monitor.initialize();
//   monitor.startMonitoring();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Nimasa',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Nimasa'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   // int _counter = 0;

//   // void _incrementCounter() {
//   //   setState(() {
//   //     // This call to setState tells the Flutter framework that something has
//   //     // changed in this State, which causes it to rerun the build method below
//   //     // so that the display can reflect the updated values. If we changed
//   //     // _counter without calling setState(), then the build method would not be
//   //     // called again, and so nothing would appear to happen.
//   //     _counter++;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: const Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Nimasa Asset',
//             ),
//             // Text(
//             //   '$_counter',
//             //   style: Theme.of(context).textTheme.headlineMedium,
//             // ),
//           ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _incrementCounter,
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.add),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// class DeviceMonitor {
//   final deviceInfo = DeviceInfoPlugin();
//   final connectivity = Connectivity();
//   Timer? _timer;
//   StreamSubscription<ConnectivityResult>? _connectivitySubscription;
//   bool _isConnected = false;
//   final String _token = 'YfEmZYxkBjdqvBnUYx4bytnzkUFJkzYKVXkAEGWhvMQvuBaGud2jSapRHGkP68au';

//   Future<void> initialize() async {
//     // Request location permission
//     if (Platform.isAndroid || Platform.isIOS) {
//       final permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         await Geolocator.requestPermission();
//       }
//     }

//     // Check initial connection state
//     _isConnected = await _checkConnectivity();

//     // Listen for connectivity changes
//     _connectivitySubscription =
//         connectivity.onConnectivityChanged.listen((result) {
//       _isConnected = result != ConnectivityResult.none;
//       if (_isConnected) {
//         _sendData();
//       }
//     }) as StreamSubscription<ConnectivityResult>?;
//   }

//   String _generateKey() {
//     final random = Random.secure();
//     final values = List<int>.generate(16, (i) => random.nextInt(256));
//     return base64Url.encode(values);
//   }

//   String _generateAuthToken(String key) {
//     final combined = '${key}_$_token';
//     return base64Url.encode(utf8.encode(combined));
//   }

//   Future<String> _getDeviceId() async {
//     if (Platform.isAndroid) {
//       try {
//         final imei = await DeviceInformation.deviceIMEINumber;
//         if (imei.isNotEmpty) {
//           return imei;
//         }
//       } catch (e) {
//         print('Error getting IMEI: $e');
//       }
//       return await _getFallbackDeviceId();
//     }
//     return await _getFallbackDeviceId();
//   }

//   Future<String> _getFallbackDeviceId() async {
//     try {
//       if (Platform.isWindows) {
//         final info = await deviceInfo.windowsInfo;
//         return info.deviceId;
//       } else if (Platform.isMacOS) {
//         final info = await deviceInfo.macOsInfo;
//         return info.systemGUID ?? info.model;
//       } else if (Platform.isAndroid) {
//         final info = await deviceInfo.androidInfo;
//         return info.id;
//       } else if (Platform.isIOS) {
//         final info = await deviceInfo.iosInfo;
//         return info.identifierForVendor ?? '';
//       }
//     } catch (e) {
//       print('Error getting device ID: $e');
//     }
//     return 'unknown';
//   }

//   Future<String> _getIpAddress() async {
//     try {
//       final List<NetworkInterface> interfaces = await NetworkInterface.list();
//       for (var interface in interfaces) {
//         for (var addr in interface.addresses) {
//           if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
//             return addr.address;
//           }
//         }
//       }
//     } catch (e) {
//       print('Error getting IP address: $e');
//     }
//     return 'unknown';
//   }

//   Future<bool> _checkConnectivity() async {
//     try {
//       final result = await connectivity.checkConnectivity();
//       return result != ConnectivityResult.none;
//     } catch (e) {
//       print('Error checking connectivity: $e');
//       return false;
//     }
//   }

//   Future<void> checkLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied');
//     }
//   }

//   Future<void> _sendData() async {
//     try {
//       await checkLocationPermission();
//       Position? position;
//       try {
//         position = await Geolocator.getCurrentPosition();
//       } catch (e) {
//         print('Error getting location: $e');
//         position = null;
//       }

//       final key = _generateKey();

//       final data = {
//         'device': await _getDeviceId(),
//         'ip_address': await _getIpAddress(),
//         'longitude': position?.longitude.toString() ?? '0',
//         'latitude': position?.latitude.toString() ?? '0',
//       };

//       final response = await http
//           .post(
//             Uri.parse('https://nimasa.sandbox.linnkstec.com/v1'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${_generateAuthToken(key)}',
//               'key': key,
//             },
//             body: jsonEncode(data),
//           )
//           .timeout(Duration(seconds: 30));

//       if (response.statusCode != 200) {
//         print('Error sending data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error in _sendData: $e');
//     }
//   }

//   void startMonitoring() {
//     // Send initial data
//     if (_isConnected) {
//       _sendData();
//     }

//     // Set up periodic timer
//     _timer = Timer.periodic(Duration(minutes: 30), (_) {
//       if (_isConnected) {
//         _sendData();
//       }
//     });
//   }

//   void dispose() {
//     _timer?.cancel();
//     _connectivitySubscription?.cancel();
//   }
// }

// 1 end

// 2 start

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:io' show Platform;
// import 'dart:math';

// // Constants
// const String apiURL = "https://nimasa.sandbox.linnkstec.com/v1";
// const String _token = "YfEmZYxkBjdqvBnUYx4bytnzkUFJkzYKVXkAEGWhvMQvuBaGud2jSapRHGkP68au";

// // Background task handler
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       // Check internet connectivity
//       var connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) {
//         return Future.value(true);
//       }

//       await sendDeviceData();
//       return Future.value(true);
//     } catch (e) {
//       print('Error in background task: $e');
//       return Future.value(true);
//     }
//   });
// }

// Future<String> generateRandomKey() async {
//   const chars =
//       'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//   Random rnd = Random();
//   return String.fromCharCodes(Iterable.generate(
//       16, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
// }

// Future<String> getDeviceId() async {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     // Note: IMEI access requires special permissions and may not be available on all devices
//     // You might need to fall back to androidId
//     return androidInfo.id;
//   } else if (Platform.isIOS) {
//     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//     return iosInfo.identifierForVendor ?? 'unknown';
//   } else if (Platform.isWindows) {
//     WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
//     return windowsInfo.deviceId;
//   } else if (Platform.isMacOS) {
//     MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
//     return macInfo.systemGUID ?? 'unknown';
//   }
//   return 'unknown';
// }

// Map? ponds = {};
// Future<void> sendDeviceData() async {
//   try {
//     // // Get device location
//     // Position position = await Geolocator.getCurrentPosition(
//     //   desiredAccuracy: LocationAccuracy.high,
//     // );
//     // Get device location with new settings approach
//     Position position = await Geolocator.getCurrentPosition(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         timeLimit: Duration(seconds: 30),
//       ),
//     );


//     // Generate random key and bearer token
//     String randomKey = await generateRandomKey();
//     String bearerToken = base64.encode(
//       // utf8.encode('$randomKey*$_token'),
//       utf8.encode('${randomKey}_$_token'),
//     );
//     print(bearerToken);
//     print("the bearerToken");

//     // Get device ID
//     String deviceId = await getDeviceId();

//     // Prepare data
//     // data = {
//     Map<String, dynamic> data = {
//       "device": deviceId,
//       "ip_address": await getIpAddress(),
//       "longitude": position.longitude.toString(),
//       "latitude": position.latitude.toString(),
//     };
//     print(data);
//     print("the data");

//     // Make API call
//     // http.Response res;
//     var res = await http.post(
//       Uri.parse(apiURL),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $bearerToken',
//         'key': randomKey,
//       },
//       body: jsonEncode(data),
//     );
//     // log(res.body);
//     Map responds = json.decode(res.body);
//     print(responds);
//     print("the response");
//     ponds = json.decode(res.body);
//   } catch (e) {
//     print('Error sending data: $e');
//     rethrow;
//   }
// }

// Future<String> getIpAddress() async {
//   try {
//     final response = await http.get(Uri.parse('https://api.ipify.org'));
//     return response.body;
//   } catch (e) {
//     return 'unknown';
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Request location permissions
//   await Geolocator.requestPermission();

//   // Initialize Workmanager
//   await Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: false,
//   );

//   // Register periodic task
//   await Workmanager().registerPeriodicTask(
//     "deviceTracker",
//     "deviceTracker",
//     frequency: const Duration(minutes: 30),
//     constraints: Constraints(
//       networkType: NetworkType.connected,
//       requiresBatteryNotLow: false,
//     ),
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('Device Tracker Running'),
//               // Text(ponds),
//             ],
//           ),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// 2 end

// 3 start

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:workmanager/workmanager.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:io' show Platform;
// import 'package:android_id/android_id.dart';
// import 'package:device_imei/device_imei.dart';

// // Background task name
// const taskName = "NimasaLocationTask";
// final _deviceImeiPlugin = DeviceImei();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize WorkManager
//   await Workmanager().initialize(callbackDispatcher);

//   // Register periodic task
//   await Workmanager().registerPeriodicTask(
//     "1",
//     taskName,
//     frequency: const Duration(minutes: 1),
//     constraints: Constraints(
//       networkType: NetworkType.connected,
//     ),
//   );

//   runApp(MyApp());
// }

// // This is the function that will be called in the background
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       await sendLocationData();
//       return true;
//     } catch (err) {
//       print('Error in background task: $err');
//       return false;
//     }
//   });
// }

// class LocationService {
//   static Future<Position> getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     return await Geolocator.getCurrentPosition();
//   }
// }

// class DeviceInfoService {
//   static Future<String> getDeviceId() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

//     if (Platform.isAndroid) {
//       try {
//         // String? imei = await DeviceImei.getImei();
//         String? imei = await _deviceImeiPlugin.getDeviceImei();
//         return imei ?? 'unknown';
//       } catch (e) {
//         // Fallback to Android ID if IMEI is not available
//         const androidIdPlugin = AndroidId();
//         final androidId = await androidIdPlugin.getId();
//         return androidId ?? 'unknown';
//       }
//     } else if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       return iosInfo.identifierForVendor ?? 'unknown';
//     } else if (Platform.isWindows) {
//       final windowsInfo = await deviceInfo.windowsInfo;
//       return windowsInfo.deviceId;
//     } else if (Platform.isMacOS) {
//       final macOsInfo = await deviceInfo.macOsInfo;
//       return macOsInfo.systemGUID ?? 'unknown';
//     }

//     return 'unknown';
//   }
// }

// Future<void> sendLocationData() async {
//   // Check internet connectivity
//   final connectivityResult = await Connectivity().checkConnectivity();
//   if (connectivityResult == ConnectivityResult.none) {
//     print('No internet connection. Skipping API call.');
//     return;
//   }

//   try {
//     // Get current location
//     final position = await LocationService.getCurrentLocation();

//     // Get device ID
//     final deviceId = await DeviceInfoService.getDeviceId();

//     // Generate random key
//     final key = DateTime.now().millisecondsSinceEpoch.toString();

//     // Create token
//     final token = 'YfEmZYxkBjdqvBnUYx4bytnzkUFJkzYKVXkAEGWhvMQvuBaGud2jSapRHGkP68au';
//     final bearerToken = base64.encode(utf8.encode('${key}_$token'));

//     // Prepare data
//     final data = {
//       'device': deviceId,
//       'ip_address': await _getIpAddress(),
//       'longitude': position.longitude.toString(),
//       'latitude': position.latitude.toString(),
//     };

//     print('Sending data: $data');

//     // Send data to API
//     final response = await http.post(
//       Uri.parse('https://nimasa.sandbox.linnkstec.com/v1'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $bearerToken',
//         'key': key,
//       },
//       body: jsonEncode(data),
//     );

//     print('API Response: ${response.body}');

//     if (response.statusCode != 200) {
//       throw Exception('Failed to send data: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error sending location data: $e');
//     throw e;
//   }
// }

// Future<String> _getIpAddress() async {
//   try {
//     final response = await http.get(Uri.parse('https://api.ipify.org'));
//     return response.body;
//   } catch (e) {
//     return 'unknown';
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Background Location Tracker'),
//         ),
//         body: const Center(
//           child: Text('Background service is running...'),
//         ),
//       ),
//     );
//   }
// }

// 3 end

// 4 start

// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:io' show Platform;
// import 'package:android_id/android_id.dart';
// import 'package:device_imei/device_imei.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:launch_at_startup/launch_at_startup.dart';
// import 'package:background_fetch/background_fetch.dart';
// import 'package:permission_handler/permission_handler.dart';

// final _deviceImeiPlugin = DeviceImei();

// const String AUTOSTART_PREF_KEY = 'autostart_enabled';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (Platform.isWindows || Platform.isMacOS) {
//     await initializeDesktopAutostart();
//   } else if (Platform.isAndroid || Platform.isIOS) {
//     await initializeService();
//   }

//   runApp(MyApp());
// }

// Future<void> initializeDesktopAutostart() async {
//   launchAtStartup.setup(
//     appName: 'LocationTracker',
//     appPath: Platform.resolvedExecutable,
//   );
//   await launchAtStartup.enable();
// }

// Future<void> initializeService() async {
//   // final service = FlutterBackgroundService();

//   // // Configure notifications for Android
//   // const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   //   'background_service',
//   //   'Background Service',
//   //   description: 'This channel is used for background service notification',
//   //   importance: Importance.low,
//   // );

//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   //     FlutterLocalNotificationsPlugin();

//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<
//   //         AndroidFlutterLocalNotificationsPlugin>()
//   //     ?.createNotificationChannel(channel);

//   // await service.configure(
//   //   androidConfiguration: AndroidConfiguration(
//   //     onStart: onStart,
//   //     autoStart: true,
//   //     isForegroundMode: true,
//   //     notificationChannelId: 'background_service',
//   //     initialNotificationTitle: 'Background Service',
//   //     initialNotificationContent: 'Running in background',
//   //     foregroundServiceNotificationId: 888,
//   //   ),
//   //   iosConfiguration: IosConfiguration(
//   //     autoStart: true,
//   //     onForeground: onStart,
//   //     onBackground: onIosBackground,
//   //   ),
//   // );

//   // await service.startService();

//   if (!Platform.isAndroid && !Platform.isIOS) return;

//   final service = FlutterBackgroundService();

//   if (Platform.isAndroid) {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'background_service',
//       'Background Service',
//       description: 'This channel is used for background service notification',
//       importance: Importance.low,
//     );

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: true,
//         notificationChannelId: 'background_service',
//         initialNotificationTitle: 'Location Service',
//         initialNotificationContent: 'Service is running',
//         foregroundServiceNotificationId: 888,
//       ),
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//     );
//   } else if (Platform.isIOS) {
//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         // Dummy configuration for iOS builds
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: false,
//         notificationChannelId: 'background_service',
//         initialNotificationTitle: 'Location Service',
//         initialNotificationContent: 'Service is running',
//         foregroundServiceNotificationId: 888,
//       ),
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//     );
//   }

//   await service.startService();

// }

// @pragma('vm:entry-point')
// bool onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('iOS background fetch event received');
//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   // Initialize location permissions immediately
//   try {
//     await LocationService.initializePermissions();
//   } catch (e) {
//     print('Error initializing location permissions: $e');
//   }

//   Timer.periodic(Duration(minutes: 5), (timer) async {
//     if (Platform.isWindows || Platform.isMacOS) {
//       await sendLocationData();
//     } else if (Platform.isAndroid) {
//       if (service is AndroidServiceInstance &&
//           await service.isForegroundService()) {
//         await sendLocationData();
//       }
//     } else if (Platform.isIOS) {
//       await sendLocationData();
//     }
//   });
// }

// class LocationService {
//   static Future<void> initializePermissions() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//   }

//   static Future<Position> getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     return await Geolocator.getCurrentPosition();
//   }
// }

// class DeviceInfoService {
//   static Future<String> getDeviceId() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

//     if (Platform.isAndroid) {
//       try {
//         // String? imei = await DeviceImei.getImei();
//         String? imei = await _deviceImeiPlugin.getDeviceImei();
//         return imei ?? 'unknown';
//       } catch (e) {
//         // Fallback to Android ID if IMEI is not available
//         const androidIdPlugin = AndroidId();
//         final androidId = await androidIdPlugin.getId();
//         return androidId ?? 'unknown';
//       }
//     } else if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       return iosInfo.identifierForVendor ?? 'unknown';
//     } else if (Platform.isWindows) {
//       final windowsInfo = await deviceInfo.windowsInfo;
//       return windowsInfo.deviceId;
//     } else if (Platform.isMacOS) {
//       final macOsInfo = await deviceInfo.macOsInfo;
//       return macOsInfo.systemGUID ?? 'unknown';
//     }

//     return 'unknown';
//   }
// }

// Future<void> sendLocationData() async {
//   // Check internet connectivity
//   final connectivityResult = await Connectivity().checkConnectivity();
//   if (connectivityResult == ConnectivityResult.none) {
//     print('No internet connection. Skipping API call.');
//     return;
//   }

//   try {
//     // Get current location
//     final position = await LocationService.getCurrentLocation();
//     // print(position);
//     // print("position");

//     // Get device ID
//     final deviceId = await DeviceInfoService.getDeviceId();

//     // Generate random key
//     final key = DateTime.now().millisecondsSinceEpoch.toString();

//     // Create token
//     final token = 'YfEmZYxkBjdqvBnUYx4bytnzkUFJkzYKVXkAEGWhvMQvuBaGud2jSapRHGkP68au';
//     final bearerToken = base64.encode(utf8.encode('${key}_$token'));

//     // Prepare data
//     final data = {
//       'device': deviceId,
//       'ip_address': await _getIpAddress(),
//       'longitude': position.longitude.toString(),
//       'latitude': position.latitude.toString(),
//     };

//     print('Sending data: $data');

//     // Send data to API
//     final response = await http.post(
//       Uri.parse('https://nimasa.sandbox.linnkstec.com/v1'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $bearerToken',
//         'key': key,
//       },
//       body: jsonEncode(data),
//     );

//     print('API Response: ${response.body}');

//     if (response.statusCode != 200) {
//       throw Exception('Failed to send data: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error sending location data: $e');
//     throw e;
//   }
// }

// Future<String> _getIpAddress() async {
//   try {
//     final response = await http.get(Uri.parse('https://api.ipify.org'));
//     return response.body;
//   } catch (e) {
//     return 'unknown';
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Nimasa Location Service'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Service Status',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Service is running and sending location data',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         _getPlatformSpecificMessage(),
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }

//   String _getPlatformSpecificMessage() {
//     if (Platform.isAndroid) {
//       return 'Background service is running. The notification indicates active status.';
//     } else if (Platform.isIOS) {
//       return 'Service is running in background mode. Background App Refresh should be enabled in iOS Settings.';
//     } else if (Platform.isWindows || Platform.isMacOS) {
//       return 'Service is running and will automatically start with system boot.';
//     }
//     return '';
//   }
// }

// 4 end

// 5 start

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_windows/flutter_local_notifications_windows.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:win32/win32.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';
import 'package:win32_registry/win32_registry.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Constants for SharedPreferences keys
const String DEVICE_ID_KEY = 'device_id';
const String REGISTRATION_COMPLETE_KEY = 'registration_complete';

// Mobile background task callback (for Android/iOS)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      // Initialize services needed for background task
      WidgetsFlutterBinding.ensureInitialized();

      // Perform your background task here
      print("Native called background task: $taskName");

      // Check location services
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isLocationEnabled) {
        // Show local notification for disabled location
        await _showLocationDisabledNotification();
        return Future.value(true);
      }

      // Perform location and API operations
      final locationService = LocationNotificationService();
      await locationService._sendDataToApi();

      return Future.value(true);
    } catch (e) {
      print('Background task error: $e');
      return Future.value(false);
    }
  });
}

// Notification method for background task
Future<void> _showLocationDisabledNotification() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notification settings
  if (Platform.isWindows) {
    var initializationSettingsWindows = WindowsInitializationSettings(
      appName: 'Nimasa Asset Tracker',
      appUserModelId: 'com.nimasa.nimasa_system_tracker',
      guid: '543a694c-805e-4599-870c-b8ba121c199b',
    );
    var initializationSettings = InitializationSettings(
      windows: initializationSettingsWindows,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  var platformChannelSpecifics = NotificationDetails(
    android: const AndroidNotificationDetails(
      'location_service_channel',
      'Location Service Channel',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: const DarwinNotificationDetails(),
    macOS: const DarwinNotificationDetails(),
    windows: WindowsNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Location Services Disabled',
    'Please enable location services to use full app functionality',
    platformChannelSpecifics,
  );
}

class LocationNotificationService {
  static const String locationApiUrl =
      'https://nimasa.sandbox.linnkstec.com/v1/device';
  static const String registrationApiUrl =
      'https://nimasa.sandbox.linnkstec.com/v1/users'; // Registration API endpoint

  static final LocationNotificationService _instance =
      LocationNotificationService._internal();
  factory LocationNotificationService() => _instance;
  LocationNotificationService._internal();

  // Notification plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Timer for desktop background service
  Timer? _desktopTimer;
  bool _isDesktopServiceRunning = false;

  // Method channel for macOS
  static const MethodChannel _macOSChannel =
      MethodChannel('com.nimasa.nimasa_system_tracker/startup');

  // Initialize background services based on platform
  Future<void> initBackgroundService() async {
    // Initialize notifications
    await _initializeNotifications();

    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile platforms - use Workmanager
      Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true, // Set to false in production
      );

      // Register periodic task for mobile
      Workmanager().registerPeriodicTask(
        'locationServiceCheck',
        'periodicLocationCheck',
        frequency: const Duration(minutes: 5),
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
        ),
      );
    } else if (Platform.isWindows || Platform.isMacOS) {
      // Desktop platforms - use Timer-based approach
      _startDesktopBackgroundService();
    }
  }

  // Initialize notifications based on platform
  Future<void> _initializeNotifications() async {
    if (Platform.isWindows) {
      var initializationSettingsWindows = WindowsInitializationSettings(
        appName: 'Nimasa Asset Tracker',
        appUserModelId: 'com.nimasa.nimasa_system_tracker',
        guid: '543a694c-805e-4599-870c-b8ba121c199b',
      );
      var initializationSettings = InitializationSettings(
        windows: initializationSettingsWindows,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } else if (Platform.isAndroid) {
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } else if (Platform.isIOS || Platform.isMacOS) {
      const initializationSettingsDarwin = DarwinInitializationSettings();
      const initializationSettings = InitializationSettings(
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }
  }

  // Start desktop background service using Timer
  void _startDesktopBackgroundService() {
    if (!_isDesktopServiceRunning) {
      _desktopTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
        print("Desktop timer triggered background task");

        // Check location services
        bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

        if (!isLocationEnabled) {
          await _showLocationServiceNotification();
        } else {
          await _sendDataToApi();
        }

        // Save last execution time
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'last_execution', DateTime.now().toIso8601String());
      });

      _isDesktopServiceRunning = true;
      print("Desktop background service started");
    }
  }

  // Stop desktop background service
  void stopDesktopBackgroundService() {
    if (_isDesktopServiceRunning) {
      _desktopTimer?.cancel();
      _desktopTimer = null;
      _isDesktopServiceRunning = false;
      print("Desktop background service stopped");
    }
  }

  // Setup startup for all platforms
  Future<void> requestStartupPermissions() async {
    if (Platform.isWindows) {
      try {
        // Windows registry approach
        final key = Registry.currentUser
            .createKey(r'Software\Microsoft\Windows\CurrentVersion\Run');

        // Get the application executable path
        final exePath = Platform.resolvedExecutable;

        // Create registry value
        key.createValue(RegistryValue(
          'nimasa_system_tracker',
          RegistryValueType.string,
          exePath,
        ));

        // Also create a startup script that ensures the background service is running
        await _createWindowsStartupScript(exePath);

        print('Windows startup permissions granted successfully');
      } catch (e) {
        print('Error setting Windows startup permissions: $e');
      }
    } else if (Platform.isMacOS) {
      try {
        // Create a macOS launch agent
        await _createMacOSLaunchAgent();
        print('MacOS startup configuration created');
      } catch (e) {
        print('Error setting MacOS startup permissions: $e');
      }
    } else if (Platform.isAndroid) {
      // Android-specific permissions
      await Permission.ignoreBatteryOptimizations.request();
      await Permission.locationAlways.request();
    } else if (Platform.isIOS) {
      // iOS-specific permissions
      await Permission.locationAlways.request();
      await Permission.backgroundRefresh.request();
    }

    // Request location permissions for all platforms
    await _requestLocationPermissions();
  }

  // Create Windows startup script
  Future<void> _createWindowsStartupScript(String exePath) async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final scriptPath = path.join(appDir.path, 'startup.bat');

      // Create a batch script that runs the app
      final script = '''
@echo off
start "" "$exePath"
exit
''';

      // Write script to file
      final file = File(scriptPath);
      await file.writeAsString(script);

      // Make file executable
      final shell = Shell();
      await shell.run('attrib +x "$scriptPath"');

      // Add task to Task Scheduler
      await shell.run(
          'schtasks /create /tn "NimasaSystemTracker" /tr "$scriptPath" /sc onlogon /ru %username% /f');

      print('Windows startup script created at $scriptPath');
    } catch (e) {
      print('Error creating Windows startup script: $e');
    }
  }

  // Create macOS launch agent
  Future<void> _createMacOSLaunchAgent() async {
    try {
      final homeDir = await getApplicationDocumentsDirectory();
      final launchAgentsDir =
          path.join(homeDir.path, '..', 'Library', 'LaunchAgents');

      // Create directory if it doesn't exist
      final directory = Directory(launchAgentsDir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final plistPath =
          path.join(launchAgentsDir, 'com.nimasa.nimasa_system_tracker.plist');

      // Get executable path
      final exePath = Platform.resolvedExecutable;

      // Create plist content
      final plistContent = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.nimasa.nimasa_system_tracker</string>
    <key>ProgramArguments</key>
    <array>
        <string>$exePath</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/com.nimasa.nimasa_system_tracker.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/com.nimasa.nimasa_system_tracker.out</string>
</dict>
</plist>
''';

      // Write to file
      final file = File(plistPath);
      await file.writeAsString(plistContent);

      // Load the launch agent
      final shell = Shell();
      await shell.run('launchctl load -w "$plistPath"');

      print('MacOS launch agent created at $plistPath');
    } catch (e) {
      print('Error creating MacOS launch agent: $e');
    }
  }

  // Request location permissions for all platforms
  Future<void> _requestLocationPermissions() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Location permission denied');
        await _showLocationServiceNotification();
      } else {
        print('Location permission granted: $permission');
      }
    } catch (e) {
      print('Error requesting location permissions: $e');
    }
  }

  // Check location services availability
  Future<bool> _checkLocationServicesAvailability() async {
    try {
      // First, check if location services are enabled
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!isLocationServiceEnabled) {
        // Show notification that location services are disabled
        await _showLocationServiceNotification();
        return false;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Request location permissions
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          await _showLocationServiceNotification();
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error checking location services: $e');
      await _showLocationServiceNotification();
      return false;
    }
  }

  // Show location service disabled notification
  Future<void> _showLocationServiceNotification() async {
    try {
      var platformChannelSpecifics = NotificationDetails(
        android: const AndroidNotificationDetails(
          'location_service_channel',
          'Location Service Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
        macOS: const DarwinNotificationDetails(),
        windows: WindowsNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Location Services Disabled',
        'Please enable location services to use full app functionality',
        platformChannelSpecifics,
      );

      print('Location service notification shown'); // Debug print
    } catch (e) {
      print('Error showing location service notification: $e');
    }
  }

  // Get device details from SharedPreferences
  Future<String?> _getDeviceIdentifier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(DEVICE_ID_KEY);
  }

  // Get IP address
  Future<String> _getIpAddress() async {
    try {
      final info = NetworkInfo();
      return await info.getWifiIP() ?? 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  // Get current location
  Future<Position?> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return await Geolocator.getCurrentPosition();
      }
      return null;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  // Send data to API
  Future<void> _sendDataToApi() async {
    try {
      // Check location services availability
      bool locationServicesAvailable =
          await _checkLocationServicesAvailability();

      if (!locationServicesAvailable) {
        print('Location services not available. Skipping API call.');
        return;
      }

      // Get device identifier from SharedPreferences
      final deviceId = await _getDeviceIdentifier();

      if (deviceId == null) {
        print('Device ID not found. Registration needed.');
        return;
      }

      // Get IP address
      final ipAddress = await _getIpAddress();

      // Get current location
      final position = await _getCurrentLocation();

      // Generate random key
      final key = DateTime.now().millisecondsSinceEpoch.toString();

      // Create token
      const token =
          'YfEmZYxkBjdqvBnUYx4bytnzkUFJkzYKVXkAEGWhvMQvuBaGud2jSapRHGkP68au';
      final bearerToken = base64.encode(utf8.encode('${key}_$token'));

      // Prepare data payload
      final data = {
        'device': deviceId,
        'ip_address': ipAddress,
        'longitude': position?.longitude.toString() ?? '',
        'latitude': position?.latitude.toString() ?? '',
      };

      // Send POST request
      final response = await http.post(
        Uri.parse(locationApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
          'key': key,
        },
        body: jsonEncode(data),
      );

      // Log the request and response
      print('Data sent to API: ${jsonEncode(data)}');
      print('API response status: ${response.statusCode}');

      // Check response status
      if (response.statusCode == 200) {
        print('API call successful');
        print('Response body: ${response.body}');

        // Save the last successful API call timestamp
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'last_successful_api_call', DateTime.now().toIso8601String());
      } else {
        print('API call failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending data to API: $e');
    }
  }

  // New method to register staff and get device_id
  Future<String?> registerStaff(String staffName, String staffId) async {
    try {
      // Generate random key
      final key = DateTime.now().millisecondsSinceEpoch.toString();

      // Create token
      const token =
          'YfEmZYxkBjdqvBnUYx4bytnzkUFJkzYKVXkAEGWhvMQvuBaGud2jSapRHGkP68au';
      final bearerToken = base64.encode(utf8.encode('${key}_$token'));

      // Prepare registration data
      final data = {
        'name': staffName,
        'equipment_number': staffId,
      };

      // Send POST request to registration endpoint
      final response = await http.post(
        Uri.parse(registrationApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
          'key': key,
        },
        body: jsonEncode(data),
      );

      print('Registration API response status: ${response.statusCode}');
      print('Registration API response body: ${response.body}');

      // Check response status
      if (response.statusCode == 200) {
        // Parse response to extract device_id
        final responseData = jsonDecode(response.body);
        print('the data data ${responseData['data']}');
        final responseToken = responseData['data'];
        print('the responseToken data ${responseToken}');
        print('the responseToken token ${responseToken['token']}');
        final deviceId = responseData['data']['token'] as String?;

        if (deviceId != null && deviceId.isNotEmpty) {
          // Save the device_id to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(DEVICE_ID_KEY, deviceId);
          await prefs.setBool(REGISTRATION_COMPLETE_KEY, true);

          print('Registration successful. Device ID: $deviceId');
          return deviceId;
        } else {
          print(
              'Registration successful but device ID was not found in response');
          return null;
        }
      } else {
        print('Registration failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during staff registration: $e');
      return null;
    }
  }
}

// Registration Screen Widget
class RegistrationScreen extends StatefulWidget {
  final Function onRegistrationComplete;

  const RegistrationScreen({Key? key, required this.onRegistrationComplete})
      : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final locationService = LocationNotificationService();
        final deviceId = await locationService.registerStaff(
          _nameController.text.trim(),
          _idController.text.trim(),
        );

        if (deviceId != null) {
          widget.onRegistrationComplete();
        } else {
          setState(() {
            _errorMessage = 'Registration failed. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Please register to continue',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Staff Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Staff ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your staff ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.red.shade100,
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRegistration,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main app
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LocationNotificationService _locationService =
      LocationNotificationService();

  String _lastApiCall = 'Not yet called';
  Timer? _refreshTimer;
  bool _isServiceRunning = false;
  bool _isRegistered = false;
  bool _isCheckingRegistration = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Check if the device is already registered
    _checkRegistrationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      print('App resumed - checking if background service is running');
      _checkAndRestartServiceIfNeeded();
    } else if (state == AppLifecycleState.paused) {
      // App is in the background
      print('App paused - ensuring background service continues');
      _ensureBackgroundServiceRunning();
    }
  }

  // Check if device is already registered
  Future<void> _checkRegistrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool(REGISTRATION_COMPLETE_KEY) ?? false;
    final deviceId = prefs.getString(DEVICE_ID_KEY);

    setState(() {
      _isRegistered = isRegistered && deviceId != null;
      _isCheckingRegistration = false;
    });

    if (_isRegistered) {
      _initializeServices();
    }
  }

  // Called after successful registration
  void _onRegistrationComplete() {
    setState(() {
      _isRegistered = true;
    });
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Request permissions first
    await _locationService.requestStartupPermissions();

    // Initialize background service
    await _locationService.initBackgroundService();

    setState(() {
      _isServiceRunning = true;
    });

    // Set up UI refresh timer
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _updateLastApiCallInfo();
    });

    // Update UI with last API call info
    _updateLastApiCallInfo();
  }

  // Update the UI with information about the last API call
  Future<void> _updateLastApiCallInfo() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final lastCall = prefs.getString('last_successful_api_call');

    setState(() {
      if (lastCall != null) {
        final lastCallTime = DateTime.parse(lastCall);
        final now = DateTime.now();
        final difference = now.difference(lastCallTime);

        if (difference.inDays > 0) {
          _lastApiCall = '${difference.inDays} days ago';
        } else if (difference.inHours > 0) {
          _lastApiCall = '${difference.inHours} hours ago';
        } else if (difference.inMinutes > 0) {
          _lastApiCall = '${difference.inMinutes} minutes ago';
        } else {
          _lastApiCall = 'Just now';
        }
      } else {
        _lastApiCall = 'Not yet called';
      }
    });
  }

  // Check if service is running and restart if needed
  Future<void> _checkAndRestartServiceIfNeeded() async {
    if (!_isRegistered) return;

    final prefs = await SharedPreferences.getInstance();
    final lastExecution = prefs.getString('last_execution');

    if (lastExecution != null) {
      final lastExecTime = DateTime.parse(lastExecution);
      final now = DateTime.now();
      final difference = now.difference(lastExecTime);

      // If last execution was more than 10 minutes ago, restart service
      if (difference.inMinutes > 10) {
        print('Last execution was $difference ago - restarting service');
        await _restartBackgroundService();
      }
    } else {
      // No record of last execution, restart service
      print('No record of last execution - starting service');
      await _restartBackgroundService();
    }
  }

  // Ensure background service is running
  void _ensureBackgroundServiceRunning() {
    if (!_isRegistered) return;

    if (!_isServiceRunning) {
      _locationService.initBackgroundService();
      setState(() {
        _isServiceRunning = true;
      });
    }
  }

  // Restart background service
  Future<void> _restartBackgroundService() async {
    if (!_isRegistered) return;

    // For desktop, stop and restart the timer-based service
    if (Platform.isWindows || Platform.isMacOS) {
      _locationService.stopDesktopBackgroundService();
      await _locationService.initBackgroundService();
    }

    // For mobile, re-register the workmanager task
    if (Platform.isAndroid || Platform.isIOS) {
      Workmanager().cancelAll();
      await _locationService.initBackgroundService();
    }

    setState(() {
      _isServiceRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isCheckingRegistration
          ? _buildLoadingScreen()
          : _isRegistered
              ? _buildMainScreen()
              : RegistrationScreen(
                  onRegistrationComplete: _onRegistrationComplete),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Initializing...'),
          ],
        ),
      ),
    );
  }

  Widget _buildMainScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nimasa System Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Background Service Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isServiceRunning ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _isServiceRunning ? 'Running' : 'Stopped',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Last API Call: $_lastApiCall'),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _locationService._sendDataToApi();
                    _updateLastApiCallInfo();
                  },
                  child: const Text('Send Location Now'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _restartBackgroundService,
                  child: const Text('Restart Service'),
                ),
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }
}

// Main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request location permissions at startup
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  // Initialize shared preferences
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}


// 5 end