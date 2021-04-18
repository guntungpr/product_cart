import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:product_cart/models/product_model.dart';
import 'package:intl/intl.dart';

class DashboardChangeNotifier with ChangeNotifier {
  bool _loadData = false;
  String _grandTotal = "0";
  NumberFormat _oCcy = NumberFormat("#,##0", "en_US");
  List<ProductModel> _listProduct = [];
  List<ProductModel> _listCart = [];
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UnmodifiableListView<ProductModel> get listProduct => UnmodifiableListView(_listProduct);

  UnmodifiableListView<ProductModel> get listCart => UnmodifiableListView(_listCart);

  bool get loadData => _loadData;

  set loadData(bool value) {
    this._loadData = value;
  }

  String get grandTotal => _grandTotal;

  set grandTotal(String value) {
    this._grandTotal = value;
  }

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  Future<void> getData() async{
    loadData = true;
    this._listProduct.clear();
    try {
      final _response = await http.post("https://ranting.twisdev.com/index.php/rest/items/search/api_key/teampsisthebest/").timeout(Duration(seconds: 30));
      final _result = jsonDecode(_response.body);
      if (_response.statusCode == 200) {
        for(int i=0; i<_result.length; i++){
          double _weight;
          if(_result[i]['weight'] != "" && _result[i]['weight'] != null){
            _weight = double.parse(_result[i]['weight'])/1000;
          }
          else{
            _weight = 0;
          }
          this._listProduct.add(ProductModel(
              _result[i]['id'],
              _result[i]['description'],
              _result[i]['price'],
              _result[i]['location_name'],
              _result[i]['user']['user_name'],
              _weight.toStringAsFixed(2),
              _result[i]['condition_of_item']['name'],
              1
          ));
        }
      }
      else {
        _showSnackBar("No data found");
      }
    }
    on TimeoutException catch(_){
      loadData = false;
      _showSnackBar("Timeout connection");
    }
    catch (e) {
      loadData = false;
      _showSnackBar(e.toString());
    }
    loadData = false;
  }

  void addToCart(ProductModel value) {
    bool _check = false;
    for(int i=0; i<this._listCart.length; i++){
      if(value.id == this._listCart[i].id){
        _check = true;
      }
    }
    if(_check){
      for(int i=0; i<this._listCart.length; i++){
        if(value.id == this._listCart[i].id){
          addTotal(i);
        }
      }
    }
    else{
      this._listCart.add(value);
    }
    calculateTotal();
  }

  void addTotal(int index){
    this._listCart[index].amount +=1;
    calculateTotal();
  }

  void subtractTotal(int index){
    if(this._listCart[index].amount == 1){
      this._listCart.removeAt(index);
    }
    else{
      this._listCart[index].amount -=1;
    }
    calculateTotal();
  }

  void calculateTotal(){
    double _total = 0;
    for(int i=0; i<this._listCart.length; i++){
      _total += this._listCart[i].amount * double.parse(this._listCart[i].productPrice);
    }
    grandTotal = formatCurrency(_total.toString());
    notifyListeners();
  }

  String formatCurrency(String value) {
    String _newValue;
    if(value != ""){
      if (value.contains(",")) {
        _newValue = value.replaceAll(",", "");
      }
      else {
        _newValue = value;
      }
      double _number = double.parse(_newValue);
      double _numberFormat = double.parse((_number).toStringAsFixed(2));
      String _currency = _oCcy.format(_numberFormat);
      return _currency;
    }
    else{
      return "";
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating, backgroundColor: Colors.red));
  }
}
