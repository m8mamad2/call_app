

import 'package:callapp/screen/main_screen.dart';
import 'package:callapp/service/notification_service.dart';
import 'package:flutter/material.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //* Local Notification
  await NotificationService().init();
  await NotificationService().initListenerNotif();


  runApp( const MyApp() );

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black,)
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen()
    );
  }
}
