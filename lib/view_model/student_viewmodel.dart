import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/student.dart';
import '../state/student_state.dart';

final resultViewModelProvider =
    StateNotifierProvider<ResultViewModel, ResultState>(
        (ref) => ResultViewModel());

class ResultViewModel extends StateNotifier<ResultState> {
  // final List<Result> _marks = [];

  // List<Result> get marks => marks;
  //Constructor
  //providing initial state
  ResultViewModel() : super(ResultState.initial());

  //Add marks
  void addResult(Result result) {
    //make progress bar run
    state = state.copyWith(isLoading: true);
  
    //Add result to list
    state.marks.add(result);
    // notifyListeners();
    // print(state.students.length);

    // make progress bar stop
    state = state.copyWith(isLoading: false);
  }

  void removeResult(String? id) {
    state.marks.removeWhere((result) => result.id == id);
    // notifyListeners();
    // notifyListeners();
  }
}
