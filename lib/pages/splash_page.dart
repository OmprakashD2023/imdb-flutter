import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/services/http_service.dart';

import '../models/app_config.dart';
import '../services/movie_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({Key? key, required this.onInitializationComplete})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then(
      (_) => setup(context).then(
        (_) => widget.onInitializationComplete(),
      ),
    );
  }

  Future<void> setup(BuildContext context) async {
    final getIt = GetIt.instance;

    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);

    getIt.registerSingleton<AppConfig>(
      AppConfig(
          API_KEY: configData["API_KEY"],
          BASE_URL: configData["BASE_URL"],
          BASE_IMAGE_API_URL: configData["BASE_IMAGE_API_URL"]),
    );

    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );

    getIt.registerSingleton<MovieService>(
      MovieService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "IMDB",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/logo-1.png'),
            ),
          ),
        ),
      ),
    );
  }
}
