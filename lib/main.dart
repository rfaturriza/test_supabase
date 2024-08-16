import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'go_router.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://eimunisasi-base-staging.peltops.com',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzIzNDEzNjAwLAogICJleHAiOiAxODgxMTgwMDAwCn0.LP3Zca0w11eNX1974BpPg0GWShJysP6jw9732kL-Y9c',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
