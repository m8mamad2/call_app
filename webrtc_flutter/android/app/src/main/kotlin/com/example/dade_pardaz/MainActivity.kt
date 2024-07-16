package com.example.callapp
import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val Channel = "flutter_channel"
    private val rebootReceiver = RebootReceiver()


    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(rebootReceiver);
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Channel)
                .setMethodCallHandler{ call, res ->

                    if(call.method.equals("resssss")){

                        Log.e("123456789", " Calling Method")
                        val intentFilter = IntentFilter(Intent.ACTION_SHUTDOWN).apply { addAction(Intent.ACTION_REBOOT) }
                        registerReceiver(rebootReceiver, intentFilter);

                        val sharedPrefences = context.getSharedPreferences("sharedPref", Context.MODE_PRIVATE)
                        val isExist = sharedPrefences.getBoolean("isFirstTime", true);

                        if(!isExist){
                            sharedPrefences.edit().putBoolean("isFirstTime", true).apply();
                            restartApp(context)
                        }
                        Log.e("123456789", "is Exist Value in After IF Condition is $isExist")

                    }

                }
    }
}



fun restartApp(context:Context, ){

    val sharedPrefences = context.getSharedPreferences("sharedPref", Context.MODE_PRIVATE)
    sharedPrefences.edit().putBoolean("isFirstTime", true).apply();

    val isExist = sharedPrefences.getBoolean("isFirstTime", false);


    context.startActivity(
            Intent.makeRestartActivityTask(
                    (context.packageManager.getLaunchIntentForPackage(context.packageName))!!.component
            )
    )
    Runtime.getRuntime().exit(0)
}

class RebootReceiver: BroadcastReceiver(){
    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent!!.action == Intent.ACTION_SHUTDOWN || intent.action == Intent.ACTION_REBOOT){
            val sharedpreferences = context?.getSharedPreferences("sharedPref", Context.MODE_PRIVATE)
            sharedpreferences!!.edit().putBoolean("isFirstTime", false).apply();
        }
    }

}





// SECOND ----------------------------

//
//package com.example.callapp
//
//import android.app.Activity
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import android.content.IntentFilter
//import android.os.Bundle
//import android.os.PersistableBundle
//import android.util.Log
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.android.FlutterFragmentActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import kotlin.system.exitProcess
//
//class MainActivity: FlutterActivity() {
//
//    private val Channel = "flutter_channel"
//    private val rebootReceiver = RebootReceiver()
//
//
//    override fun onDestroy() {
//        super.onDestroy()
//        unregisterReceiver(rebootReceiver);
//    }
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Channel)
//                .setMethodCallHandler{ call, res ->
//
//                    if(call.method.equals("resssss")){
//
//                        Log.e("123456789", " Calling Method")
//                        val intentFilter = IntentFilter(Intent.ACTION_SHUTDOWN).apply { addAction(Intent.ACTION_REBOOT) }
//                        registerReceiver(rebootReceiver, intentFilter);
//
//
//                        restartApp(context)
//
//
//                    }
//
//                }
//    }
//}
//
//
//
//fun restartApp(context:Context, ){
//
//    val sharedPrefences = context.getSharedPreferences("sharedPref", Context.MODE_PRIVATE)
//    val isExist = sharedPrefences.getBoolean("isFirstTime", true);
//    Log.e("123456789", "First Get Data $isExist")
//    if(!isExist){
//
//        sharedPrefences.edit().putBoolean("isFirstTime", true).apply();
//
//
//        val isExist2 = sharedPrefences.getBoolean("isFirstTime", true)
//        Log.e("123456789", "Second Get Data $isExist2")
//
//
//        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
//        launchIntent?.let {
//            it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
//            it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//            context.startActivity(it)
//        }
//
//        android.os.Process.killProcess(android.os.Process.myPid())
//        exitProcess(0)
//
//
//    }
//}
//
//class RebootReceiver: BroadcastReceiver(){
//    override fun onReceive(context: Context?, intent: Intent?) {
//        if(intent!!.action == Intent.ACTION_SHUTDOWN || intent.action == Intent.ACTION_REBOOT){
//            val sharedpreferences = context?.getSharedPreferences("sharedPref", Context.MODE_PRIVATE)
//            sharedpreferences!!.edit().putBoolean("isFirstTime", false).apply();
//        }
//    }
//
//}


// THIRED
//package com.example.callapp
//
//import android.app.Activity
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import android.content.IntentFilter
//import android.os.Bundle
//import android.os.PersistableBundle
//import android.util.Log
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.android.FlutterFragmentActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import kotlin.system.exitProcess
//
//class MainActivity: FlutterActivity() {
//
//    private val Channel = "flutter_channel"
//    private val rebootReceiver = RebootReceiver()
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        val intentFilter = IntentFilter(Intent.ACTION_SHUTDOWN).apply {addAction(Intent.ACTION_REBOOT)}
//        registerReceiver(rebootReceiver, intentFilter)
//
//
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        unregisterReceiver(rebootReceiver);
//    }
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Channel)
//                .setMethodCallHandler{ call, res ->
//
//                    if(call.method.equals("resssss")){
//
//                        Log.e("123456789", " Calling Method")
//                        val intentFilter = IntentFilter(Intent.ACTION_SHUTDOWN).apply { addAction(Intent.ACTION_REBOOT) }
//                        registerReceiver(rebootReceiver, intentFilter);
//
//
//                        restartApp(context)
//
//
//                    }
//
//                }
//    }
//}
//
//
//
//fun restartApp(context:Context, ){
//    val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
//    launchIntent?.let {
//        it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
//        it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//        context.startActivity(it)
//    }
//
//    android.os.Process.killProcess(android.os.Process.myPid())
//    exitProcess(0)
//}
//
//class RebootReceiver: BroadcastReceiver(){
//    override fun onReceive(context: Context?, intent: Intent?) {
//        if(intent!!.action == Intent.ACTION_BOOT_COMPLETED){
//            Thread.sleep(20000)
//            Log.e("123456789", "in Booting Complete")
//            Thread.sleep(150000)
//            Log.e("123456789", "in Booting Complete")
//            restartApp(context!!)
//        }
//    }
//
//}
//









