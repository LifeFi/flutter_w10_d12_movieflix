import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_w10_d12_movieflix/models/movie_detail_model.dart';
import 'package:flutter_w10_d12_movieflix/services/api_service.dart';

class DetailScreen extends StatelessWidget {
  final String title, thumb;
  final int id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final Future<MovieDetailModel> movieDetail = ApiService.getMovieDetail(id);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://image.tmdb.org/t/p/w500/$thumb"),
                  fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1,
                sigmaY: 1,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          )
          // Expanded(
          //   child: Image.network(
          //     "https://image.tmdb.org/t/p/w500/$thumb",
          //     fit: BoxFit.cover,
          //     height: MediaQuery.of(context).size.height,
          //     // scale: 1,
          //   ),
          // ),
          ,
          Positioned(
            top: 75,
            left: 15,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "<   Back to List",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: movieDetail,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // print(snapshot.data!.overview);
                          print(snapshot.data!.genres);
                          print(title);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                snapshot.data!.runtime.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  for (var i = 0;
                                      i < snapshot.data!.genres.length;
                                      i++)
                                    Text(
                                      snapshot.data!.genres[i]["name"],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              const Text(
                                "StoryLine",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                snapshot.data!.overview,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                // maxLines: 10,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
