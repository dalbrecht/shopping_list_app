import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/shopping_list.dart';
import './shopping_list_dialog.dart';
import './item_screen.dart';

class ShList extends StatefulWidget {
  const ShList({Key? key}) : super(key: key);

  @override
  State<ShList> createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();
  ShoppingListDialog? sLDialog;
  List<ShoppingList> shoppingList = <ShoppingList>[];

  @override
  void initState() {
    super.initState();
  }

  Future showData() async {
    List<ShoppingList> newShoppingList = await helper.getLists();
    setState(() {
      shoppingList = newShoppingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    sLDialog = ShoppingListDialog();
    showData();
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping List")),
      body: ListView.builder(
        itemCount: shoppingList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
          key: Key(shoppingList[index].name),
              onDismissed: (direction) {
            String strName = shoppingList[index].name;
            helper.deleteList(shoppingList[index]);
            setState(() {shoppingList.removeAt(index);});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$strName deleted")));
              },
              child: ListTile(
              title: Text(shoppingList[index].name),
              leading: CircleAvatar(
                  child: Text(shoppingList[index].priority.toString())),
              trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => sLDialog!
                            .buildDialog(context, shoppingList[index], false));
                  }),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ItemScreen(shoppingList: shoppingList[index])));
              }));
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  sLDialog!.buildDialog(context, ShoppingList(name: ''), true));
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }
}
