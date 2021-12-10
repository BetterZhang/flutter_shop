import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车')
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          List cartList = context.read<CartProvide>().cartList;
          if (snapshot.hasData && cartList != null) {
            return Stack(
              children: <Widget>[
                ListView.builder(
                  itemCount: context.watch<CartProvide>().cartList.length,
                  itemBuilder: (context, index) {
                    return CartItem(context.watch<CartProvide>().cartList[index]);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                )
              ],
            );
          } else {
            return Text('正在加载');
          }
        }
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await context.read<CartProvide>().getCartInfo();
    return 'end';
  }
}




