

import 'dart:async';
import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';


class NotificationService{

  AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  init()async{

    final Int64List vibrationPattern = Int64List(8);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 700;
    vibrationPattern[2] = 1000;
    vibrationPattern[4] = 700;
    vibrationPattern[5] = 1000;
    vibrationPattern[6] = 700;
    vibrationPattern[7] = 1000;


   await awesomeNotifications.initialize(
      'resource://drawable/icon',
      [

        //? Call Notif
        NotificationChannel(
          channelKey: 'channel1', 
          channelName: 'Channet TItle 1', 
          channelDescription: 'Cahnnel 1',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          criticalAlerts: true,
          defaultColor: Colors.amber,
          defaultPrivacy: NotificationPrivacy.Public,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          enableVibration: true,
          playSound: true,
          vibrationPattern: vibrationPattern,
          enableLights: true,
          // soundSource: 'resource://raw/ring',
          ),
        
        //? background Notif
        NotificationChannel(
          channelKey: 'channel2', 
          channelName: 'Channet TItle 2', 
          channelDescription: 'Cahnnel 2'),
     
      ],
      debug: true);
  }

  initListenerNotif()async{
    awesomeNotifications.setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  }

  cancleAllNotif()async=>
    await awesomeNotifications.dismissAllNotifications();
    
  displayNotif() async {

    await awesomeNotifications.isNotificationAllowed().then((value)async => !value 
      ? await awesomeNotifications.requestPermissionToSendNotifications()
      : null,);

    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 123, 
        channelKey: 'channel1',
        title: ' 📞 Calling From Home ',
        body: 'Please On Tap The Notification',
        notificationLayout: NotificationLayout.BigText,
        badge: 1,
        wakeUpScreen: true,
        //! fullScreenIntent: true,
        // customSound: 'resource://raw/ring',
        largeIcon: 'resource://drawable/call', ),

      actionButtons: [
        NotificationActionButton(key: 'answer', label: 'Answer',isDangerousOption: true,enabled: true,showInCompactView: true),
      ]
      );
  
  }

}

class NotificationController {

  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async { }

  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {}

  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    await Future.delayed(const Duration(seconds: 1), (){
      FlutterBackgroundService().invoke('incoming-call');
    } );
  }
  
}

