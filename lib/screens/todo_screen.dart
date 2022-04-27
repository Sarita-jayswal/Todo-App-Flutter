import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/bloc/todo_bloc.dart';
import 'package:todo_hive/services/hive_service.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController todoController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  TodoBloc todoBloc = TodoBloc();

  clearText() {
    todoController.clear();
    editController.clear();
  }

  String? inputTask;
  var box = Hive.box("TODOs");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To Do App"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_key.currentState!.validate()) {
            List<String> inputTaskList = HiveService().getTODOs();
            inputTaskList.add(todoController.text);
            todoController.clear();
            HiveService().saveTODOs(inputTaskList);
            todoBloc.inTodoList.add(inputTaskList);
          }
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _key,
                child: TextFormField(
                  controller: todoController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.dangerous_outlined),
                      onPressed: () {
                        clearText();
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Enter Task Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required';
                    }
                    return null;
                  },
                ),
              ),
            ),
            StreamBuilder<List<String>>(
                initialData: HiveService().getTODOs(),
                stream: todoBloc.outTodoList,
                builder: (context, outTodoListSnapshot) {
                  return Column(
                      children: List.generate(outTodoListSnapshot.data!.length,
                          (index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.hive_outlined),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: TextField(
                                            controller: editController,
                                            decoration: const InputDecoration(
                                                labelText: "Enter Task Name"),
                                          ),
                                          actions: [
                                            InkWell(
                                                onTap: () {
                                                  outTodoListSnapshot
                                                          .data![index] =
                                                      editController.text;
                                                  editController.clear();
                                                  HiveService().saveTODOs(
                                                      outTodoListSnapshot
                                                          .data!);
                                                  todoBloc.inTodoList.add(
                                                      outTodoListSnapshot
                                                          .data!);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Edit"))
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.edit)),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  outTodoListSnapshot.data!.removeAt(index);
                                  HiveService()
                                      .saveTODOs(outTodoListSnapshot.data!);
                                  todoBloc.inTodoList
                                      .add(outTodoListSnapshot.data!);
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                        title: Text(outTodoListSnapshot.data![index]),
                      ),
                    );
                  }));
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
