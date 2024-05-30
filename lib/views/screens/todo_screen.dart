import 'package:flutter/material.dart';
import 'package:homework_47/viewmodels/todo_viewmodel.dart';
import 'package:homework_47/views/widgets/manage_todo.dart';

import '../../models/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final todosViewModel = TodosViewModel();

  void addTodo() async {
    final data = await showDialog(
      context: context,
      builder: (ctx) {
        return const ManageTodoDialog();
      },
    );

    if (data != null) {
      try {
        todosViewModel.addTodo(
          data['title'],
          data['date'],
          data['isCompleted'],
        );
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  void editTodo(Todo todo) async {
    final data = await showDialog(
      context: context,
      builder: (ctx) {
        return ManageTodoDialog(todo: todo);
      },
    );

    if (data != null) {
      todosViewModel.editTodo(
        todo.id,
        data['title'],
        data['date'],
        data['isCompleted'],
      );
      setState(() {});
    }
  }
  void changeStatus(String id, bool isCompleted){
    todosViewModel.changeStatus(id, isCompleted);
  }
  void deleteTodo(Todo todo) async {
    final response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Ishonchingiz komilmi?"),
          content: Text("Siz ${todo.title} nomli vazifani o'chirmoqchisiz."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Bekor qilish"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Ha, ishonchim komil"),
            ),
          ],
        );
      },
    );

    if (response) {
      await todosViewModel.deleteTodo(todo.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: const Text(
          "ToDo App",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: todosViewModel.list,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Rejalar mavjud emas, iltimos qo'shing"),
            );
          }
          final todos = snapshot.data;
          return todos == null || todos.isEmpty
              ? const Center(
                  child: Text("Rejalar mavjud emas, iltimos qo'shing"),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.amber)),
                          leading: todo.isCompleted
                              ? IconButton(
                                  onPressed: () {
                                    changeStatus(todo.id, !todo.isCompleted);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    changeStatus(todo.id, !todo.isCompleted);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.circle_outlined),
                                ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationThickness: 2,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          subtitle: Text(
                            todo.date,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  editTodo(todo);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteTodo(todo);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: Icon(Icons.add),
      ),
    );
  }
}
