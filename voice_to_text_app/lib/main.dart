import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(VoiceToTextApp());
}

class VoiceToTextApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice to Text App',
      debugShowCheckedModeBanner: false,
      home: VoiceHomePage(),
    );
  }
}

class VoiceHomePage extends StatefulWidget {
  @override
  _VoiceHomePageState createState() => _VoiceHomePageState();
}

class _VoiceHomePageState extends State<VoiceHomePage> {
  late stt.SpeechToText _speech;
  bool isListening = false;
  String _text = "Press the button and start speaking";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('Status: $val'),
        onError: (val) => print('Error: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice to Text App'),
        backgroundColor: Colors.cyanAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        backgroundColor: Colors.yellow,
        child: Icon(isListening ? Icons.mic : Icons.mic_none),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(20.0),
        child: Text(
          _text,
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
