import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeTableCalendar extends StatefulWidget {
  const TimeTableCalendar({Key? key}) : super(key: key);

  @override
  CalendarAppointment createState() => CalendarAppointment();
}

class CalendarAppointment extends State<TimeTableCalendar> {
  late _DataSource _dataSource;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    _dataSource = _getDataSource();
    // 현재 시간 및 날짜 설정
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
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
              CalendarView.workWeek,
              CalendarView.month,
              CalendarView.timelineDay,
              CalendarView.timelineWeek,
              CalendarView.timelineWorkWeek,
              CalendarView.timelineMonth,
              CalendarView.schedule
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
      // 일정 수정 모달 표시
      await _showEditAppointmentModal(tappedAppointment, calendarTapDetails);
    } else {
      // 클릭한 요소가 일정이 아닌 경우
      await _showEditAppointmentModal(null, calendarTapDetails);
    }
  }

  Future<void> _showEditAppointmentModal(
      Appointment? appointment, CalendarTapDetails calendarTapDetails) async {
    bool isNewAppointment = appointment == null;

    if (!isNewAppointment) {
      _nameController.text = appointment!.subject;
      _selectedDate = appointment.startTime;
      _selectedTime = TimeOfDay.fromDateTime(appointment.startTime);
      _timeController.text = _selectedTime.format(context);
      _dateController.text =
          '${_selectedDate.toLocal().year}.${_selectedDate.toLocal().month}.${_selectedDate.toLocal().day}';
    } else {
      // 새로운 일정을 추가하는 경우 초기값 설정
      _nameController.text = '새 일정';
      _selectedDate = calendarTapDetails.date ?? DateTime.now();
      _selectedTime = TimeOfDay.fromDateTime(calendarTapDetails.date!);
      _timeController.text = _selectedTime.format(context);
      _dateController.text =
          '${_selectedDate.toLocal().year}.${_selectedDate.toLocal().month}.${_selectedDate.toLocal().day}';
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('일정 편집'),
          content: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '일정 명'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          child: Text("날짜 선택"),
                          onPressed: () async {
                            // 날짜 선택
                            DateTime? newDateTime = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
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
                                          fontSize: 25.0), //year selection
                                      subtitle2: TextStyle(fontSize: 22.0),
                                      caption: TextStyle(
                                          fontSize: 24.0), //day selection
                                      overline: TextStyle(fontSize: 22.0),
                                    ),
                                    dialogBackgroundColor:
                                        Colors.lightBlueAccent,
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

                            if (newDateTime != null) {
                              setState(() {
                                _selectedDate = newDateTime;
                                _dateController.text =
                                    '${_selectedDate.toLocal().year}.${_selectedDate.toLocal().month}.${_selectedDate.toLocal().day}';
                              });
                            }
                          },
                        ),
                        TextFormField(
                          controller: _dateController,
                          style: TextStyle(fontSize: 20,),
                          textAlign: TextAlign.center,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // 시간 선택
                            TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                              initialEntryMode: TimePickerEntryMode.inputOnly,
                            );

                            if (newTime != null) {
                              setState(() {
                                _selectedTime = newTime;
                                _timeController.text =
                                    _selectedTime.format(context);
                              });
                            }
                          },
                          child: Text(
                            '시간 설정',
                          ),
                        ),
                        // TextField(
                        //   style: TextStyle(fontSize: 15),
                        // ),
                        TextFormField(
                          controller: _timeController,
                          style: TextStyle(fontSize: 20,),
                          textAlign: TextAlign.center,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 일정 업데이트 또는 추가
                  if (isNewAppointment) {
                    _addAppointment();
                  } else {
                    _updateAppointment(appointment!);
                  }
                  Navigator.of(context).pop(); // 모달 닫기
                  setState(() {}); // _selectedDate, _selectedTime 업데이트
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addAppointment() {
    // 일정 추가 로직
    Appointment newAppointment = Appointment(
      startTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      endTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ).add(const Duration(hours: 1)),
      subject: _nameController.text,
      color: Colors.teal,
    );

    // 데이터 소스에 일정 추가
    _dataSource.addAppointment(newAppointment);
  }

  void _updateAppointment(Appointment appointment) {
    // 일정 업데이트 로직
    Appointment updatedAppointment = Appointment(
      startTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      endTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ).add(const Duration(hours: 1)),
      subject: _nameController.text,
      color: appointment.color,
    );

    // 데이터 소스에서 일정 업데이트
    _dataSource.updateAppointment(appointment, updatedAppointment);
  }

  _DataSource _getDataSource() {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Meeting',
      color: Colors.teal,
    ));
    return _DataSource(appointments);
  }
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
