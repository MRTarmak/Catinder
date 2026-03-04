import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingKey = 'onboarding_completed';

Future<bool> isOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingKey) ?? false;
}

Future<void> markOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingKey, true);
}
