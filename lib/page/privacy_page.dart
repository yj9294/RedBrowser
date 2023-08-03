import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  final PageType type;
  const PrivacyPage(this.type, {super.key});
  @override
  State<StatefulWidget> createState() {
    return _PrivacyPageState(type);
  }
}
class _PrivacyPageState extends State<PrivacyPage> {
  PageType type;
  _PrivacyPageState(this.type);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(type.body)
        ],
      ),
    );
  }
}

enum PageType {
  privacy, terms
}

extension PageTypeExtension on PageType {
  String get title {
    switch (this) {
      case PageType.privacy:
        return "Privacy Policy";
      case PageType.terms:
        return "Terms of Users";
    }
  }

  String get body {
    switch (this) {
      case PageType.privacy:
        return """
        The following terms and conditions (the “Terms”) govern your use of the VPN services we provide (the “Service”) and their associated website domains (the “Site”). These Terms constitute a legally binding agreement (the “Agreement”) between you and Tap VPN. (the “Tap VPN”).

Activation of your account constitutes your agreement to be bound by the Terms and a representation that you are at least eighteen (18) years of age, and that the registration information you have provided is accurate and complete.

Tap VPN may update the Terms from time to time without notice. Any changes in the Terms will be incorporated into a revised Agreement that we will post on the Site. Unless otherwise specified, such changes shall be effective when they are posted. If we make material changes to these Terms, we will aim to notify you via email or when you log in at our Site.

By using Tap VPN
You agree to comply with all applicable laws and regulations in connection with your use of this service.regulations in connection with your use of this service.
 """;
      case PageType.terms:
        return """
        The following terms and conditions (the “Terms”) govern your use of the VPN services we provide (the “Service”) and their associated website domains (the “Site”). These Terms constitute a legally binding agreement (the “Agreement”) between you and Tap VPN. (the “Tap VPN”).

Activation of your account constitutes your agreement to be bound by the Terms and a representation that you are at least eighteen (18) years of age, and that the registration information you have provided is accurate and complete.

Tap VPN may update the Terms from time to time without notice. Any changes in the Terms will be incorporated into a revised Agreement that we will post on the Site. Unless otherwise specified, such changes shall be effective when they are posted. If we make material changes to these Terms, we will aim to notify you via email or when you log in at our Site.

By using Tap VPN
You agree to comply with all applicable laws and regulations in connection with your use of this service.regulations in connection with your use of this service.
        """;
    }
  }
}