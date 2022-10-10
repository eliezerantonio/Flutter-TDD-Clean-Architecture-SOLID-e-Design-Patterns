
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../surveys.dart';
import 'components.dart';

class SurveyItems extends StatelessWidget {
  const SurveyItems(this.viewModels) ;

  final List<SurveyViewModel> viewModels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        items: viewModels.map((viewModel) => SurveyItem(viewModel))
            .toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
        ),
      ),
    );
  }
}
