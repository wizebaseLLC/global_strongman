// ignore_for_file: implementation_imports

import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart' as charts_text;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';

class ProgressionLineChart extends StatelessWidget {
  const ProgressionLineChart({
    required this.seriesList,
    required this.animate,
    Key? key,
  }) : super(key: key);

  final bool animate;
  final List<QueryDocumentSnapshot<FirebaseUserWorkoutComplete>> seriesList;
  @override
  Widget build(BuildContext context) {
    seriesList
        .sort((a, b) => a.data().created_on!.compareTo(b.data().created_on!));
    return AspectRatio(
      aspectRatio: 3,
      child: charts.TimeSeriesChart(
        _createSampleData(),
        animate: animate,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          charts.LinePointHighlighter(
              symbolRenderer:
                  CustomCircleSymbolRenderer() // add this line in behaviours
              )
        ],
        selectionModels: [
          SelectionModelConfig(changedListener: (SelectionModel model) {
            if (model.hasDatumSelection) {
              final value = model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index);
              CustomCircleSymbolRenderer.value =
                  value.toString(); // paints the tapped value
            }
          })
        ],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeries, DateTime>> _createSampleData() {
    var chartData = seriesList
        .map((e) {
          final data = e.data();
          final int? value = data.working_sets?.map(
            (e) {
              final WorkoutSetListItem workingSet =
                  WorkoutSetListItem.fromJson(e);

              return WorkoutSetListItem.fromJson(e)
                      .working_weight_lbs
                      ?.toInt() ??
                  0;
            },
          ).reduce(max);
          return TimeSeries(data.created_on!, value ?? 0);
        })
        .toList()
        .where((element) => element.value > 0)
        .toList();

    return [
      charts.Series<TimeSeries, DateTime>(
        id: 'Value',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeries val, _) => val.time,
        measureFn: (TimeSeries val, _) => val.value,
        data: chartData,
      ),
    ];
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  static String value = "";
  @override
  void paint(
    ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int>? dashPattern,
    Color? fillColor,
    FillPatternType? fillPattern,
    Color? strokeColor,
    double? strokeWidthPx,
  }) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
      Rectangle(
        bounds.left - 10,
        bounds.top - 30,
        bounds.width + 40,
        bounds.height + 10,
      ),
      fill: Color.white,
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(
        charts_text.TextElement(
          value,
          style: textStyle,
        ),
        (bounds.left).round(),
        (bounds.top - 28).round());
  }
}

class TimeSeries {
  final DateTime time;
  final int value;

  TimeSeries(
    this.time,
    this.value,
  );
}
