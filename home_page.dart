import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Shrijansrm264/models/data_model.dart';
import 'package:Shrijansrm264/add_edit_product.dart';
import 'package:Shrijansrm264/services/db_service.dart';
import 'package:Shrijansrm264/utils/form_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBService dbService;

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Movie Tracker App"),
      ),
      body: _fetchData(),
    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<Movie>>(
      future: dbService.getProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Movie>> products) {
        if (products.hasData) {
          return _buildUI(products.data);
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildUI(List<Movie> products) {
    List<Widget> widgets = new List<Widget>();

    widgets.add(
      new Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditProduct(),
              ),
            );
          },
          child: Container(
            height: 40.0,
            width: 100,
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                "Add Product",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildDataTable(products)],
      ),
    );

    return Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
      padding: EdgeInsets.all(10),
    );
  }

  Widget _buildDataTable(List<Movie> model) {
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            "Product Name",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Price",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Action",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      sortColumnIndex: 1,
      rows: model
          .map(
            (data) => DataRow(
          cells: <DataCell>[
            DataCell(
              Text(
                data.MovieName,
                style: TextStyle(fontSize: 12),
              ),
            ),
            DataCell(
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditProduct(
                              isEditMode: true,
                              model: data,
                            ),
                          ),
                        );
                      },
                    ),
                    new IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        FormHelper.showMessage(
                          context,
                          "SQFLITE CRUD",
                          "Do you want to delete this record?",
                          "Yes",
                              () {
                            dbService.deleteProduct(data).then((value) {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            });
                          },
                          buttonText2: "No",
                          isConfirmationDialog: true,
                          onPressed2: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .toList(),
    );
  }
}
