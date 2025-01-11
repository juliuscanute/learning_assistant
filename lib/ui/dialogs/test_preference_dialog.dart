import 'package:flutter/material.dart';

enum TestPreference {
  mcq,
  written,
  random,
}

void showTestPreferenceDialog(
    BuildContext context, Function(TestPreference) onPreferenceSelected) {
  TestPreference preference = TestPreference.mcq;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Test Preference"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<TestPreference>(
                  title: const Text("MCQ"),
                  value: TestPreference.mcq,
                  groupValue: preference,
                  onChanged: (TestPreference? value) {
                    setState(() {
                      preference = value!;
                    });
                  },
                ),
                RadioListTile<TestPreference>(
                  title: const Text("Written"),
                  value: TestPreference.written,
                  groupValue: preference,
                  onChanged: (TestPreference? value) {
                    setState(() {
                      preference = value!;
                    });
                  },
                ),
                RadioListTile<TestPreference>(
                  title: const Text("Random"),
                  value: TestPreference.random,
                  groupValue: preference,
                  onChanged: (TestPreference? value) {
                    setState(() {
                      preference = value!;
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              onPreferenceSelected(preference);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
