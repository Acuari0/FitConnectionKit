//Conexion a GoogleFit
// Para conectar dar permisos de health en Xcode de HealthKit
// ver en https://pub.dev/packages/health
// Ing. Johan Guillen
//Contacto +584247510916

/*
* Primero obtener huella digital del certificado de depuracion ejecuntando en la terminal del proyecto
* Para Mac OS o Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
*
* Para windows
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
*
* Despues debemos configurar el proyecto en Google cloud dandole permisos a Google Fit
* Hacer lo que indican estas instrucciones
*
* Ojo vincular el proyecto con Firebase
*
* https://developers.google.com/fit/android/get-api-key?hl=es-419
*
*
* Se puede trabajar con las mismas funciones que Health connection sin embrago primero
* se debe iniciar sesion en google con Oauth2 y haber pedido permisos de ActivityRecognition
* La funcion que pide este permiso esta en HealthConnectAndroid.dart
*
*
* Se pueden usar Las funciones de HealthConnection.dart
*
* */