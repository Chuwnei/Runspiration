package com.example.app

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class SensorService(private val flutterEngine: FlutterEngine) {
    private var sensorManager: SensorManager? = null
    private var stepCounterSensor: Sensor? = null
    private var sensorEventListener: SensorEventListener? = null

    private val methodChannel: MethodChannel = MethodChannel(flutterEngine.dartExecutor, "com.example/sensor")

    init {
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startUpdates" -> startUpdates(result)
                "stopUpdates" -> stopUpdates(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun startUpdates(result: MethodChannel.Result) {
        sensorManager = flutterEngine.applicationContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        stepCounterSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)

        sensorEventListener = object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

            override fun onSensorChanged(event: SensorEvent?) {
                if (event != null && event.sensor.type == Sensor.TYPE_STEP_COUNTER) {
                    methodChannel.invokeMethod("sensorUpdate", event.values[0].toInt())
                }
            }
        }

        sensorManager?.registerListener(sensorEventListener, stepCounterSensor, SensorManager.SENSOR_DELAY_NORMAL)
        result.success(null)
    }

    private fun stopUpdates(result: MethodChannel.Result) {
        sensorManager?.unregisterListener(sensorEventListener)
        result.success(null)
    }
}
