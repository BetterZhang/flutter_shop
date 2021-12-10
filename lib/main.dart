import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/index_page.dart';
import './provider/counter.dart';
import './provider/child_category.dart';
import './provider/category_goods_list.dart';
import './provider/details_info.dart';
import './provider/cart.dart';
import './provider/currentIndex.dart';
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';

void main() {
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var currentIndexProvide = CurrentIndexProvide();
  var providers = [
    ChangeNotifierProvider(create: (_) => counter),
    ChangeNotifierProvider(create: (_) => childCategory),
    ChangeNotifierProvider(create: (_) => categoryGoodsListProvide),
    ChangeNotifierProvider(create: (_) => detailsInfoProvide),
    ChangeNotifierProvider(create: (_) => cartProvide),
    ChangeNotifierProvider(create: (_) => currentIndexProvide)
  ];

  runApp(
    MultiProvider(
      child: MyApp(),
      providers: providers
    ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;

    return MaterialApp(
      title: '百姓生活+',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router.generator,
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
      home: IndexPage(),
    );
  }
}
