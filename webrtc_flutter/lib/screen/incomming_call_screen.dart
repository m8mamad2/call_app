import 'package:callapp/screen/call_screen.dart';
import 'package:callapp/utils/constans/sizes.dart';
import 'package:callapp/utils/widget/animated_circle_button.dart';
import 'package:flutter/material.dart';

class IncommingCallScreen extends StatelessWidget {
  final String? fromId;
  const IncommingCallScreen({super.key, required this.fromId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0a212d),
      appBar: AppBar(backgroundColor: const Color(0xff0a212d),),
      body: Center(
        child: Column(
          children: [

            CircleAvatar(
              radius: kWidth(context)*0.2,
              backgroundColor: const Color(0xff314953),
              child: Icon(Icons.person_outline, size: kWidth(context)*0.15,color: Colors.white,),
            ),

            const SizedBox(height: 20,),
            const Text('Call Form',style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w400),),
            const Text('HOME',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold , fontSize: 22),),
            
            const Spacer(),

            Container(
              margin:  EdgeInsets.only(bottom: kHeight(context)*0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AvatarGlow(
                      child: Material(
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: (){
                            // FlutterBackgroundService().invoke('accept-call', {'data':fromId});
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CallScreen(isCaller: false, remoteId: fromId,),));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: [
                                    Colors.green.shade900,
                                    Colors.green.shade400,
                                  ])),
                              child: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AvatarGlow(
                      child: Material(
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: ()async{
                            // await NotificationService().cancleAllNotif();
                            // FlutterBackgroundService().invoke('deny-call',{'data':fromId})
                            ;},
                            
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [
                                  Colors.red.shade900,
                                  Colors.red.shade300,
                                ])),
                            child: const Icon(
                              Icons.call_end_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          
          ],
        ),
      ),
    );
  }
  ButtonStyle style(Color color)=> ElevatedButton.styleFrom(  backgroundColor:  color,  );
}
