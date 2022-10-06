
import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/storage.dart';
import 'Cart.dart';
import 'Home.dart';
import 'Products.dart';

class Favorites extends StatefulWidget{
  const Favorites({Key? key}) : super(key: key);

  @override
  FavState createState()=> FavState();

}

class FavState extends State<Favorites>{

  final StorageService favStorage = StorageService();
  bool loading = true;
  var getFav = [];

  void readFav() async {
    var res = await favStorage.read('fav');
    if(res != null){
      setState((){
        getFav = json.decode(res);
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    readFav();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // m retire espas anndan yo.
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const  Home(title: 'Home')));
              },
            ),
            ListTile(
              title: const Text("Favorites"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>const Favorites()));
              },
            ),
            ListTile(
              title: const Text('Products'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const Products()));
              },
            ),
            ListTile(
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const Cart(title: 'Cart',)));
              },
            ),
          ],
        ),
      ),
      body: loading ? const Center(child:CircularProgressIndicator()) : ListView.builder(
          itemCount: getFav.length,
          itemBuilder: (BuildContext context, index){
            return ListTile(
              leading: const Icon(Icons.list),
              trailing: Text("${getFav[index]['price']} HTG"),
              title: Text(getFav[index]['title']),
            );
          }
      ),
    );
  }
}