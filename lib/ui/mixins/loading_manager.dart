import 'package:flutter/material.dart';

import '../components/componets.dart';

mixin LoadingManager{

  void handleLoading(BuildContext context,Stream<bool> stream){

   stream.listen((isLoading) {


            if (isLoading==true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }


            
          },
        );

  }
}