import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  String soundVol = '';

  @override
  void initState() {
    super.initState();
    _noiseMeter = new NoiseMeter(onError);
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    //print(noiseReading.toString());
    String soundVolStr = noiseReading.toString();
    int IndOfMeanDB = soundVolStr.indexOf('- meanDecibel:');
    soundVol =
        '    dB: ' + soundVolStr.substring(IndOfMeanDB + 14, IndOfMeanDB + 19);
  }

  void onError(Object error) {
    //print(error.toString());
    _isRecording = false;
  }

  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      //print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      //print('stopRecorder error: $err');
    }
  }

  final textStyle = const TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.black,
    fontSize: 45,
    fontWeight: FontWeight.bold,
  );

  final headerStyle = const TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.black,
    fontSize: 45,
    //fontWeight: FontWeight.bold,
  );

  final btnTextStyle = const TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white,
    fontSize: 25,
  );

  List<Widget> getContent() => <Widget>[
        Container(
            margin: EdgeInsets.all(5),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 96.0,
                height: 96.0,
                alignment: Alignment.topCenter,
                child: Image(
                    image: AssetImage('assets/noise_meter_ico_big_3.png')),
              ),
              const SizedBox(height: 30),
              Container(
                  alignment: Alignment.topCenter,
                  // child: Image(image: AssetImage('assets/logo_small_15perc.jpg')),
                  child: Text(
                    'Noise meter',
                    style: headerStyle,
                  )),
              const SizedBox(height: 130),
              Row(
                  mainAxisAlignment: _isRecording
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.all(15),
                        child: Text(
                          _isRecording ? soundVol : "No input",
                          style: textStyle,
                        )),
                  ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 90),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              Colors.black, //change background color of button
                          onPrimary: Colors.white, //change text color of button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 15.0,
                        ),
                        onPressed: _isRecording ? stop : start,
                        child: _isRecording
                            ? Text(
                                'Stop  listening',
                                style: btnTextStyle,
                              )
                            : Text(
                                'Start  listening',
                                style: btnTextStyle,
                              ),
                      ),
                    ],
                  ),
                ),
              ]),
            ]))
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Orbitron'),
      home: Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getContent())),
      ),
    );
  }
}
