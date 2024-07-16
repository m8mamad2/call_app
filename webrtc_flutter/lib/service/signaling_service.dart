

import 'package:callapp/service/backgroudn_service.dart';
import 'package:callapp/service/notification_service.dart';
import 'package:callapp/utils/generate_random_id.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:socket_io_client/socket_io_client.dart';



// const String socketUrl = 'ws://192.168 .10.232:8080';
const String socketUrl = 'ws://79a1-172-80-252-151.ngrok-free.app';


class SignalService {

  static Socket? socket = io(socketUrl, {
      "transports": ['websocket'],
      "query": {"callerId": generateRandomSixDigitNumber()},
    },);

  static init() => socket!.connect();

  static listen(ServiceInstance service)async{


      socket!.onConnect((data) {
        service.invoke('connectionData', { "data": StateDataToUI.initiData.name }, );
        print("-----------------------Socket connected !!");
      });

      socket!.onConnectError((data) {
        print("Connect Error $data");
      });


      socket!.on('incoming-call', (data) async {
          await NotificationService().displayNotif();
          service.invoke('connectionData', { "data": StateDataToUI.commingCall.name, "from": data['from'] }, );
      });

      socket!.on('rejected_call', (data) => service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, ),);

      socket!.on('you-are', (data) {
        service.invoke('you-are', { "data": data }, );  
      },);

      socket!.on('call-accepted', (data) {
        service.invoke('call-accepted',data);
        service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, );
      },);

      socket!.on('offer-answer',(data) {
        service.invoke('offer-answer',data);
      },);

      socket!.on('offer', (data) {
        service.invoke('offer',data);
      },);

      socket!.on("ice-candidate", (data) {
        service.invoke("ice-candidate",data);
      },);
      
      socket!.on('left-call', (data) {
        service.invoke('left-call');
        service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, );
      },);

      socket!.on('call-denied',(data) {
        service.invoke('call-denied');
      },);      

      BackgroundService.listenToUiThread(service, socket);

  }
  

}

enum StateDataToUI  { commingCall, exitCall, initiData }
