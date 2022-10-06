import 'package:flutter/material.dart';

class Pay extends StatefulWidget{
  const Pay({Key? key}) : super(key: key);

  @override
  PayState createState()=>PayState();
}



class PayState extends State<Pay>{

  int paymentMethod = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState((){
                    paymentMethod = value as int;
                  });
                },
              ),
              const Text("MonCash")
            ],
          ),
          Row(
            children: [
              Radio(
                value: 2,
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState((){
                    paymentMethod = value as int;
                  });
                },
              ),
              const Text("MasterCard")
            ],
          ),
          Row(
            children: [
              Radio(
                value: 3,
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState((){
                    paymentMethod = value as int;
                  });
                },
              ),
              const Text("Paypal")
            ],
          ),
        ],
      ),
    );
  }

}