import 'package:flutter/material.dart';

class Behavior_Detail_Screen extends StatefulWidget {
  Behavior_Detail_Screen(
      {Key? key, required this.name, required this.behaviorName});
  final String name;
  final String behaviorName;
  @override
  State<Behavior_Detail_Screen> createState() => _Behavior_Detail_Screen();
}

class _Behavior_Detail_Screen extends State<Behavior_Detail_Screen> {
  Map<String, TextEditingController> textControllers = {
    "name": TextEditingController(),
    "behavior": TextEditingController(),
    "meaning": TextEditingController(),
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
          title: Text(
            "행동 별 자세한 기록",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
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
                            "https://img.freepik.com/free-photo/cute-puppy-sitting-in-grass-enjoying-nature-playful-beauty-generated-by-artificial-intelligence_188544-84973.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            Text(
                              widget.behaviorName,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ],
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
                width: MediaQuery.of(context).size.width - 32,
                height: MediaQuery.of(context).size.height - 172,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("보이는 행동", textControllers["name"], 0),
                      _buildTextField(
                          "행동의 의미(기능분석)", textControllers["behavior"], 1),
                      _buildTextField("대처법", textControllers["meaning"], 2),
                      Center(
                        child: SizedBox(
                          width: 150,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                            ),
                            child: Container(
                              width: double.infinity,
                              color: Colors.white70,
                              child: Center(
                                child: Text(
                                  '이 행동 측정 그만하기',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(label),
        ),
        TextFormField(
          controller: controller,
          maxLines: null,
          style: TextStyle(fontSize: 15),
          onTap: () => _scrollToField(controller, index),
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

  void _scrollToField(TextEditingController? controller, int index) {
    if (controller != null) {
      _scrollController.animateTo(
        index * 150,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
