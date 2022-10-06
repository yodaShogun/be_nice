
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/query.dart';
import '../utils/storage.dart';
import 'Cart.dart';
import 'Details.dart';
import 'Favorites.dart';
import 'Home.dart';
import 'Pay.dart';

var gridProd = [];

class Products extends StatefulWidget{
  const Products({Key? key,this.filter}) : super(key: key);
  final String? filter;
  @override
  ProdState createState()=> ProdState();

}

class ProdState  extends State<Products>{

  bool preload = true;

  var cartMap = [];
  var favMap = [];

  final StorageService cartStorage = StorageService();
  final StorageService favStorage = StorageService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listingProducts(widget.filter);
    getCart();
    getFavs();
  }

  void getCart() async {
    var res = await cartStorage.read('cart');
    if(res != null){
      setState((){
        cartMap = json.decode(res);
      });
    }
  }

  void getFavs() async{
    var res = await favStorage.read('fav');
    if(res!=null){
      setState(() {
        favMap = json.decode(res);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          ElevatedButton.icon(
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx)=>const Pay()
                    ));
              },
              icon: const Icon(Icons.paid),
              label:  const Text("Pay"))
        ],
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
      body: preload? const Center(child:CircularProgressIndicator()) :SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              primary: false,
              shrinkWrap: true,
              itemCount: gridProd.length,
              itemBuilder:  (BuildContext ctx, index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => Details(id: gridProd[index]['id'],))
                        );
                      },
                      child:Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child : SizedBox(
                                width:90,
                                height: 90,
                                child: Image.network(
                                  gridProd[index]['image'],
                                  loadingBuilder: (context, child, progress){
                                    return progress == null ? child : const CircularProgressIndicator();
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(gridProd[index]["title"],style:GoogleFonts.roboto(
                                  textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic) ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      if(cartMap.contains(gridProd[index])){
                                        setState(() {
                                          cartMap.removeWhere((id) => id == gridProd[index]);
                                        });
                                      }
                                      else{
                                        setState(() {
                                          cartMap.add(gridProd[index]);
                                        });
                                      }
                                      cartStorage.write('cart', json.encode(cartMap));
                                    }  ,
                                    style:ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(cartMap.contains(gridProd[index]) ? Colors.greenAccent : Colors.white)
                                    ),
                                    child: const Icon(Icons.shopping_cart)
                                ),
                                const SizedBox(width: 4.0,),
                                ElevatedButton(onPressed: (){
                                  if(favMap.contains(gridProd[index])){
                                    setState(() {
                                      favMap.removeWhere((id) => id == gridProd[index]);
                                    });
                                  }
                                  else{
                                    setState(() {
                                      favMap.add(gridProd[index]);
                                    });
                                  }
                                  favStorage.write('cart', json.encode(favMap));
                                },
                                style:ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(favMap.contains(gridProd[index]) ? Colors.redAccent : Colors.white)
                                    ),
                                    child: const Icon(Icons.favorite))
                              ],
                            )
                          ],
                        ),
                      ) ,
                    ),
                  ],
                );
              }
          ),
        ),
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
  void listingProducts(filter) async {
    if(filter == null){
      var response = await Query.fetch( url: 'https://fakestoreapi.com/products');
      if(response!=null){
        setState(() {
          gridProd = response;
        });
      }
    }else{
      var response = await Query.fetch( url: "https://fakestoreapi.com/products/category/$filter");
      if(response!=null){
        setState(() {
          gridProd = response;
        });
      }
    }
    setState(() {
      preload = false;
    });
  }


}