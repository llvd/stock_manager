
class Item {
  int id;
  String name;
  String date;
  String code;
  num stock;

  Item(String name, String date, String code, num stock) {
    this.name = name;
    this.date = date;
    this.code = code;
    this.stock = stock;
  }
  

  Map<String, dynamic> toMap() => {
    "name": name,
    "date": date,
    "code": code,
    "stock": stock
  };

  Item.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    name = map['name'];
    date = map['date'];
    code = map['code'];
    stock = map['stock'];
  }
}