import 'package:flutter_tdd_clean_architecture/ui/pages/surveys/surveys_presenter.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../composites/composites.dart';
import '../../usecases/usecases.dart';

SurveysPresenter makeGetxSurveyPresenter()=>GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveysWithLocalFallback());