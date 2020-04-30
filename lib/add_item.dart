import 'package:flutter/material.dart';
import 'package:invmanager/model/item_model.dart';
import 'package:invmanager/utils/database.dart';

class AddItemPage extends StatefulWidget {
  AddItemPage({Key key}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final dateController = TextEditingController();
  final qtyController = TextEditingController();

  void pickPhoto() {

  }

  void addToDb() async {
    int qty = int.parse(qtyController.text);
    Item item = Item(nameController.text, codeController.text, dateController.text, qty);
    await DbProvider.db.newItem(item);
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    dateController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(color: Colors.blue, height: 250),
        Positioned(
          child: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 60),
                alignment: Alignment.center,
                child: Text("Add Stock",
                    style: TextStyle(fontSize: 40, color: Colors.white))),
            Card(
              margin: EdgeInsets.all(25),
              elevation: 5,
              child: Column(
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Nama barang"
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                         TextFormField(
                          controller: codeController,
                          decoration: InputDecoration(
                            labelText: "Kode barang"
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: "Tanggal Masuk"
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          controller: qtyController,
                          decoration: InputDecoration(
                            labelText: "Jumlah barang masuk"
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Tidak boleh kosong";
                            } else if (int.tryParse(value) == null) {
                              return "Numbers only";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OutlineButton(
                              borderSide: BorderSide(
                                color: Colors.blue
                              ),
                              onPressed: pickPhoto,
                              child: Text("Gambar", style: TextStyle(color: Colors.blue),),
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              onPressed: addToDb,
                              child: Text("Input", style: TextStyle(color: Colors.white))
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ],
              ),
            )
          ]),
        )
      ],
    );
  }
}
