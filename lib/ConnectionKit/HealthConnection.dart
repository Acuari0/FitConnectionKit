//Conexion a Health Apple
// Para conectar dar permisos de health en Xcode de HealthKit
// ver en https://pub.dev/packages/health
// Ing. Johan Guillen

/*

Apple Health (iOS)
Step 1: Append the Info.plist with the following 2 entries

<key>NSHealthShareUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>

Step 2: Open your Flutter project in Xcode by right clicking on the "ios" folder
 and selecting "Open in Xcode". Next, enable "HealthKit" by adding a capability inside the "Signing & Capabilities" tab of the Runner target's settings.

 */

import 'package:health/health.dart';

HealthFactory health = HealthFactory();

var types = [
  HealthDataType.STEPS,
  HealthDataType.HEART_RATE,
];

var perm = [
  HealthDataAccess.READ_WRITE,
  HealthDataAccess.READ_WRITE,
];


List<HealthDataPoint> healthData=[];

//Request Permision
Future<void> RequestPermissionHealth() async =>await health.requestAuthorization(types,permissions: perm);

//Obtain Steps Interval Total
//Example: Steps_Health_Interval(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
/// Este ejemplo obtiene la cantidad de pasos que el usuario ha hecho en un
// intervalo.
// Se puede utilizar para intervalos mas pequeños.
// Retorna -1 si no encuentra pasos

Future<double> Steps_Health_Interval_Total(DateTime start_date, DateTime final_date) async{
  try{
      healthData = await health.getHealthDataFromTypes(
          start_date,final_date, [HealthDataType.STEPS]);

      double steps=0;
      healthData.forEach((element) {
        steps+=double.tryParse(element.value.toString())!;
      });
      return steps;
    }catch(e){
      print("Error Obtaining Steps Total Health -> $e");
      return -1;
    }
}

//Obtain Steps Interval
//Example: Steps_Health_Interval(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
//Obtiene lista de pasos en un intervalo
//retorna Lista de double, si falla retorna lista vacia


Future<List<double>> Steps_Health_Interval(DateTime start_date, DateTime final_date) async{
  try{
    healthData = await health.getHealthDataFromTypes(
        start_date,final_date, [HealthDataType.STEPS]);
    return healthData.map((e) => double.tryParse(e.value.toString()) as double).toList();
  }catch(e){
    print("Error Obtaining Steps Interval Health -> $e");
    return [];
  }
}

//Obtain Steps All
//Example: Steps_Health_All(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
//Obtiene lista de pasos con todas las propiedades como
// fecha, device , ect en un intervalo
//retorna Lista de HealthDataPoint, si falla retorna lista vacia


Future<List<HealthDataPoint>> Steps_Health_All(DateTime start_date, DateTime final_date) async{
  try{
    healthData = await health.getHealthDataFromTypes(
        start_date,final_date, [HealthDataType.STEPS]);

    return healthData;
  }catch(e){
    print("Error Obtaining Steps ALL Health -> $e");
    return [];
  }
}

//Obtain Heart Rate All
//Example: HR_Health_All(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
//Obtiene lista de HR con todas las propiedades como
// fecha, device , ect en un intervalo
//retorna Lista de HealthDataPoint, si falla retorna lista vacia


Future<List<HealthDataPoint>> HR_Health_All(DateTime start_date, DateTime final_date) async{
  try{
    healthData = await health.getHealthDataFromTypes(
        start_date,final_date, [HealthDataType.HEART_RATE]);

    return healthData;
  }catch(e){
    print("Error Obtaining Heart Rate ALL Health -> $e");
    return [];
  }
}


//Obtain HeartRate Interval
//Example: HR_Health_Interval(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
//Obtiene lista de Pulso cardiaco en un intervalo
//retorna Lista de double, si falla retorna lista vacia


Future<List<double>> HR_Health_Interval(DateTime start_date, DateTime final_date) async{
  try{
    healthData = await health.getHealthDataFromTypes(
        start_date,final_date, [HealthDataType.HEART_RATE]);
    return healthData.map((e) => double.tryParse(e.value.toString()) as double).toList();
  }catch(e){
    print("Error Obtaining Heart Rate Health -> $e");
    return [];
  }
}

//Obtain Actual Heart Rate
//Example: HR_Health_Interval_Last(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
/// Este ejemplo obtiene el  ultimo pulso del usuario basandose en un intervalo de tiempo
// Se puede utilizar para intervalos mas pequeños.
// Retorna -1 si no encuentra pasos

Future<double> HR_Health_Interval_Last(DateTime start_date, DateTime final_date) async =>
    await HR_Health_Interval(start_date, final_date).then((value) => value.last);


