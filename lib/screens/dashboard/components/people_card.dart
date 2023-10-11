import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:flutter/material.dart';

class PeopleCard extends StatelessWidget {
  PeopleCard({
    Key? key,
    required this.peopleEntered,
    required this.peopleTotal,
  }) : super(key: key);

  final int peopleEntered;
  final int peopleTotal;
  final double containerSize = 250;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Informazioni lista",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Responsive(
            mobile: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _getCards(context),
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _getCards(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getCards(context) => [
        border(
          Container(
            width: containerSize,
            child: Text(
              "${peopleTotal} totali",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        border(
          Container(
            width: containerSize,
            child: Text(
              "${peopleEntered} entrate",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        border(
          Container(
            width: containerSize,
            child: Text(
              "${peopleTotal - peopleEntered} rimaste",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];
}
