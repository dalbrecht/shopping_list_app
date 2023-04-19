import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/list_items.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtNote = TextEditingController();
  final txtQty = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew){
    DbHelper dbHelper = DbHelper();
    if (!isNew) {
      txtName.text = item.name;
      txtNote.text = item.note;
      txtQty.text = item.quantity;
    }
    return AlertDialog(
        title: Text((isNew)? 'New List Item' : 'Edit List Item'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        content: SingleChildScrollView(
            child: Column(children: [
              TextField(
                  controller: txtName,
                  decoration: const InputDecoration(
                      hintText: 'Item Name'

                  )
              ),
              TextField(
                  controller: txtQty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Item Quantity'
                  )

              ),
              TextField(
                  controller: txtNote,
                  decoration: const InputDecoration(
                      hintText: 'Notes'
                  )

              ),
              ElevatedButton(
                  child: const Text('Save Shopping List'),
                  onPressed: () {
                    item.name = txtName.text;
                    item.quantity = txtQty.text;
                    item.note = txtNote.text;
                    dbHelper.insertItem(item);
                    Navigator.pop(context);
                  }
              )
            ])
        )
    );
  }

}
