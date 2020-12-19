import 'package:flutter/material.dart';
import 'package:todolistapp/models/category.dart';
import 'package:todolistapp/services/category_service.dart';

import 'home_screen.dart';


class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
//controllers
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryServices();

  List<Category> _categoryList = List<Category>();

  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();
  

  @override
  void initState(){
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
 
  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
        setState(() {
          var categoryModel = Category();
          categoryModel.name = category['name'];
          categoryModel.description = category['description'];
          categoryModel.id = category['id'];
          _categoryList.add(categoryModel);
        });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text = category[0]['description']??'No Description';
    });
    return _editFormDialog(context);
  }

  _showFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          FlatButton(
            color: Colors.blue,
            onPressed: () async {
              _category.name = _categoryNameController.text;
              _category.description = _categoryDescriptionController.text;

              var result = await _categoryService.savedCategory(_category);
              print(result);
              Navigator.pop(context);
              getAllCategories();
            },  
            child: Text("Save"),
          ),
        ],
        title: new Text("Category Form"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  hintText: "Write a Category",
                  labelText: 'Category',
                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                  hintText: "Write Description",
                  labelText: "Description",
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  
  _editFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          FlatButton(
            color: Colors.blue,
            onPressed: () async {
              _category.id = category[0]['id'];
              _category.name = _editCategoryNameController.text;
              _category.description = _editCategoryDescriptionController.text;

              var result = await _categoryService.updateCategory(_category);
              if(result > 0){
                Navigator.pop(context);
                getAllCategories();
                showSuccessSnackbar(Text('Updated'));
              }
            },  
            child: Text("Update"),
          ),
        ],
        title: new Text("Edit Categories Form"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editCategoryNameController,
                decoration: InputDecoration(
                  hintText: "Write a Category",
                  labelText: 'Category',
                ),
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: InputDecoration(
                  hintText: "Write Description",
                  labelText: "Description",
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  
  _deleteFormDialog(BuildContext context, categoryId){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.greenAccent ,
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          FlatButton(
            color: Colors.redAccent,
            onPressed: () async {
             
              var result = await _categoryService.deleteCategory(categoryId);
              if(result > 0){
                Navigator.pop(context);
                getAllCategories();
                showSuccessSnackbar(Text('Deleted'));
              }
            },  
            child: Text("Delete"),
          ),
        ],
        title: new Text("Are you sure you want to delete this ?"),
      );
    });
  }

  showSuccessSnackbar(message){
    var _snackbar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackbar);
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _globalKey,
      appBar: new AppBar(
        leading: RaisedButton(
          onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        title: new Text("Categories"),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8.0,
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit), 
                  onPressed: (){
                    _editCategory(context, _categoryList[index].id);
                  },
                  ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_categoryList[index].name),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red, 
                      onPressed: (){
                        _deleteFormDialog(context, _categoryList[index].id);
                      },
                    )
                  ],
                ),
                subtitle: Text(_categoryList[index].description),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}