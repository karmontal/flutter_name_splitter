// main.dart – واجهة Flutter مبدئية لتطبيق تقسيم الأسماء باستخدام Chaquopy
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() => runApp(NameSplitterApp());

class NameSplitterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تقسيم الأسماء',
      theme: ThemeData(fontFamily: 'Cairo'),
      home: NameSplitterScreen(),
    );
  }
}

class NameSplitterScreen extends StatefulWidget {
  @override
  _NameSplitterScreenState createState() => _NameSplitterScreenState();
}

class _NameSplitterScreenState extends State<NameSplitterScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> results = [];

  Future<void> splitNames() async {
    const platform = MethodChannel('com.karam.name_splitter/channel');
    try {
      final String response = await platform.invokeMethod(
        'split_names',
        {'text': _controller.text},
      );
      final List<dynamic> decoded = json.decode(response);
      setState(() {
        results = decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    } catch (e) {
      print("خطأ أثناء استدعاء بايثون: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تقسيم الأسماء')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'أدخل الأسماء (كل اسم في سطر)',
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: splitNames,
              child: Text('تقسيم الأسماء'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final row = results[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${row['FIRST_NAME']} ${row['FATHER_NAME']} ${row['GRANDFATHER_NAME']} ${row['LAST_NAME']}',
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}