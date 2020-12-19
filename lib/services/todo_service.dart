
import 'package:todolistapp/models/todo.dart';
import 'package:todolistapp/repositories/repository.dart';

class TodoService{
  Repository _repository;
  
  TodoService(){
    _repository = Repository();
  }
 
  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  //read todos
  readTodos() async {
    return await _repository.readData('todos');
  }

  //read todos by category
  readTodoByCategory(category) async {
    return await _repository.readDataByColumnName("todos", "category", category);
  }

}