import 'package:flutter/material.dart';
import 'dart:convert';
import '../model/details.dart';
import '../service/service_method.dart';

class DetailsInfoProvide with ChangeNotifier {

  DetailsModel goodsInfo = null;

  // 从后台获取商品信息
  getGoodsInfo(String id) async {
    var formData = {'goodsId': id};

    await request('getGoodDetailById', formData: formData).then((val) {
      var responseData = json.decode(val.toString());
      print(responseData);

      goodsInfo = DetailsModel.fromJson(responseData);

      notifyListeners();
    });
  }

}