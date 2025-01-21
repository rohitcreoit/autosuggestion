import 'package:flutter/material.dart';
import '../service/text_classifier.dart';

class TextClassifierScreen extends StatefulWidget {
  @override
  _TextClassifierScreenState createState() => _TextClassifierScreenState();
}

class _TextClassifierScreenState extends State<TextClassifierScreen> {
  final TextEditingController _controller = TextEditingController();
  final TFLiteTextClassifier _classifier = TFLiteTextClassifier();

  String _result = "Enter a sentence to classify";

  @override
  void initState() {
    super.initState();
    _classifier.loadModelAssets().then((_) {
      setState(() {
        _result = "Model loaded successfully!";
      });
    }).catchError((error) {
      setState(() {
        _result = "Error loading model: $error";
      });
    });
  }

  void _classifyText() {
    final inputText = _controller.text;
    if (inputText.isEmpty) {
      setState(() {
        _result = "Please enter some text.";
      });
      return;
    }

    final result = _classifier.classifyText(inputText);
    setState(() {
      _result = "Predicted Label: $result";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Classifier')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter text",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _classifyText,
              child: Text('Classify'),
            ),
            SizedBox(height: 16),
            Text(_result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
