import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_w10_d12_movieflix/models/movie_detail_model.dart';
import 'package:flutter_w10_d12_movieflix/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb;
  final int id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<MovieDetailModel> movieDetail;
  late SharedPreferences prefs;
  bool isBought = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final boughtTickets = prefs.getStringList("boughtTickets");
    print(boughtTickets);
    if (boughtTickets != null) {
      if (boughtTickets.contains(widget.id.toString())) {
        setState(() {
          isBought = true;
        });
      }
    } else {
      prefs.setStringList("boughtTickets", []);
    }
  }

  @override
  void initState() {
    super.initState();
    movieDetail = ApiService.getMovieDetail(widget.id);
    initPrefs();
  }

  String formatRuntime(int runtime) {
    final hours = (runtime / 60).floor();
    final minutes = (runtime % 60);
    String result;
    hours > 0 ? result = "${hours}h ${minutes}min" : result = "${minutes}min";
    return result;
  }

  _onBuyTap() async {
    final boughtTickets = prefs.getStringList("boughtTickets");
    if (boughtTickets != null) {
      if (isBought) {
        boughtTickets.remove(widget.id.toString());
      } else {
        boughtTickets.add(widget.id.toString());
      }
      await prefs.setStringList("boughtTickets", boughtTickets);
      setState(() {
        isBought = !isBought;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://image.tmdb.org/t/p/w500/${widget.thumb}"),
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
                        widget.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: movieDetail,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
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
                              Row(
                                children: [
                                  for (var star in [1, 2, 3, 4, 5])
                                    snapshot.data!.rating / 2 >= star
                                        ? Icon(
                                            Icons.star,
                                            color: Colors.amber.shade300,
                                          )
                                        : snapshot.data!.rating / 2 >=
                                                star - 0.5
                                            ? Icon(Icons.star_half,
                                                color: Colors.amber.shade300)
                                            : Icon(
                                                Icons.star,
                                                color: Colors.amber
                                                    .withOpacity(0.3),
                                              )
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      "${formatRuntime(snapshot.data!.runtime)} | ",
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
                                            "${snapshot.data!.genres[i]["name"]}${i + 1 == snapshot.data!.genres.length ? "" : ", "}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
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
                              SingleChildScrollView(
                                // 스크롤 작동이 안됨.
                                child: SizedBox(
                                  height: 220,
                                  child: Text(
                                    snapshot.data!.overview,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          );
                        }

                        return const Column(
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              )),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _onBuyTap,
              child: Container(
                height: 70,
                margin: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isBought ? Colors.green.shade400 : Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  isBought ? "Cancel Ticket" : "Buy Ticket",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
