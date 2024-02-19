import 'package:flutter/material.dart';

class Expression_Dictionary_Edit extends StatefulWidget {
  Expression_Dictionary_Edit({Key? key, required this.name});
  final String name;
  String behavior = "";
  String meaning = "";
  String direction = "";
  @override
  State<Expression_Dictionary_Edit> createState() =>
      _Expression_Dictionary_Edit_State();
}

class _Expression_Dictionary_Edit_State
    extends State<Expression_Dictionary_Edit> {
  Map<String, TextEditingController> textControllers = {
    "behavior": TextEditingController(),
    "meaning": TextEditingController(),
    "direction": TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    // widget.name = textControllers["name"]?.text;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "의사소통사전",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 0,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Image.network(
                            // 이미지 DB 구축 시 대치
                            "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 1,
                color: Colors.black26,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width - 32,
                height: MediaQuery.sizeOf(context).height - 213,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            floatingLabelStyle: TextStyle(
                              color: Color.fromARGB(255, 102, 108, 255),
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: '표현(행동)',
                            isDense: true,
                            contentPadding:
                                EdgeInsets.only(top: -20, bottom: 4),
                            focusColor: Color.fromARGB(255, 102, 108, 255),
                            labelStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          controller: textControllers["behavior"],
                          onChanged: (value) {
                            setState(() {
                              widget.behavior = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: MediaQuery.sizeOf(context).width - 32,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "아이가 하는 표현이나 행동을 적어주세요.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(175, 175, 175, 1),
                                ),
                              ),
                              Text(
                                "15자",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(175, 175, 175, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            floatingLabelStyle: TextStyle(
                              color: Color.fromARGB(255, 102, 108, 255),
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: '표현의 의미',
                            isDense: true,
                            contentPadding:
                                EdgeInsets.only(top: -20, bottom: 4),
                            focusColor: Color.fromARGB(255, 102, 108, 255),
                            labelStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          controller: textControllers["meaning"],
                          onChanged: (value) {
                            setState(() {
                              widget.meaning = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: MediaQuery.sizeOf(context).width - 32,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("아이가 표현을 통해 말하고자하는 의미를 적어주세요.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(175, 175, 175, 1),
                                  )),
                              Text("15자",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(175, 175, 175, 1),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width - 32,
                              child: Text("이렇게 해주세요"),
                            ),
                            TextFormField(
                              controller: textControllers["direction"],
                              maxLines: null,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 102, 108, 255)),
                                ),
                                hintText: "입력하세요",
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: MediaQuery.sizeOf(context).width - 32,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "어떻게 대처해야하는지 적어주세요.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(175, 175, 175, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height - 330,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
