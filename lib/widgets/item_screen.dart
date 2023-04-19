import 'package:flutter/material.dart';
import 'package:shopping_list_app/widgets/list_item_dialog.dart';
import '../util/dbhelper.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';

class ItemScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ItemScreen({required this.shoppingList, Key? key}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  DbHelper helper = DbHelper();
  ListItemDialog? lIDialog;
  List<ListItem> items = <ListItem>[];

  _ItemScreenState() {
    super.initState();
  }

  showData() async {
    items = await helper.getItems(widget.shoppingList);
    setState(() {
      items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    lIDialog = ListItemDialog();
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          Dismissible(
              key: Key(items[index].name),
              onDismissed: (direction) {
                String strName = items[index].name;
                helper.deleteItem(items[index]);
                setState(() {
                  items.removeAt(index);
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("$strName deleted")));
              },
              child: ListTile(
                title: Text(items[index].name),
                subtitle: Text(
                    'Quantity: ${items[index].quantity}  - Note: ${items[index].note}'),
                onTap: () {},
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => lIDialog!
                            .buildDialog(context, items[index], false));
                  },
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(widget.shoppingList.toMap());
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  lIDialog!.buildDialog(context, ListItem(name: '', shoppingList: widget.shoppingList), true));
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }
}
