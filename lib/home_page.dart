import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  List<Map<String, dynamic>> todos = [];

  void fetchTodos() async {
    final response = await supabase.from('todos').select();
    setState(() {
      todos = response;
    });
  }

  @override
  void initState() {
    super.initState();
    final session = supabase.auth.currentSession;
    final at = session?.accessToken;
    final decoded = JwtDecoder.decode(at!);
    debugPrint(decoded.toString());
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                setState(() {
                  isLoading = true;
                });
                await supabase.auth.signOut();
                GoRouter.of(context).pushReplacement('/login');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: $e"),
                  ),
                );
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('Logout'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // show todos
            if (todos.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(todo['task']),
                      // delete button
                      leading: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await supabase
                                .from('todos')
                                .delete()
                                .eq('id', todo['id']);
                            setState(() {
                              todos.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${todo['task'].toString()} deleted'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: $e"),
                              ),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      trailing: Checkbox(
                        value: todo['is_completed'],
                        onChanged: (value) async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await supabase.from('todos').update(
                              {'is_completed': value},
                            ).eq('id', todo['id']);
                            setState(() {
                              todos[index]['is_completed'] = value;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${todo['task'].toString()} updated'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: $e"),
                              ),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final time = DateTime.now().millisecondsSinceEpoch;
          try {
            setState(() {
              isLoading = true;
            });
            await supabase.from('todos').insert(
              {'task': 'Buy milk $time', 'is_completed': false},
            );
            fetchTodos();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Todo inserted"),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: $e"),
              ),
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
