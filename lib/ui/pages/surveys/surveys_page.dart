import 'package:flutter/material.dart';
import '../../mixins/mixins.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/componets.dart';
import '../../components/reload_screen.dart';
import '../../helpers/i18n/i18n.dart';
import 'components/components.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  const SurveysPage(this.presenter);

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> with LoadingManager, NavigationManager, SessionManager , RouteAware {
  @override
  Widget build(BuildContext context) {

    final routeObserver=Get.find<RouteObserver>();
    routeObserver.subscribe(this, ModalRoute.of(context));

  

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
      ),
      body: Builder(builder: (context) {
    widget.presenter.loadData();
        handleLoading(context, widget.presenter.isLoadingStream);

        handleSessionExpired(widget.presenter.isSessionExpiredStream);
        
        handleNavigation(widget.presenter.navigateToStream);

        return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.loadSurveysStrem,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: widget.presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Provider(
                    create: (_) => widget.presenter,
                    child: SurveyItems(snapshot.data));
              }

              return Container();
            });
      }),
    );
  }
 @override  
void didPopNext(){
  widget.presenter.loadData();

}
  @override   
  void dispose() {
    super.dispose();
   
    final routeObserver=Get.find<RouteObserver>();
    routeObserver.unsubscribe(this, );

  }
}
