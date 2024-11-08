

import 'dart:async';

import 'package:callapp/service/backgroudn_service.dart';
import 'package:callapp/service/notification_service.dart';
import 'package:callapp/utils/generate_random_id.dart';
import 'package:socket_io_client/socket_io_client.dart';



// const String socketUrl = 'ws://192.168 .10.232:8080';
const String socketUrl = 'ws://79a1-172-80-252-151.ngrok-free.app';


class SignalService {

  static StreamController stateController = StreamController.broadcast();
  static StreamController whoAreYouController = StreamController.broadcast();
  static bool isConnected = false;

  static late Socket? socket;

  static init() {
    if(isConnected)return ;
    socket = io(
      socketUrl, 
      {
        "transports": ['websocket'],
        "query": {"callerId": generateRandomSixDigitNumber()},
      },
    );
    socket!.connect();
    isConnected = true;
  }

  static listen()async{


      socket!.onConnect((data) {
        stateController.sink.add(StateDataToUI.initiData.name);
        print("-----------------------Socket connected !!");
      });

      socket!.onConnectError((data) {
        print("Connect Error $data");
      });

      socket!.on('incoming-call', (data) async {
        await NotificationService().displayNotif();
        stateController.sink.add({ "state":StateDataToUI.commingCall.name, "from": data['from'] });
      });

      socket!.on('you-are', (data) async {
        whoAreYouController.sink.add(data['data']['id']);
      });

      socket!.on('rejected_call', (data) => stateController.sink.add({ "state":StateDataToUI.exitCall.name, }) );

  }
  
  static send(){}

}

enum StateDataToUI  { commingCall, exitCall, initiData }
