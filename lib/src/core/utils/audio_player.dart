// import 'package:assets_audio_player/assets_audio_player.dart';

class AudioPlayer {
  // final AssetsAudioPlayer _assetAudioPlayer;

  Future<void> initialize({required String fileName, bool loop = false}) async {
    // await _assetAudioPlayer.open(
    //   Audio(fileName),
    //   autoStart: false,
    //   loopMode: loop ? LoopMode.single : LoopMode.none,
    // );
  }

  Future<void> play() async {} /*=> await _assetAudioPlayer.play();*/

  Future<void> stop() async {}/*=> await _assetAudioPlayer.stop();*/

  Future<void> dispose() async {
    // await _assetAudioPlayer.dispose();
  }
}
