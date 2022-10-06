
import 'package:be_nice/utils/query.dart';
import 'package:flutter/material.dart';

import 'Cart.dart';
import 'Favorites.dart';
import 'Home.dart';
import 'Pay.dart';
import 'Products.dart';

var prodDetail = {};

class Details extends StatefulWidget{
  const Details ({Key? key,this.id}) : super(key: key);
  final int? id;

  @override
  DetailsState createState()=> DetailsState();

}

class DetailsState extends State<Details>{

  bool preload =true;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    detailsList(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
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
      body:preload? const Center(child:CircularProgressIndicator()) : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Align(
              alignment: Alignment.center,
              child:SizedBox(
                width:150,
                height:150,
                child: Image.network(prodDetail['image'],
                  loadingBuilder: (context, child, progress){
                    return progress == null ? child : const CircularProgressIndicator();
                  },
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Text(prodDetail['title'],style: const TextStyle(color: Colors.black87,fontSize: 20,)),
            Text("Price:${prodDetail['price']} HTG",style: const TextStyle(color: Colors.redAccent,fontSize: 18,)),
            const SizedBox(height: 20,),
            const Text("Description",style: TextStyle(decoration: TextDecoration.underline,fontSize: 20),),
            const SizedBox(height: 5,),
            Text(prodDetail["description"],style:const TextStyle(fontSize: 16),textAlign: TextAlign.justify,),
            const SizedBox(height: 20,),
            Text("Rate: ${prodDetail['rating']['rate']}",style:const TextStyle(fontSize: 20)),
            Text("Quantity: ${prodDetail['rating']['count']}",style:const TextStyle(fontSize: 20)),
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

  void detailsList(id) async {
    var response = await Query.fetch(url: "https://fakestoreapi.com/products/$id");
    if(response != null){
      setState((){
        prodDetail = response;
      });
    }

    setState(() {
      preload=false;
    });
  }
}