import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as htpp;
import 'package:smol_crudcliente_gustavosoares/screens/register.dart';
import 'package:smol_crudcliente_gustavosoares/screens/update.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List> futureUsers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureUsers = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
                width: 70,
                child: SvgPicture.asset('asset/svg/logo.svg'),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Lista de cliente'))
            ],
          ),
          backgroundColor: Colors.green,
        ),
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registrer(),
                  fullscreenDialog: true,
                ));
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 80.0, left: 10, right: 10),
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.black12))),
                        child: ListTile(
                          title: Text(snapshot.data![index]['nome']),
                          subtitle: Row(
                            children: [
                              Text('email: '),
                              Text(snapshot.data![index]['email']),
                              Text(' /Telefone: '),
                              Text(snapshot.data![index]['telefone'])
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              deleteUser(user: snapshot.data![index]);
                            },
                            icon: Icon(Icons.clear),
                            color: Colors.redAccent,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Update(
                                    user: snapshot.data![index],
                                  ),
                                  fullscreenDialog: true,
                                ));
                          },
                        ),
                      );
                    }),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Future<List> fetchUser() async {
    var url = Uri.parse(
        'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/');
    var reponse = await htpp.get(url);
    if (reponse.statusCode == 200) {
      return json.decode(reponse.body).map((user) => user).toList();
    } else {
      throw Exception('erro');
    }
  }

  void deleteUser({required Map<String, dynamic> user}) async {
    var url = Uri.parse(
        'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/${user['id']}');

    var response = await htpp.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(' deleteado com sucesso'),
            backgroundColor: Colors.redAccent),
      );
    }
  }
}
