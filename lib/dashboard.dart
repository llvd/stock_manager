import 'package:flutter/material.dart';
import 'package:invmanager/model/item_model.dart';
import 'package:invmanager/utils/database.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _searchController = TextEditingController();   
  List<Item> items = new List<Item>();
  List<Item> _filteredItems = new List<Item>();

  void _searchHandler(String q) {
    if (q.isEmpty) {
      setState(() {
        _filteredItems.clear();
        _filteredItems.addAll(items);
      });
      return;
    }
    List<Item> tempStore = new List<Item>();
    items.forEach((element) {
      if (element.name.toLowerCase().contains(q.toLowerCase())) {
        tempStore.add(element);
      }  
    });
    setState(() {
      _filteredItems.clear();
      _filteredItems.addAll(tempStore);
    });
  }

  Future<dynamic> _fetchItems() async {
    var dbItems = await DbProvider.db.getItems();
    if (dbItems != null) {
      setState(() {
        items.addAll(dbItems);
        _filteredItems.addAll(items);
      });
    }
  }
  
  Widget buildUiWidget() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: _searchHandler,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Search",
                prefixIcon: Icon(Icons.search)
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: items.length > 0 ? ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/img_placeholder.png'),
                      ),
                      SizedBox(width: 20,),
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text("${_filteredItems[index].name}", style: TextStyle(
                              fontWeight: FontWeight.w600
                            ),),
                            Text("${_filteredItems[index].date}"),
                            Text("Code: ${_filteredItems[index].code}"),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("${_filteredItems[index].stock} stocks", style: TextStyle(
                        color: Colors.blue,
                      ),)
                    ],
                  )
                ],
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
    ); 
  }

  @override
  void initState() { 
    super.initState();
    _fetchItems();
  }

  @override
  void dispose() { 
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUiWidget(); 
  }
}
