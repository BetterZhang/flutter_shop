import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../service/service_method.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  // FutureBuilder对应的future
  Future _future;
  // 默认经纬度
  var formData = {'lon': '115.02932', 'lat': '35.76189'};

  // 首页火爆商品页码
  int page = 1;
  var formPage;
  // 首页火爆商品list
  List<Map> hotGoodsList = [];

  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  bool get wantKeepAlive => true;

  // 获取首页火爆商品
  void _requestHotGoods() {
    formPage = {'page': page};
    request('homePageBelowConten', formData: formPage).then((val) {
      print('page = $page');
      setState(() {
        var data = json.decode(val.toString());
        hotGoodsList.addAll((data['data'] as List).cast());
        page++;
      });
    });
  }

  @override
  void initState() {
    // FutureBuilder 多次触发解决 https://www.jianshu.com/p/74e52aa09986
    _future = request('homePageContent', formData: formData);
    _requestHotGoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    print('设备像素密度：${ScreenUtil.pixelRatio}');
//    print('设备的高度：${ScreenUtil.screenHeight}');
//    print('设备的宽度：${ScreenUtil.screenWidth}');

    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+')
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList = (data['data']['slides'] as List).cast();
            List<Map> navigatorList = (data['data']['category'] as List).cast();
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendList = (data['data']['recommend'] as List).cast();

            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];  // 楼层1的标题图片
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];  // 楼层1的标题图片
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];  // 楼层1的标题图片
            List<Map> floor1 = (data['data']['floor1'] as List).cast();         // 楼层1商品和图片
            List<Map> floor2 = (data['data']['floor2'] as List).cast();         // 楼层1商品和图片
            List<Map> floor3 = (data['data']['floor3'] as List).cast();         // 楼层1商品和图片

            return EasyRefresh(
              key: _easyRefreshKey,
              autoLoad: false,
              behavior: ScrollBehavior(),
              refreshHeader: ClassicsHeader(
                key: _headerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                refreshText: '下拉可以刷新',
                refreshReadyText: '释放立即刷新',
                refreshingText: '正在刷新...',
                refreshedText: '刷新完成',
                moreInfo: '上次更新',
                showMore: true,
              ),
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                loadText: '上拉加载',
                loadReadyText: '释放立即加载',
                loadingText: '正在加载...',
                loadedText: '加载完成',
                noMoreText: '加载完成',
                moreInfo: '上次加载',
                showMore: true,
              ),
              // 使用flutter_easyrefresh插件，要求我们必须是一个ListView，这里要改造之前的代码
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperDataList),
                  TopGridView(navigatorList: navigatorList),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommend(recommendList: recommendList),
                  FloorTitle(titleImgUrl: floor1Title),
                  FloorContent(floorGoodsList: floor1),
                  FloorTitle(titleImgUrl: floor2Title),
                  FloorContent(floorGoodsList: floor2),
                  FloorTitle(titleImgUrl: floor3Title),
                  FloorContent(floorGoodsList: floor3),
                  _hotGoods()
                ],
              ),
              onRefresh: () async {
                print('下拉刷新');
                await Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    // 首页火爆商品页码重置，集合数据清除
                    page = 1;
                    hotGoodsList.clear();
                    _requestHotGoods();
                  });
                });
              },
              loadMore: () async {
                print('加载更多...');
                await Future.delayed(Duration(seconds: 1), () {
                  _requestHotGoods();
                });
              },
            );
          } else {
            return Center(
              child: Text(
                '加载中...',
                style: TextStyle(fontSize: ScreenUtil().setSp(28)),
              ),
            );
          }
        }
      )
    );
  }

  // 火爆专区标题
  Widget hotTitle = Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(5.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  width: 0.5,
                  color: Colors.black12
              )
          )
      ),
      child: Text('火爆专区')
  );

  // 火爆专区子项
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
//            print('点击了火爆商品');
            Application.router.navigateTo(context, "detail?id=${val['goodsId']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(370)),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: ScreenUtil().setSp(26)
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget
      );
    } else {
      return Text('');
    }
  }

  // 火爆专区组合
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
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
            width: ScreenUtil().setWidth(95),
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
      height: ScreenUtil().setHeight(280),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        physics: NeverScrollableScrollPhysics(),
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw('Could not launch $url');
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  // 标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12)
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 商品单独项方法
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(280),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 1, color: Colors.black12))
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  // 横向列表方法
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(280),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(350),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String titleImgUrl;
  
  FloorTitle({Key key, this.titleImgUrl}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          print('点击了楼层标题');
        },
        child: Image.network(titleImgUrl),
      ),
    );
  }
}

// 楼层商品组件
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2])
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4])
      ],
    );
  }
  
  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了楼层商品');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}





