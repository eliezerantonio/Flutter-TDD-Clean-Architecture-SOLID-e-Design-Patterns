import 'package:flutter/material.dart';
import '../../mixins/mixins.dart';
import '/ui/components/componets.dart';

import '../../helpers/i18n/i18n.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveyResultPage extends StatelessWidget
    with LoadingManager, SessionManager {
  SurveyResultPage(this.presenter);

  final SurveyResultPresenter presenter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
      ),
      body: Builder(
        builder: (context) {
          presenter.loadData();
          handleLoading(context, presenter.isLoadingStream);

          handleSessionExpired(presenter.isSessionExpiredStream);

          return StreamBuilder<dynamic>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: snapshot.error,
                    reload: presenter.loadData,
                  );
                }
                if (snapshot.hasData) {
                  return SurveyResult(viewModel:snapshot.data, onSave:presenter.save);
                }

                return SizedBox(height: 0);
              });
        },
      ),
    );
  }
}
