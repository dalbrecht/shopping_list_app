import 'shopping_list.dart';

class ListItem {
  int? _id;
  ShoppingList? shoppingList;
  String name;
  String quantity = "";
  String note = "";

  ListItem({required this.name, int? id, this.shoppingList, this.quantity = "", this.note = ""}){
    _id = id;
    name = name;
    shoppingList = shoppingList;
    quantity = quantity;
    note = note;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'idList': shoppingList!.getId(),
      'name': name,
      'quantity': quantity,
      'note': note
    };
  }
  setId(id) => _id ??= id;
  int? getId() {
    return _id;
  }
}