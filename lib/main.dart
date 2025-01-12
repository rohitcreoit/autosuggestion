import 'package:autosuggestiontest/service/tensorflow.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SuggestionScreen(),
    );
  }
}

class SuggestionScreen extends StatefulWidget {
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final TextEditingController _controller = TextEditingController();
  TensorFlowService _tensorFlowService = TensorFlowService();
  List? _suggestions = [];
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _tensorFlowService.loadModel();
    setState(() {
      _modelLoaded = true;
    });
  }

  void _getSuggestions() {
    if (_controller.text.isEmpty || !_modelLoaded) return;
    final suggestions =
        _tensorFlowService.suggestWords(_controller.text, topN: 3);
    print(suggestions?.length.toString());
    setState(() {
      _suggestions = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auto Suggestion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Type something",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _getSuggestions,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Suggestions:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _suggestions?.isEmpty == true
                ? Text("No suggestions available.")
                : Column(
                    children: _suggestions
                            ?.map((word) => ListTile(title: Text(word)))
                            .toList() ??
                        [],
                  ),
          ],
        ),
      ),
    );
  }
}
