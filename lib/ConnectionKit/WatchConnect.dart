//Conexion a un reloj
// Para conectar dar permisos de health en Xcode de HealthKit
// ver en https://pub.dev/packages/health
// Ing. Johan Guillen
//Contacto +584247510916

import 'dart:async';

import 'package:watch_connectivity/watch_connectivity.dart';


class WatchConnection{
  List<String> _log;
  Timer timer;
  WatchConnectivity _watch;
  WatchConnection(this._log, this.timer, this._watch);
  int _count=0;

  Future<bool> isSupported() async =>await _watch.isSupported;
  Future<bool> isPaired() async =>await _watch.isPaired;
  Future<bool> isReachable() async =>await _watch.isReachable;
  Future<Map<String, dynamic>> AppWatchContext() async =>await _watch.applicationContext;
  Future<List<Map<String, dynamic>>> receivedContextWatch() async =>await _watch.receivedApplicationContexts;


  void initPlatformState() async {
    isSupported().then((value) {
      value?print("Es Soportable"):print("Reloj No soportable");
      isPaired().then((value) {
        value?print("Esta emparejadp"):print("Reloj no esta emparejado");
        isReachable().then((value) {
          value?print("Es Encontrable"):print("Reloj No es encontrable");
          AppWatchContext().then((value) {
            print("Contexto de la AppWatch ${value.toString()}");
            receivedContextWatch().then((value) {
              print("Contexto Recibido ${value.toString()}");
            });
          });
        });
      });
    });
  }

  void sendMessage(String key , String data) {
    final message = {key: data};
    _watch.sendMessage(message);
    _log.add('Sent message: $message');
  }

  void sendContext(String key) {
    _count++;
    final context = {key: _count};
    _watch.updateApplicationContext(context);
    _log.add('Sent context: $context');
  }

  void ActiveBackgroundMessaging(String key, String data) {
    if (!timer.isActive) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) => sendMessage(key, data));
    }
  }
  void DesactivateBackgroundMessaging(){
    timer.cancel();
  }
}

