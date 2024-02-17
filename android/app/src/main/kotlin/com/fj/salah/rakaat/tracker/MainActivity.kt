package com.fj.salah.rakaat.tracker

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.fj.salah.rakaat.tracker/rakaat_tracker"
    }

    private lateinit var sink: EventChannel.EventSink
    private lateinit var myBroadcastReceiver: MyBroadcastReceiver

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize MethodChannel instance
        // Create an EventChannel to send counter update events to Flutter
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink) {
                    sink = eventSink
                }

                override fun onCancel(arguments: Any?) {
                    // Cleanup resources if needed
                }
            })


        broadcastReceiver()
    }

    private fun broadcastReceiver() {
        // Register BroadcastReceiver to listen for screen on broadcasts
        myBroadcastReceiver = MyBroadcastReceiver()
        val filter = IntentFilter(Intent.ACTION_SCREEN_ON)
        filter.addAction(Intent.ACTION_SCREEN_ON)
        registerReceiver(myBroadcastReceiver, filter)
    }

    override fun onResume() {
        super.onResume()
        broadcastReceiver()
    }

    override fun onPause() {
        super.onPause()
        // Unregister the BroadcastReceiver
        unregisterReceiver(myBroadcastReceiver)
    }

    override fun onDestroy() {
        unregisterReceiver(myBroadcastReceiver)
        super.onDestroy()
    }

    private inner class MyBroadcastReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == Intent.ACTION_SCREEN_ON) {
                sink.success("powerButtonPressed")
            }
        }
    }

}
