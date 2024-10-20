import 'package:flutter/material.dart';

//Importaciones Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ui_flutter/config/router/app_router.dart';
import 'package:ui_flutter/config/theme/app_theme.dart';
import 'package:ui_flutter/infrastructure/datasources/firebase_datasource.dart';
import 'package:ui_flutter/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:ui_flutter/presentation/screens/providers/crud_provider.dart';
import 'firebase_options.dart';

void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();//*asegura que el entorno de Flutter este correctamente configurado
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final localStorageRepositoryImpl = LocalStorageRepositoryImpl(datasource: FirebaseDatasource());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CrudProvider(localStorageRepository: localStorageRepositoryImpl)
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        //home: HomeScreen(),
        routerConfig: approuter,
      ),
    );
  }
}

