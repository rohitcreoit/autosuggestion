import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteTextClassifier {
  late Map<String, int>
      _textVectorizer; // Holds the vocabulary for text vectorization
  late List<String> _labelEncoder; // Holds the list of label classes
  late Interpreter _interpreter; // TFLite interpreter for inference

  /// Load assets (vectorizer JSON, label encoder JSON, and TFLite model)
  Future<void> loadModelAssets() async {
    // Load vectorizer JSON
    final vectorizerJson =
        await rootBundle.loadString('assets/text_vectorizer.json');
    _textVectorizer = Map<String, int>.from(jsonDecode(vectorizerJson));

    // Load label encoder JSON
    final labelEncoderJson =
        await rootBundle.loadString('assets/label_encoder.json');
    _labelEncoder = List<String>.from(jsonDecode(labelEncoderJson));

    // Load the TFLite model
    _interpreter = await Interpreter.fromAsset('assets/new_model.tflite');
  }

  /// Preprocess input text into a vectorized representation
  List<double> _preprocess(String inputText) {
    // Tokenize the input text
    final tokens = inputText.toLowerCase().split(' ');

    // Create a one-hot encoded vector based on the vocabulary
    final vectorizedInput = List<double>.generate(
      _textVectorizer.length,
      (index) =>
          tokens.contains(_textVectorizer.keys.elementAt(index)) ? 1.0 : 0.0,
    );

    return vectorizedInput;
  }

  String classifyText(String inputText) {
    final inputVector = _preprocess(inputText);

    final input = [inputVector]; // TFLite expects a batch of inputs
    final output = List<double>.filled(_labelEncoder.length, 0.0)
        .reshape([1, _labelEncoder.length]);

    _interpreter.run(input, output);

    print("Input is: $input");
    print("Output is: $output");

    // Ensure output[0] is typed as List<double>
    final outputList = output[0] as List<double>;

    final predictedIndex =
        outputList.indexOf(outputList.reduce((a, b) => a > b ? a : b));

    return _labelEncoder[predictedIndex];
  }

  /// Clean up resources
  void dispose() {
    _interpreter.close();
  }
}
