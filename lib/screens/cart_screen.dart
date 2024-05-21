import 'package:flutter/material.dart';
import 'package:game_sphere_bd/screens/payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late int quantity; // Declare quantity as a state variable
  List<String> cartItems = ['Garena Shell'];

  @override
  void initState() {
    super.initState();
    quantity = 1; // Initialize quantity in initState
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int price = 1920;
    int total = (price * quantity);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        iconTheme: const IconThemeData(
            color: Colors.white), // Add this line to change the icon color
      ),
      body: ListView.builder(
        itemCount: cartItems
            .length, // Replace with the actual number of items in the cart
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: Key(cartItems[index]),
            onDismissed: (direction) {
              removeFromCart(index); // Remove item from the cart
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://image.offgamers.com/infolink/2023/05/garena-tw.jpg'),
                ),
              ),
              title: Text('Garena Shell'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //add a text here to display variant
                  const Text('Variant: 1300'),
                  Row(
                    children: [
                      const Text('Price: 1920 ৳'),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            // Decrease the quantity count
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text('$quantity'), // Display the quantity count
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            // Increase the quantity count
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    total = 0; // Set total to 0 within setState
                    removeFromCart(index); // Remove the item from the cart
                  });
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF62BDBD),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: $total BDT', // Calculate total price
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaymentScreen(totalAmount: total)),
                  );
                },
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
