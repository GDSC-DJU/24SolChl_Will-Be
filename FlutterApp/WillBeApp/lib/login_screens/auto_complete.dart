import 'package:flutter/material.dart';

/// 이 파일은 자동완성 기능이 있는 검색창을 지원함.
/// schoolList에 List형이 들어오면 그 List를 자동완성에 포함시킴.
///

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
    fieldViewBuilder: (BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted) {
      return TextField(
        controller: textEditingController,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white), // 이곳에 원하는 색상을 지정하세요.
        onSubmitted: (String value) {
          onFieldSubmitted();
        },
      );
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
                    title: Text(
                      option,
                      style: const TextStyle(color: Colors.white),
                    ),
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
