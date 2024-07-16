import 'dart:ui';

import 'package:callapp/service/signaling_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundEntryPoint{

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {

    try{
      
      service.on('stopService').listen((event) => service.stopSelf() );

      await SignalService.listen(service);
      
    }
    catch(e){
      if (kDebugMode) print('Error in Backgorund Start -> $e');
    }
    
  }


}
