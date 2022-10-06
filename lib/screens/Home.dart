
  import 'dart:convert';
  import 'dart:core';
  import 'package:be_nice/utils/query.dart';
  import 'package:be_nice/utils/storage.dart';
  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';

  import 'Cart.dart';
  import 'Details.dart';
  import 'Favorites.dart';
import 'Pay.dart';
import 'Products.dart';

  List<dynamic> catList = [];
  var mapProd = [];
  class Home extends StatefulWidget{

    const Home({Key?key, required this.title,}):super(key:key);

    final String title;

    @override
    HomeState createState()=> HomeState();

  }

  class HomeState extends State<Home>{

    final StorageService cartStorage = StorageService();
    final StorageService favStorage = StorageService();

    var cartMap = [];
    var favMap = [];

    @override
    void initState() {
      super.initState();
      homeCategories();
      homeProds();
      getCart();
      getFavs();
    }

    void getCart() async {
      var res = await cartStorage.read('cart');
      if(res != null){
        setState((){
          cartMap = json.decode(res).cast<Map>();
        });
      }
    }

    void getFavs() async{
      var res = await favStorage.read('fav');
      if(res!=null){
        setState(() {
          favMap = json.decode(res).cast<Map>();
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
        body: Column(
          children: [
            SizedBox(
              width: 300,
              height: 180,
              child: ListView.builder(
                  itemCount: catList.length,
                  itemBuilder: (context,index){
                    return Card(
                      color: const Color(0x00c4ffff),
                      child: ListTile(
                        title: Center(child: Text(catList[index],style: GoogleFonts.roboto(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic),
                        ),
                        ),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => Products(filter: catList[index],))
                          );
                        },
                      )
                    );
                  }
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                      primary: false,
                      shrinkWrap: true,
                  itemCount: mapProd.length,
                  itemBuilder:  (BuildContext ctx, index){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => Details(id: mapProd[index]['id'],))
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
                                      mapProd[index]['image'],
                                      loadingBuilder: (context, child, progress){
                                        return progress == null ? child : const CircularProgressIndicator();
                                      },
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(mapProd[index]["title"],style:GoogleFonts.roboto(
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
                                          if(cartMap.contains(mapProd[index])){
                                            setState(() {
                                              cartMap.removeWhere((id) => id == mapProd[index]);
                                            });
                                          }
                                          else{
                                            setState(() {
                                              cartMap.add(mapProd[index]);
                                            });
                                          }


                                          cartStorage.write('cart', json.encode(cartMap));
                                        },
                                        style:ButtonStyle(
                                            foregroundColor: MaterialStateProperty.all<Color>(cartMap.contains(mapProd[index]) ? Colors.greenAccent : Colors.white)
                                        ),
                                        child: const Icon(Icons.shopping_cart)
                                    ),
                                    const SizedBox(width: 4.0,),
                                    ElevatedButton(
                                        onPressed: (){
                                              if(favMap.contains(mapProd[index])){
                                                  setState(() {
                                                    favMap.removeWhere((id) => id == mapProd[index]);
                                                  });
                                            } else{
                                              setState(() {
                                                  favMap.add(mapProd[index]);
                                              });
                                          }
                                          favStorage.write('fav', json.encode(favMap));
                                        },
                                      style:ButtonStyle(
                                              foregroundColor: MaterialStateProperty.all<Color>(favMap.contains(mapProd[index]) ? Colors.redAccent : Colors.white)
                                      ),
                                    child: const Icon(Icons.favorite)
                                    )
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
            )
          ],
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

    void homeCategories() async{
      var response = await Query.fetch(url: "https://fakestoreapi.com/products/categories");
      if(response!=null){
        setState(() {
         catList = response;
         if(catList.length > 4){
           catList = catList.sublist(0,4);
         }
        });
      }
    }

    void homeProds() async{
      var response = await Query.fetch(url: 'https://fakestoreapi.com/products?limit=6');
      if(response!=null){
        setState(() {
          mapProd = response;
        });
      }
    }

  }
