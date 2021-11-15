import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/ProgressGalleryCard.dart';

const List<Color> gradientColors = [
  Color(0xff23b6e6),
  Color(0xff02d39a),
];

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

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kSpacing * 2,
      ),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.50,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xff232d37)),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18.0,
                  left: 12.0,
                  top: 60,
                  bottom: 12,
                ),
                child: LineChart(
                  mainData(),
                ),
              ),
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
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xff37434d),
          width: 1,
        ),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
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
