import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/cart.dart';

class CartCount extends StatelessWidget {

  final item;

  CartCount(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(165),
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black12
        )
      ),
      child: Row(
        children: <Widget>[
          _reduceBtn(context),
          _countArea(),
          _addBtn(context),
        ],
      ),
    );
  }

  // 减少按钮
  Widget _reduceBtn(context) {
    return InkWell(
      onTap: () {
        context.read<CartProvide>().addOrReduceAction(item, 'reduce');
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: item.count > 1 ? Colors.white : Colors.black12,
          border: Border(
            right: BorderSide(
              width: 1,
              color: Colors.black12
            )
          ),
        ),
        child: item.count > 1 ? Text('-') : Text(' '),
      ),
    );
  }

  // 添加按钮
  Widget _addBtn(context) {
    return InkWell(
      onTap: () {
        context.read<CartProvide>(context).addOrReduceAction(item, 'add');
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: 1,
              color: Colors.black12
            )
          ),
        ),
        child: Text('+'),
      ),
    );
  }

  // 数量区域
  Widget _countArea() {
    return Container(
      width: ScreenUtil().setWidth(70),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('${item.count}'),
    );
  }
}
