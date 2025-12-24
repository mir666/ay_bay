import 'package:ay_bay/features/auth/ui/screens/forget_password_screen.dart';
import 'package:ay_bay/features/auth/ui/screens/log_in_screen.dart';
import 'package:ay_bay/features/auth/ui/screens/sigh_up_screen.dart';
import 'package:ay_bay/features/auth/ui/screens/splash_screen.dart';
import 'package:ay_bay/features/home/ui/screens/add_month_screen.dart';
import 'package:ay_bay/features/home/ui/screens/add_transaction_screen.dart';
import 'package:ay_bay/features/home/ui/screens/home_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forget = '/forget';
  static const home = '/home';
  static const addTransaction = '/add-transaction';
  static const initialBalance = '/add-initialBalance';
  static const addMonth = '/add-month';

  static final pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LogInScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
    GetPage(name: forget, page: () => ForgetPasswordScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: addTransaction, page: () => AddTransactionScreen()),
    GetPage(name: addMonth, page: () => AddMonthScreen()),
  ];
}
