import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../errors/app_exceptions.dart';
import '../utils/logger.dart';

abstract class AccessibilityService {
  Future<void> initialize();
  Future<void> speak(String text);
  Future<void> stopSpeaking();
  Future<bool> isSpeaking();
  Future<void> startListening(Function(String) onResult);
  Future<void> stopListening();
  Future<bool> isListening();
  Future<bool> isSpeechAvailable();
  void setSpeechRate(double rate);
  void setSpeechPitch(double pitch);
  void setSpeechVolume(double volume);
}

class AccessibilityServiceImpl implements AccessibilityService {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _stt = stt.SpeechToText();
  
  bool _ttsInitialized = false;
  bool _sttInitialized = false;
  bool _isListening = false;
  
  @override
  Future<void> initialize() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _ttsInitialized = true;
      
      _sttInitialized = await _stt.initialize(
        onError: (error) => AppLogger.e('Speech recognition error', error),
        onStatus: (status) => AppLogger.d('Speech recognition status: $status'),
      );
      
      AppLogger.i('Accessibility service initialized');
    } catch (e) {
      AppLogger.e('Failed to initialize accessibility service', e);
      throw CacheException('Failed to initialize accessibility service');
    }
  }
  
  @override
  Future<void> speak(String text) async {
    if (!_ttsInitialized) await initialize();
    await _tts.speak(text);
  }
  
  @override
  Future<void> stopSpeaking() async {
    await _tts.stop();
  }
  
  @override
  Future<bool> isSpeaking() async {
    return await _tts.isSpeaking ?? false;
  }
  
  @override
  Future<void> startListening(Function(String) onResult) async {
    if (!_sttInitialized) {
      await initialize();
    }
    
    if (_isListening) return;
    
    _isListening = true;
    await _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
          _isListening = false;
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }
  
  @override
  Future<void> stopListening() async {
    await _stt.stop();
    _isListening = false;
  }
  
  @override
  Future<bool> isListening() async {
    return _isListening;
  }
  
  @override
  Future<bool> isSpeechAvailable() async {
    return _sttInitialized;
  }
  
  @override
  void setSpeechRate(double rate) {
    _tts.setSpeechRate(rate.clamp(0.0, 1.0));
  }
  
  @override
  void setSpeechPitch(double pitch) {
    _tts.setPitch(pitch.clamp(0.5, 2.0));
  }
  
  @override
  void setSpeechVolume(double volume) {
    _tts.setVolume(volume.clamp(0.0, 1.0));
  }
}

