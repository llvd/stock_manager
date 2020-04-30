import 'package:flutter/material.dart';
import 'package:invmanager/model/item_model.dart';
import 'package:invmanager/utils/database.dart';

class RemoveItemPage extends StatefulWidget {
  RemoveItemPage({Key key}) : super(key: key);

  @override
  _RemoveItemPageState createState() => _RemoveItemPageState();
}

class _RemoveItemPageState extends State<RemoveItemPage> {
  List<TextEditingController> _controllers = new List<TextEditingController>();
  List<Item> items = new List<Item>();

  Future<dynamic> _fetchItems() async {
    var dbItems = await DbProvider.db.getItems();
    if (dbItems != null) {
      setState(() {
        items.addAll(dbItems);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }


  @override
  Widget build(BuildContext context) {
    void editStock(int index) {
      List<Item> copy = List.from(items);
      int newAmount = copy[index].stock - int.parse(_controllers[index].text);
      if (newAmount < 0) {
        newAmount = 0;
      }
      copy[index].stock = newAmount;
      setState(() {
        items.clear();
        items.addAll(copy);
      });
      DbProvider.db.editStock(items[index]);
    }

    return Container(
       child: Container(
         child: Column(
           children: <Widget>[
             SizedBox(height: 30),
              Center(
                child: Text("List Items", style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 22
                ),),
              ),
              SizedBox(height: 30),
              Expanded(
                child: items.length > 0 ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    _controllers.add(TextEditingController());
                    return Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("${items[index].name}", style: TextStyle(
                                fontWeight: FontWeight.w600
                              ),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("${items[index].date}", ),
                              ),
                              Text("${items[index].stock} stocks", style: TextStyle(
                                color: Colors.blue
                              ),)
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Kode: ${items[index].code}")
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                child: Text("Barang keluar"),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  height: 30,
                                  child: TextField(
                                    controller: _controllers[index],
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder()
                                    ),
                                  ),
                                ),
                              ),
                              FlatButton(
                                color: Colors.red,
                                textColor: Colors.white,
                                onPressed: () {editStock(index);}, 
                                child: Text("Ok")
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ) : Center(
                  child: Text("No item to be displayed", style: TextStyle(
                    fontSize: 22
                  ),),
                ),
              )
           ],
         ),
       ),
    );
  }
}