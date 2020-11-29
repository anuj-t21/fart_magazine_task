import 'package:flutter/material.dart';
import '../providers/restaurants.dart' as rest;
import 'package:dio/dio.dart';

class RestaurantItem extends StatefulWidget {
  final rest.RestaurantItem restaurants;

  RestaurantItem(this.restaurants);
  @override
  _RestaurantItemState createState() => _RestaurantItemState();
}

class _RestaurantItemState extends State<RestaurantItem> {
//  Future<void> calculateETA() async {
//    Dio dio = new Dio();
//    Response response = await dio.get(
//        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=${widget.restaurants.location.latitude.toString()},${widget.restaurants.location.longitude.toString()}&key=AIzaSyB3-WSmFaDvweanVzY223ZYFWT5UbKcZMU");
//    print(response.data);
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    calculateETA();
//  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(widget.restaurants.title),
          subtitle: Text(widget.restaurants.location.latitude.toString()),
        ),
        Divider(),
      ],
    );
  }
}
