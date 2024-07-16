import 'dart:async';

import 'package:callapp/service/notification_service.dart';
import 'package:callapp/service/signaling_service.dart';
import 'package:callapp/utils/entryp_points.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

const notificationChannelId = 'channel2';
const notificationId = 888;

class BackgroundService{

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: BackgroundEntryPoint.onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId, 
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration() );
  }


  static listenToUiThread(ServiceInstance service, Socket? socket){

      service.on('start-call').listen((to) {
        socket!.emit('start-call', {"to": to!['data'] });
      },);

      service.on("accept-call").listen((event) {
        NotificationService().cancleAllNotif();
        socket!.emit("accept-call", { "to": event!['data'] });
      },);
        
      service.on('deny-call').listen((event) {
        NotificationService().cancleAllNotif();
        service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, );
      },);
      
      service.on("ice-candidate").listen((event) {
        socket!.emit("ice-candidate",event);
      },);

      service.on('offer').listen((event) {
        socket!.emit('offer', event);
      },);
    
      service.on('offer-answer').listen((event) {
        socket!.emit('offer-answer',event);
      },);

      service.on('leave-call').listen((event) {
        socket!.emit('leave-call', event!['data']);
        service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, );
      },);

      service.on("deny-call").listen((event){
        service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, );
        socket!.emit('deny-call', event!['data']);
      });

      


  }
}