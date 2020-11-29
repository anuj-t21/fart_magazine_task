import 'package:fart_magazine/widgets/restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurants.dart' show Restaurants;

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String search;
  var _doSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What are you looking for?'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 5,
            //width: MediaQuery.of(context).size.width * 0.9,
            //child: Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search FM',
                icon: Icon(Icons.search),
              ),
              onChanged: (value) {
                Provider.of<Restaurants>(context, listen: false).search = value;
                setState(() {
                  _doSearch = true;
                });
              },
            ),
          ),
          _doSearch
              ? Consumer<Restaurants>(
                  builder: (ctx, restaurantData, child) => Container(
                    height: (MediaQuery.of(context).size.height) -
                        MediaQuery.of(context).viewInsets.bottom -
                        160,
                    child: ListView.builder(
                      itemCount: restaurantData.searchedProducts.length,
                      itemBuilder: (ctx, i) =>
                          RestaurantItem(restaurantData.searchedProducts[i]),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'Happy to serve!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
        ],
      ),
    );
  }
}
