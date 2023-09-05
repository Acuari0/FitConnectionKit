//Conexion a un reloj
// Para conectar dar permisos de health en Xcode de HealthKit
// ver en https://pub.dev/packages/health
// Ing. Johan Guillen
//Contacto +584247510916
/*
  Conectividad con reloj ver en
  https://pub.dev/packages/watch_connectivity/example

  Primero se debe agregar la dependecia
  watch_connectivity: ^0.1.6

  En su defecto la conectividad se manejara en base a la clase
  WatchConnection por lo que para utilizarla es necesario que se declare
  dicha clase

  Ejemplo

  WatchConnection _watch= WatchConnection ([], Timer(), WatchConnectivity());

  En el InitState vamos a utilizar cualquiera de los InitConnect

  InitConnectAll() Es un stream que escucha mensajes y contexto
  InitConnectOnlyMessage() Es un stream que escucha mensajes y contexto
  InitConnectOnlyConxtext() Es un stream que solo escucha el contexto

  IMPORTANTE cada una de estas funciones debe ser Acompañado por un setState

  Generalmente las key que se le pasa a las funciones sendMessage,
  sendContext, ActiveBackgroundMessaging es "data";

  Ver ejemplo en https://pub.dev/packages/watch_connectivity/example

 */
import 'dart:async';
import 'package:watch_connectivity/watch_connectivity.dart';


class WatchConnection{
  List<String> _log;
  Timer timer;
  WatchConnectivity _watch;
  // Constructor Ej WatchConnection ([], Timer(), WatchConnectivity());
  WatchConnection(this._log, this.timer, this._watch);

  //Numero de mensajes de acuerdo al contexto
  int _count=0;

//InitConnectAll() Es un stream que escucha mensajes y contexto
  InitConnectAll(){
    ListenMessageStream();
    ListenContextStream();
    initPlatformState();
  }

  //InitConnectOnlyMessage() Es un stream que escucha mensajes y contexto
  InitConnectOnlyMessage(){
    ListenMessageStream();
    initPlatformState();
  }

  // InitConnectOnlyConxtext() Es un stream que solo escucha el contexto
  InitConnectOnlyContext(){
    ListenContextStream();
    initPlatformState();
  }

  //Se puede soportar la version del reloj?
  Future<bool> isSupported() async =>await _watch.isSupported;
  //Esta emparejado?
  Future<bool> isPaired() async =>await _watch.isPaired;
  //Es buscable?
  Future<bool> isReachable() async =>await _watch.isReachable;
  // Contexto del appWatch
  Future<Map<String, dynamic>> AppWatchContext() async =>await _watch.applicationContext;
  //Contextos recibidos
  Future<List<Map<String, dynamic>>> receivedContextWatch() async =>await _watch.receivedApplicationContexts;

  //Stream para escuchar mensajes
  ListenMessageStream(){
    _watch.messageStream
        .listen((e) => _log.add('Received message: $e'));
  }

  //Stream para escuchar contextos
  ListenContextStream(){
    _watch.contextStream
        .listen((e) =>  _log.add('Received context: $e'));
  }

  //Iniciar plataforma asegurarse que no haya error y que todo este trabajado bien
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

  //Enviar mensaje al reloj por lo general el valor de key es "data"
  void sendMessage(String key , String data) {
    final message = {key: data};
    _watch.sendMessage(message);
    _log.add('Sent message: $message');
  }

  //Enviar contexto al reloj por lo general el valor de key es "data"
  void sendContext(String key) {
    _count++;
    final context = {key: _count};
    _watch.updateApplicationContext(context);
    _log.add('Sent context: $context');
  }

  //Activar mensajes programados por lo general el mensaje de key es "data"
  //Su funcion es mandar mensaje cada cierto tiempo especificado, el periodo es determinado
  //por la varaiable miliseconds
  void ActiveBackgroundMessaging(String key, String data, int miliseconds) {
    if (!timer.isActive) {
      timer = Timer.periodic( Duration(milliseconds: miliseconds), (_) => sendMessage(key, data));
    }
  }

  //Desactivar mensajes programados
  void DesactivateBackgroundMessaging(){
    timer.cancel();
  }
}

