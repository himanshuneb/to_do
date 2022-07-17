import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/tasks.dart';
import './providers/subtasks.dart';

import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/home_screen.dart';
import './screens/edit_task_screen.dart';
import './screens/edit_subtask_screen.dart';
import './screens/task_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Tasks>(
            create: (ctx) => Tasks('', '', []),
            update: (ctx, auth, previousTasks) => Tasks(auth.token, auth.userId,
                previousTasks == null ? [] : previousTasks.items),
          ),
          ChangeNotifierProxyProvider<Auth, Subtasks>(
            create: (ctx) => Subtasks('', '', []),
            update: (ctx, auth, previousTasks) => Subtasks(auth.token,
                auth.userId, previousTasks == null ? [] : previousTasks.items),
          ),
        ],
        // this ensures that the MaterialApp is rebuilt whenever Auth changes
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'Tasks',
              theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.amber,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? HomeScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                // ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                // CartScreen.routeName: (ctx) => CartScreen(),
                // OrdersScreen.routeName: (ctx) => OrdersScreen(),
                // UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditTaskScreen.routeName: (ctx) => EditTaskScreen(),
                EditSubtaskScreen.routeName: (ctx) => EditSubtaskScreen(),
                TScreen.routeName: (ctx) => TScreen(),
              }),
        ));
  }
}
