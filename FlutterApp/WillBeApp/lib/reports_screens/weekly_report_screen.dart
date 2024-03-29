import 'package:flutter/material.dart';
import 'package:solution/reports_screens/test.dart';
import 'package:solution/reporting/api_communication.dart'
    show ApiCommunication;

class Weekly_Report_Screen extends StatefulWidget {
  Weekly_Report_Screen(
      {super.key,
      required this.name,
      required this.id,
      required this.behaviorList,
      required this.iconColor});
  Color iconColor;
  final String name;
  final String id;
  final List behaviorList;
  @override
  State<Weekly_Report_Screen> createState() => _Weekly_Report_Screen();
}

class _Weekly_Report_Screen extends State<Weekly_Report_Screen> {
  Map<String, TextEditingController> textControllers = {
    "result": TextEditingController(),
  };

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "주간 리포트",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Icon(
                            Icons.person,
                            color: widget.iconColor,
                            size: 30,
                          ),
                          // Image.network(
                          //   "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          var result = await helpFunc(widget.id,
                              widget.behaviorList, '2024-02-19', '2024-02-23');

                          // ApiCommunication 객체를 생성합니다.
                          ApiCommunication apiCommunication = ApiCommunication(
                            url:
                                'https://willbe-nlp-t5feuxbhta-du.a.run.app/v1/summary/report',
                            inputBody: result,
                          );

                          // getRespond 함수를 호출하여 응답을 받습니다.
                          var response = await apiCommunication.getRespond();

                          // 응답을 출력합니다.
                          print(response);

                          // setState 함수를 호출하여 UI를 업데이트합니다.
                          setState(() {
                            textControllers["result"]!.text = response;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.zero,
                          backgroundColor:
                              const Color.fromARGB(255, 115, 92, 246),
                        ),
                        child: SizedBox(
                          width:
                              MediaQuery.of(context).size.width * 0.025 * 12.5,
                          height: MediaQuery.of(context).size.height * 0.01 * 5,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.generating_tokens,
                                color: Colors.white,
                                size: 15,
                              ),
                              Text(
                                " AI에게 추천받기",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 1,
                color: Colors.black26,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                height: MediaQuery.of(context).size.height - 172,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("결과", textControllers["result"], 0),
                      // Center(
                      //   child: SizedBox(
                      //     width: 150,
                      //     height: 40,
                      //     child: ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         side: BorderSide(color: Colors.red),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.all(
                      //             Radius.circular(100),
                      //           ),
                      //         ),
                      //         padding: EdgeInsets.zero,
                      //         backgroundColor: Colors.white,
                      //       ),
                      //       child: Container(
                      //         width: double.infinity,
                      //         color: Colors.white70,
                      //         child: Center(
                      //           child: Text(
                      //             '이 행동 측정 그만하기',
                      //             style: TextStyle(
                      //               fontSize: 15,
                      //               color: Colors.red,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 350,
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

  Widget _buildTextField(
      String label, TextEditingController? controller, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(label),
        ),
        TextFormField(
          controller: controller,
          maxLines: null,
          style: const TextStyle(fontSize: 15),
          onTap: () => _scrollToField(controller, index),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 22, 72, 99)),
            ),
            hintText: "입력하세요",
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void _scrollToField(TextEditingController? controller, int index) {
    if (controller != null) {
      _scrollController.animateTo(
        index * 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
