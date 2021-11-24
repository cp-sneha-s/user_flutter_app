import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:user_app/user.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<User>> fetchUserData;
  List<User> userList = [];
  RefreshController controller = RefreshController();

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchUserData = fetchData(http.Client());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter user app',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('User list'),
          backgroundColor: Colors.blueGrey,
        ),
        body: FutureBuilder<List<User>>(
            future: fetchUserData,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              print(snapshot.hasData);
              if (snapshot.hasData) {
                var list = snapshot.data;
                userList = list;
//Pull to refresh functionality by RefreshIndicator:
                // RefreshIndicator(
                //   onRefresh: ()async {
                //     setState(() {
                //      fetchUserData= fetchData();
                //     });
                //     },
                return SmartRefresher(
                  controller: controller,
                  onRefresh: () {
                    setState(() {
                      Future.delayed(Duration(seconds: 4));
                      fetchUserData = fetchData(http.Client());
                      controller.refreshCompleted();
                    });
                  },
                  child: ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        var user = userList[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Material(
                            color: Colors.blueGrey,
                            child: InkWell(
                              splashColor: Colors.white,
                              onLongPress: () {
                                setState(() {
                                  userList.removeAt(index);
                                });
                                const snackbar = SnackBar(
                                    elevation: 5.0,
                                    content: Text('User data deleted!!'));
                                Scaffold.of(context).showSnackBar(snackbar);

                                print('user longpressed');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 100,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Name:' + user.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'City:' + user.city,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'Email:' + user.email,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                print(snapshot.hasError);
                return Text('${snapshot.error} ');
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

Future<List<User>> fetchData(http.Client client) async {
  final response =
      await client.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    print(data.toString());
    List<User> users = data.map((e) => User.fromJson(e)).toList();
    print('list of users :' + users.toString());
    return users;
  } else {
    throw Exception('Failed to load data');
  }
}
