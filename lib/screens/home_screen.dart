import 'package:flutter/material.dart';
import 'package:flutter_w10_d12_movieflix/models/movie_model.dart';
import 'package:flutter_w10_d12_movieflix/screens/detail_screen.dart';
import 'package:flutter_w10_d12_movieflix/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<MovieModel>> popularMovies = ApiService.getPopularMovies();
  final Future<List<MovieModel>> nowPlayingMovies =
      ApiService.getNowPlayingMovies();
  final Future<List<MovieModel>> comingSoonMovies =
      ApiService.getComingSoonMovies();

  @override
  Widget build(BuildContext context) {
    void _onGoto(int id, String title, String thumb) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              id: id,
              title: title,
              thumb: thumb,
            ),
            // fullscreenDialog: true,
          ));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  "Popular Movies",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 280,
                child: FutureBuilder(
                  future: popularMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        itemBuilder: (context, index) {
                          var movie = snapshot.data![index];
                          return GestureDetector(
                            onTap: () =>
                                _onGoto(movie.id, movie.title, movie.thumb),
                            child: Container(
                              width: 320,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w500/${movie.thumb}",
                                fit: BoxFit.cover,
                                /* headers: const {
                                "User-Agent":
                                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                              }, */
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  "Now in Cinemas",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 265,
                child: FutureBuilder(
                  future: nowPlayingMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        itemBuilder: (context, index) {
                          var movie = snapshot.data![index];
                          return GestureDetector(
                            onTap: () =>
                                _onGoto(movie.id, movie.title, movie.thumb),
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w500/${movie.thumb}",
                                    fit: BoxFit.cover,
                                    /* headers: const {
                                    "User-Agent":
                                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                                  }, */
                                  ),
                                ),
                                Container(
                                  height: 75,
                                  width: 150,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  "Coming soon",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 270,
                child: FutureBuilder(
                  future: comingSoonMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        itemBuilder: (context, index) {
                          var movie = snapshot.data![index];
                          return GestureDetector(
                            onTap: () =>
                                _onGoto(movie.id, movie.title, movie.thumb),
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w500/${movie.thumb}",
                                    fit: BoxFit.cover,
                                    /* headers: const {
                                    "User-Agent":
                                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                                  }, */
                                  ),
                                ),
                                Container(
                                  height: 75,
                                  width: 150,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
