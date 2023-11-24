class MovieModel {
  final String title, thumb;
  final int id;

  MovieModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['poster_path'],
        id = json['id'];
}
