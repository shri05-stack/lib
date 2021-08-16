import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Shrijansrm264/models/data_model.dart';
import 'package:Shrijansrm264/home_page.dart';
import 'package:Shrijansrm264/services/db_service.dart';
import 'package:Shrijansrm264/utils/form_helper.dart';

class AddEditProduct extends StatefulWidget {
  AddEditProduct({Key key, this.model, this.isEditMode = false})
      : super(key: key);
  Movie model;
  bool isEditMode;

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  Movie model;
  DBService dbService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
    model = new Movie();

    if (widget.isEditMode) {
      model = widget.model;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? "Edit Movie" : "Add Movie"),
      ),
      body: new Form(
        key: globalFormKey,
        child: _formUI(),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("Movie Name"),
                FormHelper.textInput(
                  context,
                  model.MovieName,
                      (value) => {
                    this.model.MovieName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter Movie Name.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Director of the movie"),
                FormHelper.textInput(
                    context,
                    model.DirName,
                        (value) => {
                      this.model.DirName = value,
                    },
                    isTextArea: true, onValidate: (value) {
                  return null;
                }),
                FormHelper.fieldLabel("Select Poster Image"),
                FormHelper.picPicker(
                  model.PosterImg,
                      (file) => {
                    setState(
                          () {
                        model.PosterImg = file.path;
                      },
                    )
                  },
                ),
                btnSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget btnSubmit() {
    return new Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          if (validateAndSave()) {
            print(model.toMap());
            if (widget.isEditMode) {
              dbService.updateProduct(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "SQFLITE CRUD",
                  "Data Submitted Successfully",
                  "Ok",
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                );
              });
            } else {
              dbService.addProduct(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "SQFLITE CRUD",
                  "Data Modified Successfully",
                  "Ok",
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                );
              });
            }
          }
        },
        child: Container(
          height: 40.0,
          margin: EdgeInsets.all(10),
          width: 100,
          color: Colors.blueAccent,
          child: Center(
            child: Text(
              "Save Movie",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
