import 'package:flutter/material.dart';
import 'package:product_cart/providers/dashboard_change_notifier.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardChangeNotifier>(
      builder: (context, _provider, _){
        return Scaffold(
          appBar: AppBar(
            title: Text("Cart"),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ListView.builder(
              itemBuilder: (context, index){
                return Stack(
                    children : <Widget>[
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(18.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  height: 80,
                                  width: 80,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Image.asset("img/laptop.jpg")
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(_provider.listCart[index].productName, overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14
                                          )
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("Rp. ${_provider.formatCurrency(_provider.listCart[index].productPrice)}",
                                                  style: TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 14
                                                  )
                                              ),
                                              SizedBox(height: 10),
                                              Text("(${_provider.listCart[index].productCondition})",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14
                                                  )
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: (){
                                                  _provider.subtractTotal(index);
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: Card(
                                                      color: Colors.red,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),
                                                      child: Icon(Icons.remove)
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(top: 8),
                                                      child: Text(_provider.listCart[index].amount.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 18
                                                          )
                                                      )
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 8),
                                                    child: Text("${_provider.listCart[index].productWeight} kg",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 14
                                                        )
                                                    ),
                                                  )
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  _provider.addTotal(index);
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: Card(
                                                      color: Colors.blue,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),
                                                      child: Icon(Icons.add)
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                );
              },
              itemCount: _provider.listCart.length,
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              elevation: 0,
              child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      child: Card(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 30, top: 10, bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total harga",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14
                                        )
                                    ),
                                    Text("Rp. ${_provider.grandTotal}",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 14
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                color: Colors.orange,
                                child: Text(
                                  "Order",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  )
              )
          ),
        );
      }
    );
  }
}
