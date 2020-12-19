
import 'package:todolistapp/models/category.dart';
import 'package:todolistapp/repositories/repository.dart';

class CategoryServices{
  Repository _repository;

  CategoryServices(){
    _repository = Repository();
  }

  // create data
  savedCategory(Category category) async{
    return await _repository.insertData('categories', category.categoryMap());
  }
 
  //read data from table
  readCategories() async {
    return _repository.readData('categories');
  }

  // read data by Id
  readCategoryById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

 // update data from table
  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.categoryMap());
  }

  //delete data from table
  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories', categoryId);
  }

}