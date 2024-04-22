import 'dart:convert';

import 'package:flutter/material.dart';

import 'Model.dart';

class Shift implements Model {
  Shift({
    required this.id,
    required this.type,
    this.timeStart = const TimeOfDay(hour: 0, minute: 0),
    this.timeFinish = const TimeOfDay(hour: 0, minute: 0),
    required this.jobs,
  });

  final String id;
  final String type;
  final TimeOfDay timeStart;
  final TimeOfDay timeFinish;
  final List<Job> jobs;

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'timeStart': "${timeStart.hour}:${timeStart.minute}",
      'timeFinish': "${timeFinish.hour}:${timeFinish.minute}",
      'jobs': List.of(jobs.map((job) => jsonEncode(job.toJson()))),
    };
  }

  factory Shift.fromJson(Map<String, dynamic> data) {
    return Shift(
        id: data['_id'],
        type: data['type'] ?? "Festa",
        timeStart: TimeOfDay(
          hour: int.parse(data['timeStart'].split(":")[0]),
          minute: int.parse(data['timeStart'].split(":")[1]),
        ),
        timeFinish: TimeOfDay(
          hour: int.parse(data['timeFinish'].split(":")[0]),
          minute: int.parse(data['timeFinish'].split(":")[1]),
        ),
        jobs: (data['jobs'] as List)
            .map<Job>((string) => Job.fromJson(jsonDecode(string)))
            .toList());
  }

  @override
  bool operator ==(Object other) {
    return other is Shift && id == other.id;
  }
}

class Job implements Model {
  Job({
    required this.title,
    required this.workers,
  });

  final String title;
  final List<dynamic> workers;

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'workers': workers,
    };
  }

  @override
  factory Job.fromJson(Map<String, dynamic> data, {bool db = false}) {
    return Job(
      title: data['title'],
      workers: (data['workers']),
    );
  }
}
