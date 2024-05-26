import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount; // Pass the total amount from CartScreen

  PaymentScreen({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        iconTheme: const IconThemeData(
            color: Colors.white), // Add this line to change the icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Order Details', // Display item details
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://image.offgamers.com/infolink/2023/05/garena-tw.jpg'),
              ),
              title: const Text('Garena Shell'),
              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Variant: 1300'),
                  Text('Price: 1920 ৳'),
                ],
              ),
              trailing: Text(
                'Total: $totalAmount BDT',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: DropdownButton<String>(
                hint: const Text('Select a payment method'),
                items: const [
                  DropdownMenuItem(
                    value: 'Bkash',
                    child: Text('Bkash'),
                  ),
                  DropdownMenuItem(
                    value: 'Nagad',
                    child: Text('Nagad'),
                  ),
                  DropdownMenuItem(
                    value: 'Credit/Debit Card',
                    child: Text('Credit/Debit Card'),
                  ),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    _processPayment(value);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF62BDBD),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20), // Add padding to make the button larger
                  ),
                  onPressed: () {
                    // Implement submit logic here
                    _submitOrder();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(String method) {
    print('Selected payment method: $method');
    // Implement payment logic
  }

  void _submitOrder() {
    // Implement submit order logic
    print('Order submitted!');
  }
}
