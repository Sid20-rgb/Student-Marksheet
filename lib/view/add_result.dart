import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/calculation.dart';
import '../model/student.dart';
import '../view_model/student_viewmodel.dart';

class ResultView extends ConsumerStatefulWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultViewState();
}

class _ResultViewState extends ConsumerState<ResultView> {
  final firstNameController = TextEditingController(text: '');
  final lastNameController = TextEditingController(text: '');
  final marksController = TextEditingController(text: '');
  List<String> moduleList = [
    'Flutter',
    'Api',
    'Design',
    'Individual',
    'AI'
  ]; // List of values for dropdown
  List<String> selectedModule = [
    'Flutter'
  ]; // Initially selected dropdown value

  @override
  Widget build(BuildContext context) {
    var resultState = ref.watch(resultViewModelProvider);

    List<Result> results = resultState.marks;

    List<DataRow> dataTableRows = [];

    for (Result result in results) {
      if (result.firstname == firstNameController.text.trim() &&
          result.lastname == lastNameController.text.trim()) {
        dataTableRows.add(
          DataRow(
            cells: [
              DataCell(Text(result.module![0])),
              DataCell(Text(result.marks!.join(', '))),
              DataCell(
                IconButton(
                  onPressed: () {
                    ref
                        .read(resultViewModelProvider.notifier)
                        .removeResult(result.id);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        );
      }
    }

    // int totalMarks = ResultUtils.getTotalMarks(results, firstNameController.text, lastNameController.text);
    // String result = ResultUtils.getResult(totalMarks);
    // String division = ResultUtils.getDivision(totalMarks);

    int getTotalMarks() {
      List<Result> results = resultState.marks;
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      return ResultUtils.getTotalMarks(results, firstName, lastName);
    }

    String getResult() {
      int totalMarks = getTotalMarks();
      return ResultUtils.getResult(totalMarks);
    }

    String getDivision() {
      int totalMarks = getTotalMarks();
      return ResultUtils.getDivision(totalMarks);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Marksheet'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter firstname',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter lastname',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Please select a batch';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
                labelText: 'Select Module',
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedModule = [newValue!];
                });
              },
              items: moduleList.map<DropdownMenuItem<String>>(
                (String module) {
                  return DropdownMenuItem<String>(
                    value: module,
                    child: Text(
                      module,
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: marksController,
              decoration: const InputDecoration(
                hintText: 'Enter Marks',
                border: OutlineInputBorder(), // Add a border around the field
                // You can also customize other decoration options here
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // background // rounded corners
              ),
              onPressed: () {
                Result result = Result(
                  firstname: firstNameController.text.trim(),
                  lastname: lastNameController.text.trim(),
                  marks: marksController.text.trim().split(','),
                  module: selectedModule,
                );

                ref.read(resultViewModelProvider.notifier).addResult(result);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Marks added'),
                  ),
                );
              },
              child: const Text('Add'),
            ),
            const SizedBox(height: 10),
            if (dataTableRows.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Text(
                            'First Name: ${firstNameController.text.trim()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Last Name: ${lastNameController.text.trim()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Module')),
                          DataColumn(label: Text('Marks')),
                          DataColumn(label: Text('')),
                        ],
                        rows: dataTableRows,
                      ),
                    ],
                  ),
                ),
              ),
            if (dataTableRows.isEmpty)
              const Text(
                'Data chaina',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),
            Text(
              'Total Marks: ${getTotalMarks()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Result: ${getResult()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Division: ${getDivision()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
