import 'package:url_launcher/url_launcher.dart';

/// Membuka telepon, WhatsApp, dan peta.
class ContactService {
  ContactService._();

  static String _digits(String phone) => phone.replaceAll(RegExp(r'[^0-9]'), '');

  static Future<bool> call(String phone) async {
    final uri = Uri(scheme: 'tel', path: _digits(phone));
    try {
      return await launchUrl(uri);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> whatsapp(String phone, {String message = ''}) async {
    var d = _digits(phone);
    if (d.startsWith('0')) d = '62${d.substring(1)}';
    final uri = Uri.parse('https://wa.me/$d${message.isEmpty ? '' : '?text=${Uri.encodeComponent(message)}'}');
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openMap(String address) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
