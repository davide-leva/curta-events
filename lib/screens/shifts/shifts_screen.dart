import 'dart:math';

import 'package:admin/constants.dart';
import 'package:admin/controllers/ShiftsController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/Shift.dart';
import '../components/header.dart';
import '../components/text_input.dart';
import 'components/shift_card.dart';

class _Pair<T, X> {
  _Pair({
    required this.first,
    required this.second,
  });

  final T first;
  final X second;
}

extension _MapIndex<T> on List<T> {
  List<X> mapIndexed<X>(X Function(int index, T element) transform) {
    List<X> iter = <X>[];
    for (int i = 0; i < this.length; i++) {
      iter.add(transform(i, this[i]));
    }
    return iter;
  }

  List<_Pair<T, X>> zip<X>(List<X> other) {
    List<_Pair<T, X>> zipped = <_Pair<T, X>>[];

    for (int i = 0; i < min(this.length, other.length); i++) {
      zipped.add(_Pair(first: this[i], second: other[i]));
    }

    return zipped;
  }
}

class ShiftsScreen extends StatefulWidget {
  ShiftsScreen({Key? key}) : super(key: key);

  @override
  State<ShiftsScreen> createState() => _ShiftsScreenState();
}

class _ShiftsScreenState extends State<ShiftsScreen> {
  TextEditingController _timeStartController = TextEditingController();
  TextEditingController _timeFinishController = TextEditingController();
  TextEditingController _numberOfJobsController = TextEditingController();

