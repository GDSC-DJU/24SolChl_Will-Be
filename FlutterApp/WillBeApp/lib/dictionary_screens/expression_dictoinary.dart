import 'package:flutter/material.dart';
import 'package:solution/dictionary_screens/expression_dictionary_edit.dart';

class Expression_Dictionary extends StatefulWidget {
  Expression_Dictionary(
      {Key? key, required this.name, required this.iconColor});
  final String name;
  Color iconColor;
  @override
  State<Expression_Dictionary> createState() => _Expression_Dictionary_State();
}

class _Expression_Dictionary_State extends State<Expression_Dictionary> {
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
    "behavior": TextEditingController(),
    "meaning": TextEditingController(),
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
                          child: Icon(
                            Icons.person,
                            color: widget.iconColor,
                            size: 30,
                          ),
                          // Image.network(
                          //   // 이미지 DB 구축 시 대치
                          //   "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                          //   fit: BoxFit.cover,
                          // ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Expression_Dictionary_Edit(
                                name: widget.name,
                                iconColor : widget.iconColor,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                        ),
                        child: Container(
                          width: 190,
                          height: 35,
                          child: Center(
                            child: Text(
                              '+ 의사소통사전 추가하기',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SizedBox(
                      width: 110,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.ios_share,
                              color: Colors.black,
                              size: 20,
                            ),
                            Container(
                              // width: 80,
                              height: 35,
                              child: Center(
                                child: Text(
                                  '공유하기',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 1,
                color: Colors.black26,
              ),
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 32,
                  height: MediaQuery.sizeOf(context).height - 213,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 의사소통 builder
                      Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: new Text(
                            '교실을 나가는 행동은',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          initiallyExpanded: true,
                          backgroundColor: Colors.white,
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Container(
                                // height: 200,
                                width: MediaQuery.sizeOf(context).width - 32,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                60,
                                        //textController 반복 생성
                                        child: _buildTextField("보이는 행동",
                                            textControllers["name"], 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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

Widget _buildTextField(
    String label, TextEditingController? controller, int index) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        maxLines: null,
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintText: "입력하세요",
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}
