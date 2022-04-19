import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/shop_list_page.dart';
import 'package:flutter_shop/pages/tabs/tabs_page.dart';

final Map<String, WidgetBuilder> routers = {
  "/": (context) => TabsPage(),
  "/shop_list": (context, {arguments}) => ShopListPage(arguments),
};

var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  final Function pageContentBuilder = routers[name]!;
  if (settings.arguments != null) {
    var route = MaterialPageRoute(builder: (context) {
      return pageContentBuilder(context, arguments: settings.arguments);
    });
    return route;
  } else {
    var route = MaterialPageRoute(builder: (context) {
      return pageContentBuilder(context);
    });
    return route;
  }
};
