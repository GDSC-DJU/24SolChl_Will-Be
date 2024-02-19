import 'package:flutter/material.dart';

class Expression_Dictionary extends StatefulWidget {
  Expression_Dictionary({Key? key, required this.name});
  final String name;
  @override
  State<Expression_Dictionary> createState() => _Expression_Dictionary_State();
}

class _Expression_Dictionary_State extends State<Expression_Dictionary> {
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
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
                        Container(
                          width: MediaQuery.sizeOf(context).width - 32,
                          child: Row(
                            children: [
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 40,
                              ),
                              Text("교실을 나가는 행동은"),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width - 32,
                          child: Row(
                            children: [
                              Icon(
                                Icons.keyboard_arrow_up_sharp,
                                size: 40,
                              ),
                              Text("사람에게 다가가서 만지거나 건드리면"),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: TextField(
              //     style: TextStyle(
              //       height: 1.5,
              //       fontSize: 25,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     decoration: const InputDecoration(
              //       border: UnderlineInputBorder(),
              //       floatingLabelStyle: TextStyle(
              //         color: Color.fromARGB(255, 102, 108, 255),
              //         fontWeight: FontWeight.w500,
              //         fontSize: 23,
              //       ),
              //       floatingLabelBehavior: FloatingLabelBehavior.auto,
              //       labelText: '아이 이름',
              //       isDense: true,
              //       contentPadding: EdgeInsets.only(top: -20, bottom: 4),
              //       focusColor: Color.fromARGB(255, 102, 108, 255),
              //       labelStyle: TextStyle(
              //         fontSize: 25,
              //         color: Colors.black26,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     controller: textControllers["name"],
              //     onChanged: (value) {
              //       setState(() {
              //         // widget.name = value;
              //       });
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String text;

  CustomRadioButton({
    required this.isSelected,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color:
              isSelected ? Color.fromARGB(255, 102, 108, 255) : Colors.black12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppSliderShape extends SliderComponentShape {
  final double thumbRadius;
  final String thumbValue;

  const AppSliderShape({required this.thumbRadius, required this.thumbValue});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      text: thumbValue,
    );

    TextPainter textPainter = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    Offset textCenter = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    canvas.drawCircle(
      center,
      20,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Color.fromARGB(255, 102, 108, 255),
    );
    canvas.drawCircle(
      center,
      15,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white,
    );
    textPainter.paint(canvas, textCenter);
  }
}
