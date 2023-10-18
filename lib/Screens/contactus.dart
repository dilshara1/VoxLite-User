
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../colors.dart';

class contactus extends StatefulWidget {
  const contactus({Key? key});

  @override
  _contactusState createState() => _contactusState();
}

class _contactusState extends State<contactus> {
  Future<void>? _launched;

  final String _address =
      'Located in: Sri Lanka Telecom Regional Office Avissawella\nAddress: Colombo Road, Avissawella\n';
  bool _hasCallSupport = false;
  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Widget build(BuildContext context) {
    final Uri toLaunchweb = Uri(
      scheme: 'https',
      host: 'www.movieworks.lk',
    );

    final Uri toLaunchfb =
        Uri(scheme: 'https', host: 'www.facebook.com', path: 'litecinemas.lk');

    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    Future<void> _launchUrl(Uri) async {
      if (!await canLaunchUrl(Uri)) {
        await launchUrl(Uri);
        throw Exception('Could not launch $Uri');
      }
    }

    String _phone = '0704732115';

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@litecinemas.lk',
      query: encodeQueryParameters(<String, String>{
        'subject': '',
      }),
    );
    Future<void> _makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: _phone,
      );
      await launchUrl(launchUri);
    }

    Future<void> _launchInBrowser(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
      backgroundColor: kc1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Location',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: kc3,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kc3,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/dafault-background.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: kc1.withOpacity(0.7),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40 * fem),
                Container(
                  width: 269 * fem,
                  height: 210 * fem,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/main/images/hallimage.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 40 * fem),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook, color: kc3),
                      onPressed: () => setState(() {
                        _launched = _launchInBrowser(toLaunchfb);
                      }),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.language,
                        color: kc3,
                      ),
                      onPressed: () => setState(() {
                        _launched = _launchInBrowser(toLaunchweb);
                      }),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.call,
                        color: kc3,
                      ),
                      onPressed: () => _makePhoneCall('tel:$_phone'),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.email,
                        color: kc3,
                      ),
                      onPressed: () => _launchUrl(emailLaunchUri),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _address,
                      style: const TextStyle(fontSize: 18, color: kc3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


