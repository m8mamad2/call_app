
import 'package:callapp/screen/home_screen.dart';
import 'package:callapp/screen/incomming_call_screen.dart';
import 'package:callapp/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';


class MainScreen extends StatefulWidget {
  
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {


  @override
  Widget build(BuildContext context) {
    return  Container(
      width: kWidth(context),
      height: kHeight(context),
      color: Colors.white,
      child: StreamBuilder(
        stream: FlutterBackgroundService().on('connectionData'),
        builder: (context, snapshot) {

          final screenState = snapshot.data?['data'] ?? 'init';
          final fromId = snapshot.data?['from'];

          switch(screenState){
            case 'initiData':  return const HomeScreen();
            case 'exitCall' :  return const HomeScreen();
            case 'commingCall':return IncommingCallScreen(fromId: fromId,);
            default: return const HomeScreen();
          }
          
        },
      ),
    );
  }

}



