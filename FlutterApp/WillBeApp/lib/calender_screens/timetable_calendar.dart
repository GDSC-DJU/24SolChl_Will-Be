import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TimeTableCalendar extends StatefulWidget {
  TimeTableCalendar({Key? key, required this.cellMap}) : super(key: key);
  Map<String, dynamic> cellMap;
  @override
  CalendarAppointment createState() => CalendarAppointment();
}

class CalendarAppointment extends State<TimeTableCalendar> {
  late _DataSource _dataSource;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;

  @override
  void initState() {
    print(widget.cellMap);
    _dataSource = _getDataSource();
    // 현재 시간 및 날짜 설정
    _startDate = DateTime.now();
    _startTime = TimeOfDay.now();
    _endDate = DateTime.now().add(const Duration(hours: 1));
    _endTime = TimeOfDay.fromDateTime(_endDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SfCalendar(
            dataSource: _dataSource,
            onTap: calendarTapped,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              // CalendarView.workWeek,
              CalendarView.month,
              // CalendarView.timelineDay,
              // CalendarView.timelineWeek,
              // CalendarView.timelineWorkWeek,
              // CalendarView.timelineMonth,
              // CalendarView.schedule
            ],
            monthViewSettings: const MonthViewSettings(showAgenda: true),
          ),
        ),
      ),
    );
  }

  Future<void> calendarTapped(CalendarTapDetails calendarTapDetails) async {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      // 클릭한 요소가 일정인 경우
      Appointment tappedAppointment = calendarTapDetails.appointments![0];
      // 시간표 객체인 경우
      if (tappedAppointment.recurrenceRule != null) {
        await _showEditAppointmentModal(null, calendarTapDetails);
      } else {
        // 일정 수정 모달 표시
        await _showEditAppointmentModal(tappedAppointment, calendarTapDetails);
      }
    } else {
      // 클릭한 요소가 일정이 아닌 경우
      await _showEditAppointmentModal(null, calendarTapDetails);
    }
  }

  Future<void> _showEditAppointmentModal(
      Appointment? appointment, CalendarTapDetails calendarTapDetails) async {
    bool isNewAppointment = appointment == null;
    Color selectedColor =
        appointment?.color ?? Color.fromARGB(255, 102, 108, 255);

    List<Color> colorOptions = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Color.fromARGB(255, 102, 108, 255),
      Colors.indigo,
      Colors.purple,
    ];
    if (!isNewAppointment) {
      _nameController.text = appointment!.subject;
      _startDate = appointment.startTime;
      _startTime = TimeOfDay.fromDateTime(appointment.startTime);
      _endDate = appointment.endTime;
      _endTime = TimeOfDay.fromDateTime(appointment.endTime);
      _startTimeController.text = _startTime.format(context);
      _startDateController.text =
          '${_startDate.toLocal().year}.${_startDate.toLocal().month}.${_startDate.toLocal().day}';
      _endTimeController.text = _endTime.format(context);
      _endDateController.text =
          '${_endDate.toLocal().year}.${_endDate.toLocal().month}.${_endDate.toLocal().day}';
    } else {
      // 새로운 일정을 추가하는 경우 초기값 설정
      _nameController.text = '새 일정';
      _startDate = calendarTapDetails.date ?? DateTime.now();
      _startTime = TimeOfDay.fromDateTime(calendarTapDetails.date!);
      _endDate = _startDate.add(const Duration(hours: 1));
      _endTime = TimeOfDay.fromDateTime(_endDate);
      _startTimeController.text = _startTime.format(context);
      _startDateController.text =
          '${_startDate.toLocal().year}.${_startDate.toLocal().month}.${_startDate.toLocal().day}';
      _endTimeController.text = _endTime.format(context);
      _endDateController.text =
          '${_endDate.toLocal().year}.${_endDate.toLocal().month}.${_endDate.toLocal().day}';
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '일정 편집',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 102, 108, 255)),
                ),
                onPressed: () {
                  // 일정 업데이트 또는 추가
                  if (isNewAppointment) {
                    _addAppointment(selectedColor);
                  } else {
                    _updateAppointment(appointment!, selectedColor);
                  }
                  Navigator.of(context).pop(); // 모달 닫기
                  setState(
                      () {}); // _startDate, _startTime, _endDate, _endTime 업데이트
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _nameController,
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
                      labelText: '일정 명',
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: -20, bottom: 4),
                      focusColor: Color.fromARGB(255, 102, 108, 255),
                      labelStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.black26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "시간 선택",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 102, 108, 255),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startDateController,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        child: Text("시작 날짜 설정"),
                        onPressed: () async {
                          // 시작 날짜 선택
                          DateTime? newStartDate = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  textTheme: const TextTheme(
                                    headline4: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    bodyText1: TextStyle(
                                        fontSize: 25.0), // year selection
                                    subtitle2: TextStyle(fontSize: 22.0),
                                    caption: TextStyle(
                                        fontSize: 24.0), // day selection
                                    overline: TextStyle(fontSize: 22.0),
                                  ),
                                  dialogBackgroundColor: Colors.lightBlueAccent,
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 102, 108, 255),
                                      textStyle: TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (newStartDate != null) {
                            setState(() {
                              _startDate = newStartDate;
                              _startDateController.text =
                                  '${_startDate.toLocal().year}.${_startDate.toLocal().month}.${_startDate.toLocal().day}';
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startTimeController,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          // 시작 시간 선택
                          TimeOfDay? newStartTime = await showTimePicker(
                            context: context,
                            initialTime: _startTime,
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                          );

                          if (newStartTime != null) {
                            setState(() {
                              _startTime = newStartTime;
                              _startTimeController.text =
                                  _startTime.format(context);
                            });
                          }
                        },
                        child: Text(
                          '시작 시간 설정',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _endDateController,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        child: Text("종료 날짜 설정"),
                        onPressed: () async {
                          // 종료 날짜 선택
                          DateTime? newEndDate = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  textTheme: const TextTheme(
                                    headline4: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    bodyText1: TextStyle(
                                        fontSize: 25.0), // year selection
                                    subtitle2: TextStyle(fontSize: 22.0),
                                    caption: TextStyle(
                                        fontSize: 24.0), // day selection
                                    overline: TextStyle(fontSize: 22.0),
                                  ),
                                  dialogBackgroundColor: Colors.lightBlueAccent,
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 102, 108, 255),
                                      textStyle: TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (newEndDate != null) {
                            setState(() {
                              _endDate = newEndDate;
                              _endDateController.text =
                                  '${_endDate.toLocal().year}.${_endDate.toLocal().month}.${_endDate.toLocal().day}';
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _endTimeController,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          // 종료 시간 선택
                          TimeOfDay? newEndTime = await showTimePicker(
                            context: context,
                            initialTime: _endTime,
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                          );

                          if (newEndTime != null) {
                            setState(() {
                              _endTime = newEndTime;
                              _endTimeController.text =
                                  _endTime.format(context);
                            });
                          }
                        },
                        child: Text(
                          '종료 시간 설정',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "색상 선택",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 102, 108, 255),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 180,
                        height: 200,
                        child: Center(
                          child: BlockPicker(
                            pickerColor: selectedColor,
                            availableColors: colorOptions,
                            onColorChanged: (color) {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addAppointment(Color selectedColor) {
    // 일정 추가 로직
    Appointment newAppointment = Appointment(
      startTime: DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      ),
      endTime: DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      ),
      subject: _nameController.text,
      color: selectedColor, // 일정의 색 설정
    );

    // 데이터 소스에 일정 추가
    _dataSource.addAppointment(newAppointment);
  }

  void _updateAppointment(Appointment appointment, Color selectedColor) {
    // 일정 업데이트 로직
    Appointment updatedAppointment = Appointment(
      startTime: DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      ),
      endTime: DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      ),
      subject: _nameController.text,
      color: selectedColor, // 기존 일정의 색을 유지
    );

    // 데이터 소스에서 일정 업데이트
    _dataSource.updateAppointment(appointment, updatedAppointment);
  }

  _DataSource _getDataSource() {
    List<Appointment> appointments = <Appointment>[];
    List colorList = [
      Color.fromRGBO(255, 44, 75, 1),
      Color.fromRGBO(92, 182, 50, 1),
      Color.fromRGBO(60, 153, 225, 1),
      Color.fromRGBO(252, 183, 14, 1),
      Color.fromRGBO(123, 67, 183, 1),
      Color.fromRGBO(253, 151, 54, 1),
      Color.fromRGBO(45, 197, 197, 1),
    ];
    for (String day in widget.cellMap.keys) {
      if (widget.cellMap[day]!.isNotEmpty) {
        for (int i = 1; i <= 9; i++) {
          if (widget.cellMap[day]!.containsKey(i.toString())) {
            if (widget.cellMap[day][i.toString()] != null) {
              // 예시의 패턴에 따라 날짜 및 시간 설정
              DateTime selectedDateTime = DateTime.now()
                  .subtract(Duration(days: 7))
                  .add(Duration(days: _getDayOffset(day)));
              selectedDateTime =
                  selectedDateTime.add(Duration(hours: i + 6)); // 9시부터 시작
              // 분과 초를 0으로 설정하여 정각으로 만듦
              selectedDateTime = DateTime(
                selectedDateTime.year,
                selectedDateTime.month,
                selectedDateTime.day,
                selectedDateTime.hour,
                0,
                0,
                0,
                0,
              );
              Appointment newAppointment = Appointment(
                startTime: selectedDateTime,
                endTime: selectedDateTime.add(const Duration(hours: 1)),
                subject: widget.cellMap[day]![i.toString()]["subject"],
                color: colorList[widget.cellMap[day]![i.toString()]["color"]],
                recurrenceRule: 'FREQ=WEEKLY;BYDAY=${_getBYDAY(day)};COUNT=100',
              );

              appointments.add(newAppointment);
            }
          }
        }
      }
    }

    return _DataSource(appointments);
  }

  int _getDayOffset(String day) {
    switch (day) {
      case 'Mon':
        return 0;
      case 'Tue':
        return 1;
      case 'Wed':
        return 2;
      case 'Thu':
        return 3;
      case 'Fri':
        return 4;
      default:
        return 0;
    }
  }

  String _getBYDAY(String day) {
    switch (day) {
      case 'Mon':
        return "MO";
      case 'Tue':
        return "TU";
      case 'Wed':
        return "WE";
      case 'Thu':
        return "TH";
      case 'Fri':
        return "FR";
      default:
        return "SU";
    }
  }
  // _DataSource _getDataSource() {
  //   List<Appointment> appointments = <Appointment>[];

  //   // widget.cellMap에서 정보를 가져와 일정을 생성
  //   widget.cellMap.forEach(
  //     (key, value) {
  //       'Mon'
  //     },
  //   );

  //   return _DataSource(appointments);
  // }

  // _DataSource _getDataSource() {
  //   List<Appointment> appointments = <Appointment>[];
  //   appointments.add(Appointment(
  //     startTime: DateTime.now(),
  //     endTime: DateTime.now().add(const Duration(hours: 1)),
  //     subject: 'Meeting',
  //     color: Color.fromARGB(255, 102, 108, 255),
  //   ));
  //   return _DataSource(appointments);
  // }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }

  void updateAppointment(
      Appointment oldAppointment, Appointment newAppointment) {
    final int index = appointments!.indexOf(oldAppointment);
    if (index != -1) {
      appointments!.removeAt(index);
      appointments!.add(newAppointment);
      notifyListeners(CalendarDataSourceAction.reset, appointments!);
    }
  }

  void addAppointment(Appointment newAppointment) {
    appointments!.add(newAppointment);
    notifyListeners(
        CalendarDataSourceAction.add, <Appointment>[newAppointment]);
  }
}
