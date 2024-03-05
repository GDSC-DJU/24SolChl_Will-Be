import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution/assets/pallet.dart';
import 'package:solution/main.dart';

Widget buildBehaviorCards(
    {required List behaviorList,
    required int numOfCards,
    required List studentIDs,
    required List names,
    required List LastNames,
    required List behaviors,
    required BuildContext context,
    required Function recordBahvior}) {
  ///내 계정에 등록된 아이의 ID를 가져오는 스냅샷
  ///
  BtnColors btnColors = BtnColors();

  List<Color> btnColorList = [];
  btnColorList.add(BtnColors().btn1);
  btnColorList.add(BtnColors().btn2);
  btnColorList.add(BtnColors().btn3);
  btnColorList.add(BtnColors().btn4);
  btnColorList.add(BtnColors().btn5);
  btnColorList.add(BtnColors().btn6);

  bool isButtonEnabled = true;
  String noticForTooFastClicks = '너무 빨리 눌렀어요 다시 눌러주세요!';

  print("behaviorList");
  print(behaviorList);
  //행동의 개수에 따라 다른 화면을 보여주기 위한 swtich 문
  switch (numOfCards) {
    case 0:
      return const Expanded(
        child: Center(
          child: Text("아동 데이터 또는 행동 데이터가 없습니다."),
        ),
      );

    //행동카드의 수가 1개
    case 1:
      // return LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     print(
      //         'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
      return Consumer<MyModel>(
        builder: (
          context,
          myModel,
          child,
        ) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //first bahavior
                    GestureDetector(
                      onTap: isButtonEnabled
                          ? () async {
                              isButtonEnabled = false;
                              myModel.changeColor(1, btnColors.btnPressed1);

                              await recordBahvior(
                                behaivorName: behaviors[0],
                                studentID: studentIDs[0],
                              );
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                myModel.changeColor(1, btnColors.btn1);
                              });
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                isButtonEnabled = true;
                              });
                            }
                          : () {
                              var snackBar = SnackBar(
                                  content: Text(noticForTooFastClicks));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.54 * 0.9,
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: myModel.btnColor1,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 10), // changes position of shadow
                              ),
                            ]),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white60,
                                      ),
                                      child: Center(
                                        child: Text(
                                          LastNames[0],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      names[0],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  behaviors[0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    case 2:
      //return LayoutBuilder(
      // builder: (BuildContext context, BoxConstraints constraints) {
      //   print(
      //       'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
      //   return
      return Consumer<MyModel>(
        builder: (
          context,
          myModel,
          child,
        ) {
          return Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: isButtonEnabled
                      ? () async {
                          isButtonEnabled = false;
                          myModel.changeColor(1, btnColors.btnPressed1);

                          await recordBahvior(
                            behaivorName: behaviors[0],
                            studentID: studentIDs[0],
                          );
                          Future.delayed(const Duration(milliseconds: 500), () {
                            myModel.changeColor(1, btnColors.btn1);
                          });
                          Future.delayed(const Duration(milliseconds: 500), () {
                            isButtonEnabled = true;
                          });
                        }
                      : () {
                          var snackBar =
                              SnackBar(content: Text(noticForTooFastClicks));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.54 / 2 - 20,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: myModel.btnColor1,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 10), // changes position of shadow
                          ),
                        ]),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white60,
                                  ),
                                  child: Center(
                                    child: Text(LastNames[0]),
                                  ),
                                ),
                                Text(
                                  names[0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Text(
                              behaviors[0],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //두번째 카드
                GestureDetector(
                  onTap: isButtonEnabled
                      ? () async {
                          isButtonEnabled = false;
                          myModel.changeColor(2, btnColors.btnPressed2);

                          await recordBahvior(
                            behaivorName: behaviors[1],
                            studentID: studentIDs[1],
                          );
                          Future.delayed(const Duration(milliseconds: 500), () {
                            myModel.changeColor(2, btnColors.btn2);
                          });
                          Future.delayed(const Duration(milliseconds: 500), () {
                            isButtonEnabled = true;
                          });
                        }
                      : () {
                          var snackBar =
                              SnackBar(content: Text(noticForTooFastClicks));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.54 / 2 - 20,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: myModel.btnColor2,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 10), // changes position of shadow
                          ),
                        ]),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white60,
                                  ),
                                  child: Center(
                                    child: Text(LastNames[1]),
                                  ),
                                ),
                                Text(
                                  names[1],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Text(
                              behaviors[1],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    case 3:
      // return LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     print(
      //         'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
      return Consumer<MyModel>(builder: (
        context,
        myModel,
        child,
      ) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              GestureDetector(
                onTap: isButtonEnabled
                    ? () async {
                        isButtonEnabled = false;
                        myModel.changeColor(1, btnColors.btnPressed1);

                        await recordBahvior(
                          behaivorName: behaviors[0],
                          studentID: studentIDs[0],
                        );
                        Future.delayed(const Duration(milliseconds: 500), () {
                          myModel.changeColor(1, btnColors.btn1);
                        });
                        Future.delayed(const Duration(milliseconds: 500), () {
                          isButtonEnabled = true;
                        });
                      }
                    : () {
                        var snackBar =
                            SnackBar(content: Text(noticForTooFastClicks));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.54 / 3 - 30,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: myModel.btnColor1,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 10), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white60,
                                ),
                                child: Center(
                                  child: Text(LastNames[0]),
                                ),
                              ),
                              Text(
                                names[0],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Text(
                            behaviors[0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //두번째 카드
              GestureDetector(
                onTap: isButtonEnabled
                    ? () async {
                        isButtonEnabled = false;
                        myModel.changeColor(2, btnColors.btnPressed2);

                        await recordBahvior(
                          behaivorName: behaviors[1],
                          studentID: studentIDs[1],
                        );
                        Future.delayed(const Duration(milliseconds: 500), () {
                          myModel.changeColor(2, btnColors.btn2);
                        });
                        Future.delayed(const Duration(milliseconds: 500), () {
                          isButtonEnabled = true;
                        });
                      }
                    : () {
                        var snackBar =
                            SnackBar(content: Text(noticForTooFastClicks));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.54 / 3 - 30,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: myModel.btnColor2,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 10), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white60,
                                ),
                                child: Center(
                                  child: Text(LastNames[1]),
                                ),
                              ),
                              Text(
                                names[1],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Text(
                            behaviors[1],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //3번째 코드
              GestureDetector(
                onTap: isButtonEnabled
                    ? () async {
                        isButtonEnabled = false;
                        myModel.changeColor(3, btnColors.btnPressed3);

                        await recordBahvior(
                          behaivorName: behaviors[2],
                          studentID: studentIDs[2],
                        );
                        Future.delayed(const Duration(milliseconds: 500), () {
                          myModel.changeColor(3, btnColors.btn3);
                        });
                        Future.delayed(const Duration(milliseconds: 500), () {
                          isButtonEnabled = true;
                        });
                      }
                    : () {
                        var snackBar =
                            SnackBar(content: Text(noticForTooFastClicks));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.54 / 3 - 30,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: myModel.btnColor3,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 10), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white60,
                                ),
                                child: Center(
                                  child: Text(LastNames[2]),
                                ),
                              ),
                              Text(
                                names[2],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Text(
                            behaviors[2],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    //   },
    // );

    //행동 4개일 때
    case 4:
      // key를 사용하여 behaviorIDAndStudentID에서 value를 가져옴
      // return LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     print(
      //         'Width: ${constraints.maxWidth}, Height: ${constraints.maxHeight}');
      return Consumer<MyModel>(
        builder: (
          context,
          myModel,
          child,
        ) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                Row(
                  children: [
                    // 첫번째 카드
                    GestureDetector(
                      onTap: isButtonEnabled
                          ? () async {
                              isButtonEnabled = false;
                              myModel.changeColor(1, btnColors.btnPressed1);

                              await recordBahvior(
                                behaivorName: behaviors[0],
                                studentID: studentIDs[0],
                              );
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                myModel.changeColor(1, btnColors.btn1);
                              });
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                isButtonEnabled = true;
                              });
                            }
                          : () {
                              var snackBar = SnackBar(
                                  content: Text(noticForTooFastClicks));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height:
                            MediaQuery.of(context).size.height * 0.54 / 2 - 20,
                        width: MediaQuery.of(context).size.width * 0.38,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: myModel.btnColor1,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 10), // changes position of shadow
                              ),
                            ]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white60,
                                      ),
                                      child: Center(
                                        child: Text(LastNames[0]),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        names[0],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Text(
                                    behaviors[0],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //두번째 카드
                    GestureDetector(
                      onTap: isButtonEnabled
                          ? () async {
                              isButtonEnabled = false;
                              myModel.changeColor(2, btnColors.btnPressed2);

                              await recordBahvior(
                                behaivorName: behaviors[1],
                                studentID: studentIDs[1],
                              );
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                myModel.changeColor(2, btnColors.btn2);
                              });
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                isButtonEnabled = true;
                              });
                            }
                          : () {
                              var snackBar = SnackBar(
                                  content: Text(noticForTooFastClicks));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height:
                            MediaQuery.of(context).size.height * 0.54 / 2 - 20,
                        width: MediaQuery.of(context).size.width * 0.38,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: myModel.btnColor2,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 10), // changes position of shadow
                              ),
                            ]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white60,
                                      ),
                                      child: Center(
                                        child: Text(LastNames[1]),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        names[1],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Text(
                                    behaviors[1],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    //3번째 행동 카드
                    GestureDetector(
                      onTap: isButtonEnabled
                          ? () async {
                              isButtonEnabled = false;
                              myModel.changeColor(3, btnColors.btnPressed3);

                              await recordBahvior(
                                behaivorName: behaviors[2],
                                studentID: studentIDs[2],
                              );
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                myModel.changeColor(3, btnColors.btn3);
                              });
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                isButtonEnabled = true;
                              });
                            }
                          : () {
                              var snackBar = SnackBar(
                                  content: Text(noticForTooFastClicks));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height:
                            MediaQuery.of(context).size.height * 0.54 / 2 - 20,
                        width: MediaQuery.of(context).size.width * 0.38,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: myModel.btnColor3,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 10), // changes position of shadow
                              ),
                            ]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white60,
                                      ),
                                      child: Center(
                                        child: Text(LastNames[2]),
                                      ),
                                    ),
                                    Text(
                                      names[2],
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  behaviors[2],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //4번째
                    GestureDetector(
                      onTap: isButtonEnabled
                          ? () async {
                              isButtonEnabled = false;
                              myModel.changeColor(4, btnColors.btnPressed4);

                              await recordBahvior(
                                behaivorName: behaviors[3],
                                studentID: studentIDs[3],
                              );
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                myModel.changeColor(4, btnColors.btn4);
                              });
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                isButtonEnabled = true;
                              });
                            }
                          : () {
                              var snackBar = SnackBar(
                                  content: Text(noticForTooFastClicks));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height:
                            MediaQuery.of(context).size.height * 0.54 / 2 - 20,
                        width: MediaQuery.of(context).size.width * 0.38,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: myModel.btnColor4,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 10), // changes position of shadow
                              ),
                            ]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white60,
                                      ),
                                      child: Center(
                                        child: Text(LastNames[3]),
                                      ),
                                    ),
                                    Text(
                                      names[3],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  behaviors[3],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
  }

  return Container();
}
