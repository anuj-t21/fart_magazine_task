import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fart_magazine/widgets/restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantItem {
  final String id;
  final String title;
  final LatLng location;

  RestaurantItem({
    @required this.id,
    @required this.title,
    @required this.location,
  });
}

class Restaurants with ChangeNotifier {
  String search;
  List<RestaurantItem> _restaurantAll = [];
  List<RestaurantItem> _restaurantNearby = [];

  List<RestaurantItem> get restaurants {
    return [..._restaurantNearby];
  }

  List<RestaurantItem> get searchedProducts {
    return _restaurantAll.where((restaurant) {
      return restaurant.title.toLowerCase().contains(this.search.toLowerCase());
    }).toList();
  }

  Future<void> fetchRestaurants(Position currentLocation) async {
    final List<RestaurantItem> loadedNearbyRestaurants = [];
    final List<RestaurantItem> loadedAllRestaurants = [];

    await FirebaseFirestore.instance
        .collection('restaurants')
        .get()
        .then((data) async {
      if (data.docs.isNotEmpty) {
        for (int i = 0; i < data.docs.length; i++) {
          loadedAllRestaurants.add(
            RestaurantItem(
              id: data.docs[i].id,
              title: data.docs[i].data()['title'],
              location: LatLng(
                data.docs[i].data()['location'].latitude,
                data.docs[i].data()['location'].longitude,
              ),
            ),
          );
          var distance = Geolocator.distanceBetween(
            currentLocation.latitude,
            currentLocation.longitude,
            data.docs[i].data()['location'].latitude,
            data.docs[i].data()['location'].longitude,
          );
          print(distance);
          if (distance / 1000 < 200) {
            loadedNearbyRestaurants.add(
              RestaurantItem(
                id: data.docs[i].id,
                title: data.docs[i].data()['title'],
                location: LatLng(
                  data.docs[i].data()['location'].latitude,
                  data.docs[i].data()['location'].longitude,
                ),
              ),
            );
          }
        }
      }
    });
    _restaurantAll = loadedAllRestaurants;
    _restaurantNearby = loadedNearbyRestaurants;
    notifyListeners();
  }
}
