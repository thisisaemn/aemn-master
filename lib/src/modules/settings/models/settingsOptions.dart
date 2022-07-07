import 'package:aemn/src/modules/settings/settings.dart';

class SettingsOptions{
  const SettingsOptions();

  static   List<Map<String, Object>> settingsOptions = [
    {
      'key' : 'faq',
      'icon': 57986,
      'action': '',
    },
    {
      'key' : 'invite a friend',
      'icon': 58386,
      'action': '',
    },
    {
      'key' : 'privacy policy',
      'icon': 0xe846,
      'action': '',
    },
    {
      'key' : 'user agreement',
      'icon': 58530,
      'action': '',
    },
    {
      'key' : 'imprint',
      'icon': 58340,
      'action': '',
    },
    {
      'key' : 'change password',
      'icon': 59210,
      'action': '',
    },
    {
      'key' : 'logout',
      'icon': 59464,
      'action': '',
    },
    {
      'key' : 'import profile data',
      'icon': 57986,
      'action': '',
    },
  ];

  static List<Map<String, Object>> get getSettingsOptions {
    return settingsOptions;
  }
}