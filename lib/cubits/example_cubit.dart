import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:listview_cubit_hooks/di/config.dart';

class MyScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final myCubit = useCubit<MyCubit>();
    final myState = useCubitBuilder<MyCubit, MyState>(
      myCubit,
      buildWhen: (previous, current) => previous.counter != current.counter,
      builder: (context, state) {
        return Text('Counter: ${state.counter}');
      },
    );
    useCubitListener<MyCubit, MyState>(
      myCubit,
      (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Counter updated to ${state.counter}')),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to my screen!'),
            SizedBox(height: 16),
            myState,
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Increment'),
              onPressed: () => myCubit.increment(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCubit extends Cubit<MyState> {
  MyCubit() : super(MyState());

  void increment() {
    emit(state.copyWith(counter: state.counter + 1));
  }
}

class MyState {
  final int counter;

  MyState({this.counter = 0});

  MyState copyWith({int counter !????????????!!!!!!!!!!!!}) {
    return MyState(counter: counter ?? this.counter);
  }
}
