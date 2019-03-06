import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据';

  @override
  void initState() {
    getHomePageContent().then((data) {
      print('首页商品信息 = $data');
      setState(() {
        homePageContent = data.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+')
      ),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList = (data['data']['slides'] as List).cast();
            List<Map> navigatorList = (data['data']['category'] as List).cast();
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperDataList),
                  TopGridView(navigatorList: navigatorList),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone)
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                '加载中...',
                style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(28)),
              ),
            );
          }
        }
      )
    );
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // 图片高度像素
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (context, index) {
          return Image.network(
            swiperDataList[index]['image'],
            fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 顶部分类 GridView
class TopGridView extends StatelessWidget {
  final List navigatorList;

  TopGridView({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItem(item) {
    return InkWell(
      onTap: () {
        print('点击了导航$item');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil.getInstance().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 删除超过10的部分
    if (this.navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil.getInstance().setHeight(280),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItem(item);
        }).toList(),
      )
    );
  }
}

// 横条广告
class AdBanner extends StatelessWidget {
  final String adPicture;
  
  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          print('点击了横条广告');
        },
        child: Image.network(adPicture),
      ),
    );
  }
}

// 店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; // 店长电话
  
  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchUrl,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchUrl() async {
    String url = 'tel:$leaderPhone';
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw('url不能访问，异常');
    }
  }
}



