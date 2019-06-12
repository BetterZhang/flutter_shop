import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会员中心'),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList1(),
          _actionList2(),
        ],
      ),
    );
  }

  // 头像区域
  Widget _topHeader() {
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: ClipOval(
              child: Image.network(
                'http://blogimages.jspang.com/blogtouxiang1.jpg',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Andrew Zhang',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 我的订单顶部
  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          )
        )
      ),
      child: ListTile(
        leading: Icon(Icons.format_list_bulleted),
        title: Text('我的订单'),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  // 我的订单列表区域
  Widget _orderType() {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.monetization_on,
                  size: 30,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  '待付款',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.query_builder,
                  size: 30,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  '待发货',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.directions_car,
                  size: 30,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  '待收货',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.content_paste,
                  size: 30,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  '待评价',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ListTile通用方法
  Widget _myListTile(String title, Icon icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          )
        )
      ),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(30),
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  // 组合List布局
  Widget _actionList1() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          _myListTile('领取优惠券', Icon(Icons.confirmation_number)),
          _myListTile('已领取优惠券', Icon(Icons.confirmation_number)),
          _myListTile('地址管理', Icon(Icons.location_on)),
        ],
      ),
    );
  }

  // 组合List布局
  Widget _actionList2() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          _myListTile('客服电话', Icon(Icons.phone)),
          _myListTile('关于商城', Icon(Icons.info)),
        ],
      ),
    );
  }
  
}