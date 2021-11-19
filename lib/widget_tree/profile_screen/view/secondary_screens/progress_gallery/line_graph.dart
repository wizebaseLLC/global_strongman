import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/ProgressGalleryCard.dart';

class ProgressLineChart extends StatelessWidget {
  const ProgressLineChart({
    required this.streamedGallery,
    required this.initialWeight,
    Key? key,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<ProgressGalleryCard>>? streamedGallery;
  final String initialWeight;

  @override
  Widget build(BuildContext context) {
    final currentWeight =
        streamedGallery?.first?.data().weight ?? initialWeight;
    final direction =
        int.parse(initialWeight) > int.parse(currentWeight) ? "-" : "+";
    final difference = direction == "-"
        ? int.parse(initialWeight) - int.parse(currentWeight)
        : int.parse(currentWeight) - int.parse(initialWeight);

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              // color: Color(0xff232d37),
            ),
            child: streamedGallery != null && streamedGallery!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: 18.0,
                      left: 12.0,
                      top: 60,
                      bottom: 12,
                    ),
                    child: SimpleTimeSeriesChart(
                      animate: true,
                      seriesList: streamedGallery!,
                    ),
                  )
                : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProgressWeightText(
              title: "Current Weight",
              secondaryTitle: "$currentWeight lbs",
            ),
            ProgressWeightText(
              title: "Start Weight",
              secondaryTitle: "$initialWeight lbs",
            ),
            ProgressWeightText(
              title: "Progress",
              secondaryTitle: direction == "n/a"
                  ? "n/a"
                  : "$direction${difference.toString()}",
            ),
          ],
        ),
      ],
    );
  }
}

class ProgressWeightText extends StatelessWidget {
  const ProgressWeightText({
    required this.title,
    required this.secondaryTitle,
    Key? key,
  }) : super(key: key);

  final String title;
  final String secondaryTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: kSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: platformThemeData(context,
                material: (data) => data.textTheme.bodyText1?.copyWith(
                      color: Colors.red.shade300,
                    ),
                cupertino: (data) => data.textTheme.textStyle.copyWith(
                      color: Colors.red.shade300,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    )),
          ),
          const SizedBox(
            height: kSpacing / 2,
          ),
          Text(
            secondaryTitle,
            style: platformThemeData(
              context,
              material: (data) =>
                  data.textTheme.bodyText1?.copyWith(fontSize: 15),
              cupertino: (data) =>
                  data.textTheme.textStyle.copyWith(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleTimeSeriesChart extends StatelessWidget {
  //final List<charts.Series> seriesList;
  final bool animate;
  final List<QueryDocumentSnapshot<ProgressGalleryCard>> seriesList;
  const SimpleTimeSeriesChart({
    required this.seriesList,
    required this.animate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createSampleData(),
      animate: animate,

      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data providvb`r````````````````````````````````````````````````````````````````````````````       cAGJJJ      M,.ed. If none

      // specified, the default creates local date time.

      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeries, DateTime>> _createSampleData() {
    var chartData = seriesList.map((e) {
      final data = e.data();
      final int weight = int.parse(data.weight!);
      return TimeSeries(data.date, weight);
    }).toList();

    return [
      charts.Series<TimeSeries, DateTime>(
        id: 'Weight',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeries sales, _) => sales.time,
        measureFn: (TimeSeries sales, _) => sales.weight,
        data: chartData.sublist(0, 6),
      ),
    ];
  }
}

class TimeSeries {
  final DateTime time;
  final int weight;

  TimeSeries(
    this.time,
    this.weight,
  );
}
