class Joke {
  int id;
  String joke;

  Joke({this.id, this.joke});

  Joke.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    joke = json['joke'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['joke'] = this.joke;
    return data;
  }
}
