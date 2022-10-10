
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(name: '/survey_result/:survey_id',page: () => SurveyResultPage(presenter),
        ),
      ],
    );

    provideMockedNetworkImages(() async {
       await tester.pumpWidget(surveysPage);
    });

   
  }

  testWidgets("Should call LoadSurveyResult on page load",(WidgetTester tester) async {

    await loadPage(tester);

    verify(presenter.loadData()).called(1);

  });
}
