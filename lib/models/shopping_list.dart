class ShoppingList {
  int? _id;
  String name;
  int priority = 1;

  ShoppingList({required this.name, int? id, this.priority = 1}) {
    _id = id;
    name = name;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': (_id==0)? null:_id,
      'name': name,
      'priority': priority
    };
  }

  setId(int id)=> _id ??= id;

  int? getId() {
    return _id;
  }
}