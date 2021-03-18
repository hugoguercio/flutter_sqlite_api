import 'package:dio/dio.dart';
import 'package:flutter_sqlite/models/joke_model.dart';

class JokeApiProvider {
  Future<Joke> getJoke() async {
    var url = "https://api.icndb.com/jokes/random/";
    Response response = await Dio().get(url);

    Joke j = new Joke(
        id: response.data["value"]["id"], joke: response.data["value"]["joke"]);
    return j;
  }
}
