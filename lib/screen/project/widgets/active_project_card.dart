import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ActiveProjectsCard extends StatelessWidget {
   Color? cardColor;
   Color? radColor;
   double? loadingPercent;
   String? title;
   String? income;
   String? expense;
   double? radiusss;
   double? height;

  ActiveProjectsCard({
    this.cardColor,
    this.loadingPercent,
    this.title,
    this.income,
    this.expense,
    this.radiusss,
    this.height,
    this.radColor
  });


  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        
        margin: EdgeInsets.symmetric(vertical: 2.0),
        padding: EdgeInsets.all(8.0),
        height: height,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircularPercentIndicator(
                animation: true,
                radius: radiusss!,
                percent: loadingPercent!,
                lineWidth: 5.0,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: radColor!,
                progressColor:radColor,
                center: Text(
                  '${(loadingPercent!*100).round()}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                 title!,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "+"+income!,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "-"+ expense!,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
