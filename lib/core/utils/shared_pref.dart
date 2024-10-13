import 'package:shared_preferences/shared_preferences.dart';

import '../../global/global.dart';
import 'logs.dart';


class CacheUtils{

  static Future<void> saveUserRoleToCache(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role.toLowerCase());
  }

  static Future<UserRole?> getUserRoleFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('user_role') ?? '';

    if(role.toLowerCase() == 'admin'){
      DevLogs.logInfo(role);
      return UserRole.staff;
    }else if(role.toLowerCase() == 'user'){
      DevLogs.logInfo(role);
      return UserRole.customer;
    }

    return null;
  }

  static Future<void> clearUserRoleFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
  }


}