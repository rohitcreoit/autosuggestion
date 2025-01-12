import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
class TensorFlowService {
  late Interpreter _interpreter;
  late Map<String, dynamic> _tokenizer;
  late int maxSequenceLength;
  Future<void> loadModel() async {
    try{
      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      // Load tokenizer
      String tokenizerJson = await rootBundle.loadString('assets/tokenizer.json');
      _tokenizer = json.decode(tokenizerJson);
      maxSequenceLength = _interpreter.getInputTensor(0).shape[1]; // Get input length
    }catch(e){
      print("load model error $e");
    }

  }



  List? suggestWords(String inputText, {int topN = 3}) {
    // Tokenize the input text
    List<int> inputSequence = _tokenizer['word_index']
        .entries
        .where((entry) => inputText.split(' ').contains(entry.key))
        .map((entry) => entry.value)
        .toList();
    // Pad the sequence
    List<int> paddedSequence = List<int>.filled(maxSequenceLength - 1, 0);
    for (int i = 0; i < inputSequence.length; i++) {
      if (i < maxSequenceLength - 1) {
        paddedSequence[maxSequenceLength - 1 - inputSequence.length + i] = inputSequence[i];
      }
    }
    // Run the inference
    final inputTensor = [paddedSequence];
    final outputTensor = List.filled(_interpreter.getOutputTensor(0).shape[1], 0.0);
    _interpreter.run(inputTensor, [outputTensor]);
    // Get the top N predictions
    List<int> topIndices = _getTopIndices(outputTensor, topN);
    // Convert indices to words
    return topIndices
        .where((index) => _tokenizer['index_word'].containsKey(index))
        .map((index) => _tokenizer['index_word'][index])
        .toList();
  }
  List<int> _getTopIndices(List<double> predictions, int topN) {
    List<int> indices = List.generate(predictions.length, (index) => index);
    indices.sort((a, b) => predictions[b].compareTo(predictions[a]));
    return indices.take(topN).toList();
  }
}