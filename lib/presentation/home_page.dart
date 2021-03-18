import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/joke_model.dart';
import 'package:flutter_sqlite/providers/database_provider.dart';
import 'package:flutter_sqlite/providers/joke_api_provider.dart';
import 'package:unicorndial/unicorndial.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    //* Setting a cool action button to get jokes and clear DB
    List<UnicornButton> buttonList = [];
    buttonList.add(UnicornButton(
        hasLabel: true,
        labelText: "Get new joke from API",
        currentButton: FloatingActionButton(
          backgroundColor: Colors.green[300],
          mini: true,
          child: Icon(Icons.add),
          onPressed: () async {
            await _loadFromApi();
          },
        )));
    buttonList.add(UnicornButton(
        hasLabel: true,
        labelText: "Remove all jokes",
        currentButton: FloatingActionButton(
          backgroundColor: Colors.red[300],
          mini: true,
          child: Icon(Icons.remove),
          onPressed: () async {
            await _deleteData();
          },
        )));

    return Scaffold(
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.blue[400],
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.star),
          childButtons: buttonList),
      appBar: AppBar(
        title: Text('Chuck norris API and Local Storage'),
        centerTitle: true,
        backgroundColor: PrimaryColor,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildJokeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = JokeApiProvider();
    Joke j = await apiProvider.getJoke();

    DBProvider.db.createJoke(j);
    //! Delay to show that API is not instant
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllJokes();
    //! Delay to show data load
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('Shit bro, all jokes are just gone....');
  }

  _buildJokeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllJokes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Column(
                  children: [
                    Text(
                      "${index + 1}",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Icon(Icons.sentiment_satisfied_outlined,
                        color: Colors.yellow[800]),
                  ],
                ),
                title: Text("Joke ID: ${snapshot.data[index].id}"),
                subtitle: Text('${snapshot.data[index].joke}'),
              );
            },
          );
        }
      },
    );
  }
}
