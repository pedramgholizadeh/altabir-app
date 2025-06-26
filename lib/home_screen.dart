import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dream_model.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  Future<void> _submitDream() async {
    setState(() => _isLoading = true);
    final description = _controller.text;

    final url = Uri.parse('https://your-api-endpoint.com/interpret');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'dream': description}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)['interpretation'];
        setState(() {
          _response = result;
          _isLoading = false;
        });
        await _saveToDatabase(description, result);
      } else {
        setState(() {
          _response = 'خطا در دریافت پاسخ از سرور';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = 'خطا: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveToDatabase(String description, String interpretation) async {
    final box = Hive.box<DreamModel>('dreams');
    await box.add(DreamModel(description, interpretation));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'شرح خواب',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitDream,
            child: _isLoading
                ? CircularProgressIndicator()
                : Text('ارسال'),
          ),
          SizedBox(height: 16),
          if (_response.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'تعبیر خواب: $_response',
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}