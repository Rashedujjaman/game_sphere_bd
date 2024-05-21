import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> contactInfo = [
    {
      'icon': Icons.phone,
      'text': '+8801792838443',
      'action': 'tel:+8801792838443', // Action for making a phone call
    },
    {
      'icon': Icons.email,
      'text': 'info@gamespherebd.com',
      'action': 'mailto:info@gamespherebd.com', // Action for sending an email
    },
    {
      'icon': Icons.location_on,
      'text': 'Kurigram - 5400, Rangpur, Bangladesh',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF62BDBD),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Our Company',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'GameSphere BD is a gaming platform that provides a wide range'
              ' of gaming items for Bangladeshi Gamers with a variety of payment'
              ' methods support that allow gamers to buy their desired items'
              ' seamlessly without thinking of foreign currency payment hassle.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 50),
            ListView(
              shrinkWrap: true,
              children: contactInfo.map((info) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(info['icon']),
                      title: Text(info['text']),
                      onTap: () async {
                        if (info['icon'] == Icons.phone) {
                          final phoneNumber = 'tel:${info['text']}';
                          if (await canLaunch(phoneNumber)) {
                            await launch(phoneNumber);
                          } else {
                            throw 'Could not launch $phoneNumber';
                          }
                        } else if (info['icon'] == Icons.email) {
                          final emailAddress = 'mailto:${info['text']}';
                          if (await canLaunch(emailAddress)) {
                            await launch(emailAddress);
                          } else {
                            throw 'Could not launch $emailAddress';
                          }
                        }
                      },
                    ));
              }).toList(),
            ),
            const SizedBox(height: 100),
            const Center(
              child: Text(
                '©Reserved by GameSphere BD',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
