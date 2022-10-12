import 'package:flutter/material.dart';
import 'components.dart';

import '../survey_result.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final void Function({@required String answer}) onSave;
  const SurveyResult({@required this.viewModel,@required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(question: viewModel.question);
        }

        return GestureDetector(onTap:()=> onSave(answer:viewModel.answers[index-1].answer), child: SurveyAnswer(viewModel: viewModel.answers[index-1]));
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
