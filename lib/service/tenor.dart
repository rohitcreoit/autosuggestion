// import 'package:tflite/tflite.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart'; // For loading assets
// class NLPModel {
//   late Map<String, dynamic> tokenizer;
//   // Load the TFLite model and tokenizer
//   Future<void> loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/models/model.tflite",
//     );
//     // Load and parse the tokenizer
//     String jsonString = await rootBundle.loadString('assets/models/tokenizer.json');
//     tokenizer = jsonDecode(jsonString);
//   }
//   // Convert input text to sequence
//   List<int> textToSequence(String text) {
//     List<int> sequence = [];
//     List<String> words = text.toLowerCase().split(" ");
//     words.forEach((word) {
//       if (tokenizer['word_index'].containsKey(word)) {
//         sequence.add(tokenizer['word_index'][word]);
//       }
//     });
//     return sequence;
//   }
// }