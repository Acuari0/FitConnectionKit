//Conexion a Health deste android
// Conectarse a Health desde android
// Ing. Johan Guillen
//Contacto +584247510916


/*
* Para poder utilizar HealthConnect en android se requerian los siguientes
* primer añadir la siguientes dependencia permission_handler: ^10.4.3
* despues pedir permisos en el Androidmanifest de la app

*
    <uses-permission android:name="android.permission.health.READ_HEART_RATE"/>
    <uses-permission android:name="android.permission.health.WRITE_HEART_RATE"/>
    <uses-permission android:name="android.permission.health.READ_STEPS"/>
    <uses-permission android:name="android.permission.health.WRITE_STEPS"/>
    <uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
* Cambiamos el gradle.properties a Android X
  org.gradle.jvmargs=-Xmx1536M
  android.enableJetifier=true
  android.useAndroidX=true
*
* Recordar pedir permisos de actividad
* con la siguiente funcion
*
*
* Para el HealthConnect de android se ppueden usar las funciones del archivo HealthConnection
* */

import 'package:permission_handler/permission_handler.dart';

Future<void> RequestPermissionActivityRecog() async =>await Permission.activityRecognition.request();

