import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myCubitProvider = StateNotifierProvider<MyCubit>((ref) => MyCubit());

class MyScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myState = ref.watch(myCubitProvider.select((state) => state.counter));
    useEffect(() {
      final sub = ref.listen(
        myCubitProvider.state.select((state) => state.counter),
        (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Counter updated to $value')),
          );
        },
      );
      return sub.cancel;
    }, []);
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to my screen!'),
            SizedBox(height: 16),
            Text('Counter: $myState'),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Increment'),
              onPressed: () => ref.read(myCubitProvider.notifier).increment(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCubit extends StateNotifier<MyState> {
  MyCubit() : super(MyState());

  void increment() {
    state = state.copyWith(counter: state.counter + 1);
  }
}

class MyState {
  final int counter;

  MyState({this.counter = 0});

  MyState copyWith({int counter}) {
    return MyState(counter: counter ?? this.counter);
  }
}
