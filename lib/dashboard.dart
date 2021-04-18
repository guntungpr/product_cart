import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_cart/cart.dart';
import 'package:product_cart/providers/dashboard_change_notifier.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> _loadData;

  @override
  void initState() {
    super.initState();
    _loadData = Provider.of<DashboardChangeNotifier>(context,listen: false).getData();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardChangeNotifier>(
      builder: (context, _provider, _){
        return Scaffold(
          key: _provider.scaffoldKey,
          floatingActionButton: Container(
            width: 160,
            child: FloatingActionButton(
              onPressed: (){},
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.list),
                        Text("Category")
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.filter_alt_rounded),
                        Text("Filter")
                      ],
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            title: Text("Dashboard"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // _provider.getData();
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CartPage()));
                },
              )
            ],
          ),
          body: FutureBuilder(
            future: _loadData,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return _provider.listProduct.isNotEmpty
                    ?
                GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation:3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              height: 150,
                              child: Image.asset("img/laptop.jpg")
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width/37),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_provider.listProduct[index].productName,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14
                                      )
                                  ),
                                  Text("Rp. ${_provider.formatCurrency(_provider.listProduct[index].productPrice)}",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 14
                                      )
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.location_on),
                                                Expanded(
                                                  child: Text(_provider.listProduct[index].productLocation, overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.person_rounded),
                                                Expanded(
                                                  child: Text(_provider.listProduct[index].productUsername, overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                            RaisedButton(
                                              onPressed: () {
                                                _provider.addToCart(_provider.listProduct[index]);
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)),
                                              color: Colors.blue,
                                              child: Text(
                                                "Order",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Image.asset("img/halal.png", width: 70, height: 70)
                                      ),
                                    ],
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: _provider.listProduct.length,
              )
                    :
                Center(child: Image.asset("img/no_data.png"));
            },
          ),
        );
      },
    );
  }
}
