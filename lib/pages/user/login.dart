import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:otaku_movie/pages/movie/confirmOrder.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedLanguage = 'en';

  final Map<String, String> languages = {
    'en': 'English',
    'zh': '简体中文',
    'ja': '日本語',
  };

  void switchLanguage(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
      Intl.defaultLocale = languageCode;
    });
  }

  void handleEmailPasswordLogin() {
    context.goNamed('home');

    return;
    
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).error),
          content: Text(AppLocalizations.of(context).emptyFields),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).ok),
            ),
          ],
        ),
      );
    } else {
      print("Login with Email: $email, Password: $password");
    }
  }

  void handleGoogleLogin() {
    print("Google login clicked");
  }

  void handleLineLogin() {
    print("Line login clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/image/kimetsu-movie.jpg', height: 30), // 这里可以替换为你的 logo 路径
            SizedBox(width: 10),
            Text(AppLocalizations.of(context).loginTitle),
          ],
        ),
        actions: [
          DropdownButton<String>(
            value: selectedLanguage,
            items: languages.entries
                .map((entry) => DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                switchLanguage(value);
              }
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // 点击页面空白处，隐藏键盘
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView( // 使用 SingleChildScrollView 包裹
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40), // 增加顶部间距，避免和顶部按钮重叠
                Center(
                  child: Image.asset(
                    'assets/image/kimetsu-movie.jpg', // logo 图片路径
                    height: 120, // logo 大小
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).email,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).password,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: handleEmailPasswordLogin,
                  child: Text(AppLocalizations.of(context).login),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 圆角按钮
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(AppLocalizations.of(context).or),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: handleGoogleLogin,
                  icon: Icon(Icons.login),
                  label: Text(AppLocalizations.of(context).loginWithGoogle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: handleLineLogin,
                  icon: Icon(Icons.message),
                  label: Text(AppLocalizations.of(context).loginWithLine),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).noAccount),
                    TextButton(
                      onPressed: () {
                        context.goNamed('register');
                      },
                      child: Text(AppLocalizations.of(context).register),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Localization Helper
class AppLocalizations {
  final BuildContext context;

  AppLocalizations(this.context);

  static AppLocalizations of(BuildContext context) => AppLocalizations(context);

  String get loginTitle => Intl.message('Login', name: 'loginTitle');
  String get email => Intl.message('Email', name: 'email');
  String get password => Intl.message('Password', name: 'password');
  String get login => Intl.message('Login', name: 'login');
  String get or => Intl.message('OR', name: 'or');
  String get loginWithGoogle =>
      Intl.message('Login with Google', name: 'loginWithGoogle');
  String get loginWithLine =>
      Intl.message('Login with Line', name: 'loginWithLine');
  String get error => Intl.message('Error', name: 'error');
  String get emptyFields =>
      Intl.message('Email and password cannot be empty!', name: 'emptyFields');
  String get ok => Intl.message('OK', name: 'ok');
  String get noAccount => Intl.message('Don\'t have an account?', name: 'noAccount');
  String get register => Intl.message('Register', name: 'register');
}
