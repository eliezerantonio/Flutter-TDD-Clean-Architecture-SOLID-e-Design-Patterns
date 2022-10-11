import 'package:flutter/material.dart';

import '../../pages.dart';
import 'components.dart';

class SurveyAnswer extends StatelessWidget {
  const SurveyAnswer({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SurveyAnswerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItems() {
      List<Widget> children = [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            viewModel.answer,
            style: TextStyle(fontSize: 16),
          ),
        )),
        Text(
          viewModel.percent,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark),
        ),
        viewModel.isCurrentAnswer ? ActiveIcon() : DisabledIcon()
      ];

      if (viewModel.image != null) {
        children.insert(0, Image.network(viewModel.image, width: 40));
      }

      return children;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildItems()),
        ),
        Divider(height: 1)
      ],
    );
  }
}
