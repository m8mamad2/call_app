
import 'package:callapp/screen/call_screen.dart';
import 'package:callapp/service/signaling_service.dart';
import 'package:callapp/utils/constans/dialogs.dart';
import 'package:callapp/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {

  TextEditingController numberController = TextEditingController();
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff232323),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20,top: 70),
          child: StreamBuilder(
            stream:  SignalService.whoAreYouController.stream ,
            builder: (context, snapshot) {
              return Row(
                children: [
                  Text('Your Id is: ${snapshot.data ?? ''}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              );
            },
          ),
        ),
          const Expanded(child: SizedBox()),
          Container(
            width: kWidth(context),
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xff2e2e2e),
            alignment: Alignment.center,
            child: Text(
              numberController.text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          dialPadWidget(),
        ],
      )
    );
  }

  Widget dialPadWidget(){
    return  Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
          )),
          child: GridView.builder(
              itemCount: 12,
              shrinkWrap: true,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.6,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3),
              itemBuilder: (context, index) =>
                  oneNumberItemWidget(index)),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 30,top: 6.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              const Expanded(child: SizedBox.shrink()),

              StreamBuilder(
                stream: SignalService.whoAreYouController.stream,
                builder: (context, snapshot) {
                  return Expanded(
                      child: InkWell(
                        onTap: () async{
                          if(numberController.text.isEmpty)return await errorDialgo(context, 'Please Enter a Number !');

                          SignalService.socket?.emit('start-call', {'data':numberController.text.trim()});

                            
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CallScreen(isCaller: true, remoteId: numberController.text,),));

                          },
                        child: Container(
                          padding: const EdgeInsets.all(21),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Colors.green.shade900,
                                Colors.green.shade400,
                              ])),
                          child: const Icon(
                            Icons.call_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                },
              ),

              Expanded(
                child: InkWell(
                  onTap: () =>
                      setState(() => numberController.clear()),
                  child: Container(
                    padding: const EdgeInsets.all(21),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Colors.red.shade900,
                          Colors.red.shade300,
                        ])),
                    child: const Icon(
                      Icons.disabled_by_default_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget oneNumberItemWidget(int index) => InkWell(
        onTap: () {
          String data()=> switch(index){
            10 => '0',
            9  => '*',
            11 => '#',
            _ => ( index + 1 ).toString() };
          
          numberController.text += data();
          setState(() {});
        },
        child: Center(
          child: Text(
            switch(index){
              10 => '0',
              9  => '*',
              11 => '#',
              _ => ( index + 1 ).toString()
            },
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      );

}