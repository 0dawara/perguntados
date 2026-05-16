import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playClick() async {
    try {
      await _player.play(AssetSource('sounds/click.mp3'));
    } catch (_) {
      // Ignore if file not found
    }
  }

  static Future<void> playCorrect() async {
    try {
      await _player.play(AssetSource('sounds/correct.mp3'));
    } catch (_) {
      // Ignore if file not found
    }
  }

  static Future<void> playIncorrect() async {
    try {
      await _player.play(AssetSource('sounds/incorrect.mp3'));
    } catch (_) {
      // Ignore if file not found
    }
  }

  static Future<void> playSpin() async {
    try {
      await _player.play(AssetSource('sounds/spin.mp3'));
    } catch (_) {
      // Ignore if file not found
    }
  }
}
