import 'package:admin/screens/components/table_button.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class PriceCard extends StatelessWidget {
  PriceCard({
    Key? key,
    required this.title,
    this.description = "",
    required this.amount,
    required this.onDelete,
  }) : super(key: key);

  final String title;
  final String description;
  final double amount;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    Color color = amount > 0 ? Colors.green : Colors.red;
    IconData icon = amount > 0 ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: kPrimaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Container(
              child: Icon(
                icon,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  description == ""
                      ? Container()
                      : Text(
                          description,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                ],
              ),
            ),
          ),
          Text(
            "${amount.toStringAsFixed(2)} €",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            width: defaultPadding,
          ),
          TableButton(
            color: Colors.red,
            icon: Icons.close,
            isDisabled: title == "Spesa" ||
                title == "Prevendite" ||
                title == "Sconti" ||
                title == "Ingressi",
            onPressed: onDelete,
          )
        ],
      ),
    );
  }
}
