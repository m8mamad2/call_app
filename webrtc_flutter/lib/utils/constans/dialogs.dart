import 'dart:async';

import 'package:callapp/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

Future errorDialgo(BuildContext context,String erroMsg)async=> await showAdaptiveDialog(
    context: context, 
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline,color: Colors.red,size: kWidth(context)*0.2,),
          const SizedBox(height: 15,),
          Container(
            constraints: BoxConstraints(minHeight: kHeight(context)*0.1),
            width: kWidth(context),
            child: Text(erroMsg,textAlign: TextAlign.center,textDirection: TextDirection.rtl,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14,),), ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: Navigator.of(context).pop, 
            style: ElevatedButton.styleFrom(
              minimumSize: Size(kWidth(context), 40),
              backgroundColor: const Color(0xff0a212d),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                
              )
            ),
            child: Text('ok',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),))
        ],
      ),
  ),);
