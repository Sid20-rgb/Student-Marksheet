import '../model/student.dart';

class ResultUtils {
  static int getTotalMarks(
      List<Result> results, String firstName, String lastName) {
    int total = 0;
    for (Result result in results) {
      if (result.firstname == firstName.trim() &&
          result.lastname == lastName.trim()) {
        bool hasFailedModule = false;
        for (String mark in result.marks!) {
          int markValue = int.tryParse(mark) ?? 0;
          total += markValue;

          if (markValue < 40) {
            hasFailedModule = true;
          }
        }

        if (hasFailedModule) {
          return -1;
        }
      }
    }
    return total;
  }

  static String getResult(int totalMarks) {
    if (totalMarks >= 200) {
      return 'Pass';
    } else {
      return 'Fail';
    }
  }

  static String getDivision(int totalMarks) {
    if (totalMarks >= 60) {
      return '1st Division';
    } else if (totalMarks >= 50) {
      return '2nd Division';
    } else if (totalMarks >= 40) {
      return '3rd Division';
    } else {
      return 'Fail';
    }
  }
}