//Obtain Device Steps List
//Example: Steps_Health_Device(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
/// Este ejemplo obtiene el nombre de todos los dipositivos que ha
/// enviado los datos de los pasos que el usuario ha hecho en un
// intervalo .
// Se puede utilizar para intervalos mas pequeños.
// Retorna [] si no encuentra pasos
Future<List<String>> Steps_Health_Device(DateTime start_date, DateTime final_date) async{
  try{
    healthData = await health.getHealthDataFromTypes(
        start_date,final_date, [HealthDataType.STEPS]);
    return healthData.map((e) => e.deviceId).toList();
  }catch(e){
    print("Error Obtaining Device Steps Health -> $e");
    return [];
  }
}

//Obtain Device Steps
//Example: Steps_Health_Device_Last(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
/// Este ejemplo obtiene el nombre del ultimo dipositivo que ha
/// enviado los datos de los pasos que el usuario ha hecho en un
// .
// Se puede utilizar para intervalos mas pequeños.
// Retorna "" si no encuentra pasos
Future<String> Steps_Health_Device_Last(DateTime start_date, DateTime final_date) async=>
await Steps_Health_Device(start_date, final_date).then((value) => value.last);
/*{
  /try{
    healthData = await health.getHealthDataFromTypes(
        start_date,final_date, [HealthDataType.STEPS]);

    return healthData.last.deviceId;
  }catch(e){
    print("Error Obtaining Device Steps Health -> $e");
    return '';
  }
}*/

//Obtain Device Heart Rate List
//Example: HR_Health_Device(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
/// Este ejemplo obtiene el nombre de todos los dipositivos que ha
/// enviado los datos de la frecuencia cardiaca que el usuario ha hecho en un
// intervalo .
// Se puede utilizar para intervalos mas pequeños.
// Retorna [] si no encuentra pasos
Future<List<String>> HR_Health_Device(DateTime start_date, DateTime final_date) async{
  try{
    healthData = await health.getHealthDataFromTypes(
        start_date,final_date, [HealthDataType.HEART_RATE]);
    return healthData.map((e) => e.deviceId).toList();
  }catch(e){
    print("Error Obtaining Device Heart Rate Health -> $e");
    return [];
  }
}

//Obtain Device Heart Rate
//Example: HR_Health_Device_Last(DateTime(2023,8,31,0,0,0,0,0),DateTime(2023,8,31,23,59,59,59,59))
/// Este ejemplo obtiene el nombre del ultimo dipositivo que ha
/// enviado los datos de los pasos que el usuario ha hecho en un
// .
// Se puede utilizar para intervalos mas pequeños.
// Retorna "" si no encuentra pasos
Future<String> HR_Health_Device_Last(DateTime start_date, DateTime final_date) async=>
    await HR_Health_Device(start_date, final_date).then((value) => value.last);
/*{
  /try{
    healthData = await health.getHealthDataFromTypes(
        start_date,final_date, [HealthDataType.STEPS]);

    return healthData.last.deviceId;
  }catch(e){
    print("Error Obtaining Device Steps Health -> $e");
    return '';
  }
}*/

//Obtain Steps Day
//Example: Steps_Health_Day()
/// Este ejemplo obtiene los pasos del ultimo dipositivo que ha
/// enviado los datos de los pasos que el usuario ha hecho en un dia
// Retorna -1 si no encuentra pasos
Future<double> Steps_Health_Day() async=>
    await Steps_Health_Interval_Total(
        DateTime(DateTime.now().year,
        DateTime.now().month,DateTime.now().day, 0,0,0,0,0),
        DateTime(DateTime.now().year,
            DateTime.now().month,DateTime.now().day, 23,59,59,59,59))
        .then((value) => value);

//Obtain HR Day
//Example: HR_Health_Day()
/// Este ejemplo obtiene el HR el ultimo dipositivo que ha
/// enviado los datos de los pasos que el usuario ha hecho en un dia
// Retorna -1 si no encuentra pasos
Future<double> HR_Health_Day() async=>
    await HR_Health_Interval_Last(
        DateTime(DateTime.now().year,
            DateTime.now().month,DateTime.now().day, 0,0,0,0,0),
        DateTime(DateTime.now().year,
            DateTime.now().month,DateTime.now().day, 23,59,59,59,59))
        .then((value) => value);


//Escribir Paso y heartRate solo para pruebas
// Habilitar esribir en los permisos
Future<void>Write_Health() async{
  await health.writeHealthData(2000,HealthDataType.STEPS,DateTime.now().add(Duration(minutes: -1)),DateTime.now());
  await health.writeHealthData(85,HealthDataType.HEART_RATE,DateTime.now().add(Duration(minutes: -1)),DateTime.now());
}