  TimeOfDay _timeStart = TimeOfDay.now().replacing(minute: 0);
  TimeOfDay _timeFinish = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);

  @override
  Widget build(BuildContext context) {
    ShiftController _controller = Get.put(ShiftController());
    _timeStartController.text = _timeStart.format(context);
    _timeFinishController.text = _timeFinish.format(context);

    return SafeArea(
      child: SafeArea(
        child: Responsive(
          mobile: _mobileView(context, _controller),
          desktop: _desktopView(context, _controller),
        ),
      ),
    );
  }

  Container _desktopView(BuildContext context, ShiftController _controller) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Header(
            screenTitle: "Gestione turni",
            buttons: [
              ActionButton(
                title: "Aggiungi turno",
                onPressed: () {
                  showPopUp(context, "Inserimento guidato", [
                    GestureDetector(
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: _timeStart,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          helpText: "Inserisci ora di inizio",
                          hourLabelText: "Ore",
                          minuteLabelText: "Minuti",
                          cancelText: "Annulla",
                          confirmText: "Inserisci",
                        ).then(
                          (value) => setState(() {
                            if (value == null) return;

                            _timeStart = value;
                            _timeStartController.text =
                                _timeStart.format(context);
                          }),
                        );
                      },
                      child: TextInput(
                        textController: _timeStartController,
                        label: "Ora inizio",
                        editable: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: _timeFinish,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          helpText: "Inserisci ora di fine",
                          hourLabelText: "Ore",
                          minuteLabelText: "Minuti",
                          cancelText: "Annulla",
                          confirmText: "Inserisci",
                        ).then(
                          (value) => setState(() {
                            if (value == null) return;

                            _timeFinish = value;
                            _timeFinishController.text =
                                _timeFinish.format(context);
                          }),
                        );
                      },
                      child: TextInput(
                        textController: _timeFinishController,
                        label: "Ora inizio",
                        editable: false,
                      ),
                    ),
                    TextInput(
                      textController: _numberOfJobsController,
                      label: "Numero di attività",
                    )
                  ], () {
                    int numberOfJobs = int.parse(_numberOfJobsController.text);

                    List<TextEditingController> titleControllers =
                        <TextEditingController>[];

                    for (int i = 0; i < numberOfJobs; i++) {
                      titleControllers.add(TextEditingController());
                    }

                    showPopUp(
                      context,
                      "Inserisci Attività",
                      titleControllers
                          .map((e) =>
                              TextInput(textController: e, label: "Attività"))
                          .toList(),
                      () {
                        List<TextEditingController> workersControllers =
                            <TextEditingController>[];

                        for (int i = 0; i < numberOfJobs; i++) {
                          workersControllers.add(TextEditingController());
                        }

                        showPopUp(
                          context,
                          "Inserisci turni",
                          titleControllers.mapIndexed((index, tController) =>
                              TextInput(
                                  textController: workersControllers[index],
                                  label: tController.text)),
                          () => _addShift(
                            _controller,
                            _timeStart,
                            _timeFinish,
                            titleControllers.map((e) => e.text).toList(),
                            workersControllers.map((e) => e.text).toList(),
                          ),
                        );
                      },
                    );
                  });
                },
                icon: Icons.add,
                color: Colors.lightBlue,
              )
            ],
          ),
          SizedBox(
            height: defaultPadding,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                children: [
                  ...List.generate(
                    _controller.shifts.length,
                    (index) => Container(
                      margin: EdgeInsets.only(
                        right: defaultPadding,
                      ),
                      child: ShiftCard(
                        shift: _controller.shifts[index],
                        onDelete: () {
                          setState(() async {
                            _controller.delete(_controller.shifts[index]);
                          });
                        },
                        onModify: () {
                          List<TextEditingController> tecl =
                              List.empty(growable: true);

                          for (int i = 0;
                              i < _controller.shifts[index].jobs.length;
                              i++) {
                            tecl.add(TextEditingController());
                            tecl[i].text = _controller
                                .shifts[index].jobs[i].workers
                                .join(', ');
                          }

                          _timeStart = _controller.shifts[index].timeStart;
                          _timeStartController.text =
                              _timeStart.format(context);
                          _timeFinish = _controller.shifts[index].timeFinish;
                          _timeFinishController.text =
                              _timeFinish.format(context);

                          List<Widget> actions = <Widget>[
                            GestureDetector(
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: _timeStart,
                                  initialEntryMode:
                                      TimePickerEntryMode.inputOnly,
                                  helpText: "Inserisci ora di inizio",
                                  hourLabelText: "Ore",
                                  minuteLabelText: "Minuti",
                                  cancelText: "Annulla",
                                  confirmText: "Inserisci",
                                ).then(
                                  (value) => setState(() {
                                    if (value == null) return;

                                    _timeStart = value;
                                    _timeStartController.text =
                                        _timeStart.format(context);
                                  }),
                                );
                              },
                              child: TextInput(
                                textController: _timeStartController,
                                label: "Ora inizio",
                                editable: false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: _timeFinish,
                                  initialEntryMode:
                                      TimePickerEntryMode.inputOnly,
                                  helpText: "Inserisci ora di fine",
                                  hourLabelText: "Ore",
                                  minuteLabelText: "Minuti",
                                  cancelText: "Annulla",
                                  confirmText: "Inserisci",
                                ).then(
                                  (value) => setState(() {
                                    if (value == null) return;

                                    _timeFinish = value;
                                    _timeFinishController.text =
                                        _timeFinish.format(context);
                                  }),
                                );
                              },
                              child: TextInput(
                                textController: _timeFinishController,
                                label: "Ora inizio",
                                editable: false,
                              ),
                            )
                          ];

                          actions.addAll(_controller.shifts[index].jobs
                              .mapIndexed((index, job) => TextInput(
                                  textController: tecl[index],
                                  label: job.title)));

                          showPopUp(
                            context,
                            "Modifica turno",
                            actions,
                            () => _modifyShift(
                              _controller,
                              _controller.shifts[index],
                              _timeStart,
                              _timeFinish,
                              _controller.shifts[index].jobs
                                  .map((e) => e.title)
                                  .toList(),
                              tecl.map((e) => e.text).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _mobileView(
      BuildContext context, ShiftController _controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Header(
            screenTitle: "Gestione turni",
            buttons: [
              TableButton(
                onPressed: () {
                  showPopUp(context, "Inserimento guidato", [
                    GestureDetector(
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: _timeStart,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          helpText: "Inserisci ora di inizio",
                          hourLabelText: "Ore",
                          minuteLabelText: "Minuti",
                          cancelText: "Annulla",
                          confirmText: "Inserisci",
                        ).then(
                          (value) => setState(() {
                            if (value == null) return;

                            _timeStart = value;
                            _timeStartController.text =
                                _timeStart.format(context);
                          }),
                        );
                      },
                      child: TextInput(
                        textController: _timeStartController,
                        label: "Ora inizio",
                        editable: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: _timeFinish,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          helpText: "Inserisci ora di fine",
                          hourLabelText: "Ore",
                          minuteLabelText: "Minuti",
                          cancelText: "Annulla",
                          confirmText: "Inserisci",
                        ).then(
                          (value) => setState(() {
                            if (value == null) return;

                            _timeFinish = value;
                            _timeFinishController.text =
                                _timeFinish.format(context);
                          }),
                        );
                      },
                      child: TextInput(
                        textController: _timeFinishController,
                        label: "Ora inizio",
                        editable: false,
                      ),
                    ),
                    TextInput(
                      textController: _numberOfJobsController,
                      label: "Numero di attività",
                    )
                  ], () {
                    int numberOfJobs = int.parse(_numberOfJobsController.text);

                    List<TextEditingController> titleControllers =
                        <TextEditingController>[];

                    for (int i = 0; i < numberOfJobs; i++) {
                      titleControllers.add(TextEditingController());
                    }

                    showPopUp(
                      context,
                      "Inserisci Attività",
                      titleControllers
                          .map((e) =>
                              TextInput(textController: e, label: "Attività"))
                          .toList(),
                      () {
                        List<TextEditingController> workersControllers =
                            <TextEditingController>[];

                        for (int i = 0; i < numberOfJobs; i++) {
                          workersControllers.add(TextEditingController());
                        }

                        showPopUp(
                          context,
                          "Inserisci turni",
                          titleControllers.mapIndexed((index, tController) =>
                              TextInput(
                                  textController: workersControllers[index],
                                  label: tController.text)),
                          () => _addShift(
                            _controller,
                            _timeStart,
                            _timeFinish,
                            titleControllers.map((e) => e.text).toList(),
                            workersControllers.map((e) => e.text).toList(),
                          ),
                        );
                      },
                    );
                  });
                },
                icon: Icons.add,
                color: Colors.lightBlue,
              )
            ],
          ),
          SizedBox(
            height: defaultPadding,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(
                  _controller.shifts.length,
                  (index) => Container(
                    child: ShiftCard(
                      shift: _controller.shifts[index],
                      onDelete: () {
                        setState(() async {
                          _controller.delete(_controller.shifts[index]);
                        });
                      },
                      onModify: () {
                        List<TextEditingController> tecl =
                            List.empty(growable: true);

                        for (int i = 0;
                            i < _controller.shifts[index].jobs.length;
                            i++) {
                          tecl.add(TextEditingController());
                          tecl[i].text = _controller
                              .shifts[index].jobs[i].workers
                              .join(', ');
                        }

                        _timeStart = _controller.shifts[index].timeStart;
                        _timeStartController.text = _timeStart.format(context);
                        _timeFinish = _controller.shifts[index].timeFinish;
                        _timeFinishController.text =
                            _timeFinish.format(context);

                        List<Widget> actions = <Widget>[
                          GestureDetector(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: _timeStart,
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                helpText: "Inserisci ora di inizio",
                                hourLabelText: "Ore",
                                minuteLabelText: "Minuti",
                                cancelText: "Annulla",
                                confirmText: "Inserisci",
                              ).then(
                                (value) => setState(() {
                                  if (value == null) return;

                                  _timeStart = value;
                                  _timeStartController.text =
                                      _timeStart.format(context);
                                }),
                              );
                            },
                            child: TextInput(
                              textController: _timeStartController,
                              label: "Ora inizio",
                              editable: false,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: _timeFinish,
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                helpText: "Inserisci ora di fine",
                                hourLabelText: "Ore",
                                minuteLabelText: "Minuti",
                                cancelText: "Annulla",
                                confirmText: "Inserisci",
                              ).then(
                                (value) => setState(() {
                                  if (value == null) return;

                                  _timeFinish = value;
                                  _timeFinishController.text =
                                      _timeFinish.format(context);
                                }),
                              );
                            },
                            child: TextInput(
                              textController: _timeFinishController,
                              label: "Ora inizio",
                              editable: false,
                            ),
                          )
                        ];

                        actions.addAll(_controller.shifts[index].jobs
                            .mapIndexed((index, job) => TextInput(
                                textController: tecl[index],
                                label: job.title)));

                        showPopUp(
                          context,
                          "Modifica turno",
                          actions,
                          () => _modifyShift(
                            _controller,
                            _controller.shifts[index],
                            _timeStart,
                            _timeFinish,
                            _controller.shifts[index].jobs
                                .map((e) => e.title)
                                .toList(),
                            tecl.map((e) => e.text).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_addShift(ShiftController _controller, TimeOfDay start, TimeOfDay finish,
    List<String> titles, List<String> workers) async {
  Shift shift = Shift(
    id: CloudService.uuid(),
    timeStart: start,
    timeFinish: finish,
    jobs: titles
        .zip(workers)
        .map<Job>(
            (pair) => Job(title: pair.first, workers: pair.second.split(', ')))
        .toList(),
  );

  await _controller.add(shift);
}

_modifyShift(ShiftController controller, Shift shift, TimeOfDay timeStart,
    TimeOfDay timeFinish, List<String> titles, List<String> workers) {
  Shift newShift = Shift(
    id: shift.id,
    timeStart: timeStart,
    timeFinish: timeFinish,
    jobs: titles
        .zip(workers)
        .map<Job>(
            (pair) => Job(title: pair.first, workers: pair.second.split(', ')))
        .toList(),
  );

  controller.modify(shift, newShift);
}
