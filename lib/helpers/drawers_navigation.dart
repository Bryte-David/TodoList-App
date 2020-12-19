import 'package:flutter/material.dart';
import 'package:todolistapp/screens/Categories_Screen.dart';
import 'package:todolistapp/screens/home_screen.dart';
import 'package:todolistapp/screens/todos_by_categories.dart';
import 'package:todolistapp/services/category_service.dart';



class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  
  List<Widget> _categoryList = List<Widget>();

  CategoryServices _categoryServices = CategoryServices();

@override
  initState(){
    super.initState();
    getAllCategories();
  }
  
  getAllCategories() async {
    var categories = await _categoryServices.readCategories();

    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
            onTap: () =>Navigator.push(context, new MaterialPageRoute(builder: (context)=> new TodoByCategory(category: category['name'],))),
            child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.red,
              ),
              accountName: Text('bryte'), 
              accountEmail: Text("bryte@hh.com"),
              decoration: BoxDecoration(color: Colors.purple),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()) ),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("Categories"),
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            Divider(),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}