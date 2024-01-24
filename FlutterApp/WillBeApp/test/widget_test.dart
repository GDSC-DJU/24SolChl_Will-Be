// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:solution/main.dart';

void main() {
  runApp(SchoolSearchScreen());
}

class SchoolSearchScreen extends StatelessWidget {
  final List<String> schoolList = [
    '서울대학교',
    '연세대학교',
    '고려대학교',
    // ... 나머지 학교 리스트
  ];

  SchoolSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학교 검색'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildAutocomplete(schoolList),
            // ... 다른 위젯들
          ],
        ),
      ),
    );
  }

  Widget buildAutocomplete(List<String> schoolList) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable.empty();
        }
        return schoolList.where((String option) {
          return option.contains(textEditingValue.text);
        });
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (String selection) {
        print('You selected $selection');
      },
    );
  }
}
