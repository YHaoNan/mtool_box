import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:wave_generator/wave_generator.dart';

class NotePlayer{
  static final noteFrequency = [
    261.63,277.18,293.66,311.13,329.63,349.23,369.99,392.00,415.30,440.00,466.16,493.88
  ];
  static AudioPlayer audioPlayer = AudioPlayer();
  Future<void> play(List<int> notesIds) async {
    var generator = WaveGenerator(44100, BitDepth.Depth8bit);
    final notes = notesIds.map((id)=>Note(id>=notesIds[0] ? noteFrequency[id] : noteFrequency[id] * 2, 200, Waveform.Sine, 1.0)).toList();
    List<int> bytes = [];
    await for(int byte in generator.generateSequence(notes)){
      bytes.add(byte);
    }
    await audioPlayer.playBytes(Uint8List.fromList(bytes));
  }
}