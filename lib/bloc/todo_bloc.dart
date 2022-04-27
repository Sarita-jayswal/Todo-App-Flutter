import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final StreamController<List<String>> _streamController = BehaviorSubject();
  Stream<List<String>> get outTodoList => _streamController.stream;
  Sink<List<String>> get inTodoList => _streamController.sink;
  TodoBloc() : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
