import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_supabase/error_page.dart';
import 'package:test_supabase/home_page.dart';
import 'package:test_supabase/login_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        // show toast if there is an error
        final error = state.uri.queryParameters['error'];
        final errorCode = state.uri.queryParameters['error_code'];
        final errorDescription = state.uri.queryParameters['error_description'];

        if (error != null && errorCode != null && errorDescription != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ListTile(
                  textColor: Colors.white,
                  title: Text(error.toUpperCase()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code: $errorCode'),
                      Text(errorDescription),
                    ],
                  ),
                ),
              ),
            );
          });
        }
        return const LoginPage();
      },
      routes: [
        // login
        GoRoute(
          path: 'login',
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: 'home',
          builder: (_, __) => const MyHomePage(title: 'Home'),
        ),
        GoRoute(
          path: 'error',
          builder: (context, state) {
            final error = state.uri.queryParameters['error'] ?? 'Unknown error';
            final errorCode =
                state.uri.queryParameters['error_code'] ?? 'Unknown error code';
            final errorDescription =
                state.uri.queryParameters['error_description'] ??
                    'Unknown error description';

            return ErrorPage(
              error: error,
              errorCode: errorCode,
              errorDescription: errorDescription,
            );
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorPage(
    error: 'Navigation error',
    errorCode: '404',
    errorDescription: 'The requested page was not found',
  ),
);
