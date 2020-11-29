import 'package:fart_magazine/providers/restaurants.dart' show Restaurants;
import 'package:fart_magazine/screens/search_screen.dart';
import 'package:fart_magazine/widgets/restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position currentLocation;
  var _isLoading = false;

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission =
        await Permission.locationWhenInUse.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.locationWhenInUse].request();
      return permissionStatus[Permission.locationWhenInUse] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future<Position> locateUser() async {
    return await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getUserLocation() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      currentLocation = await locateUser();
//      setState(() {
//        _center = LatLng(currentLocation.latitude, currentLocation.longitude);
//      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    getUserLocation().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: Provider.of<Restaurants>(context, listen: false)
                  .fetchRestaurants(currentLocation),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    print(dataSnapshot.error.toString());
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<Restaurants>(
                      builder: (ctx, restaurantData, child) => ListView.builder(
                        itemCount: restaurantData.restaurants.length,
                        itemBuilder: (ctx, i) =>
                            RestaurantItem(restaurantData.restaurants[i]),
                      ),
                    );
                  }
                }
              },
            ),
    );
  }
}
