import 'package:flutter/material.dart';
import 'package:flutter_app/model/shoppingItem.dart';
import 'package:flutter_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

class AddShoppingItem extends StatefulWidget {
  final ShoppingItem shoppingItem;
  AddShoppingItem(this.shoppingItem);

  @override
  State<StatefulWidget> createState() => AddShoppingItemState(shoppingItem);

}

class AddShoppingItemState extends State {
  ShoppingItem shoppingItem;
  AddShoppingItemState(this.shoppingItem);
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameController.text =shoppingItem.name;
    amountController.text = shoppingItem.amount.toString();
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(shoppingItem.name),
    ),
    body:Column(
      children: <Widget>[
        TextField(
          controller: nameController,
          style: textStyle,
          decoration: InputDecoration(
            labelText: 'Product',
            labelStyle: textStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0)
            )
          ),
        ),
                TextField(
          controller: amountController,
         keyboardType: TextInputType.number,
          style: textStyle,
          decoration: InputDecoration(
            labelText: 'Amount',
            labelStyle: textStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0)
            )
          ),
        )
      ],
    )
    );
  }
}