
import 'dart:convert';

import 'package:be_nice/screens/Favorites.dart';
import 'package:be_nice/screens/Pay.dart';
import 'package:be_nice/utils/storage.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import 'Products.dart';

class Cart extends StatefulWidget{
  const Cart({Key? key,required this.title}) : super(key: key);

  final String title;
  @override
  CartState createState()=> CartState();

}

class CartState extends State<Cart>{

  bool loading = true;
  var getCart =[];

  final StorageService cartStorage = StorageService();

  void readCart() async {
    var res = await cartStorage.read('cart');
    if(res != null){
      setState((){
        getCart = json.decode(res);
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCart();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
          actions: [
            ElevatedButton.icon(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx)=>const Pay()
                      ));
                },
                icon: const Icon(Icons.paid),
                label: Text("Pay"))
          ]
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
                    MaterialPageRoute(builder: (ctx) => const Home(title: 'Home')));
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
      body: loading? const Center(child:CircularProgressIndicator()) : ListView.builder(
        itemCount: getCart.length,
          itemBuilder: (BuildContext context, index){
            return ListTile(
              leading: const Icon(Icons.list),
              trailing: Text("${getCart[index]['price']} HTG"),
              title: Text(getCart[index]['title']),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          child: const  Text('Pay'),
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (ctx)=>const Pay()
            ));
          }
      ),
    );
  }
}