import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:movietime/pages/Home.dart';
import 'package:movietime/pages/detail.dart';
import 'package:movietime/pages/favorite.dart';
import 'dart:convert';
import 'package:movietime/Movie.dart' as Movies;

import 'package:movietime/pages/search.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  late Timer _timer;
  late PageController _pageController;

  // Base URL dari TMDb untuk gambar poster film
  final String baseUrl = 'http://image.tmdb.org/t/p/w185/';

  List<Movies.Movie> movies = []; // Buat list untuk menyimpan data film
  void _navigateToDetailPage(Movies.Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMovie(movie: movie, baseUrl: baseUrl),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_pageController.page! < movies.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.jumpToPage(0);
      }
    });
    // Panggil fungsi untuk mengambil data film dari API
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=c5c96a6cdc8a22403898d9ae2308545d&language=en-US'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      setState(() {
        movies =
            data.map((movieData) => Movies.Movie.fromJson(movieData)).toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15141F),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60, left: 50),
              child: Row(
                children: [
                  Text(
                    'Stream',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFF8F71)),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Everywhere',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  // Gambar dengan corner radius
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/images/movie1.png'),
                  ),
                  // Container dengan icon play di tengah
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.only(top: 110),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SizedBox(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Continue Watching',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFBCBCBC),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      'Ready Player One',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 50, top: 30),
              child: Text(
                'Upcoming',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 336,
              child: PageView.builder(
                controller: _pageController,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _navigateToDetailPage(movies[index]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 260,
                                child: Image.network(
                                  '$baseUrl${movies[index].posterPath}',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Positioned.fill(
                            //   child: Container(
                            //     margin: EdgeInsets.only(top: 250),
                            //     padding: EdgeInsets.only(left: 40),
                            //     child: SizedBox(
                            //       child: Row(
                            //         children: [
                            //           Column(
                            //             children: [
                            //               SizedBox(
                            //                 width: 180,
                            //                 child: Container(
                            //                   decoration: BoxDecoration(
                            //                     color: Color.fromARGB(
                            //                         203, 218, 218, 218),
                            //                     borderRadius:
                            //                         BorderRadius.circular(10),
                            //                   ),
                            //                   child: Padding(
                            //                     padding: const EdgeInsets.only(
                            //                         top: 10,
                            //                         bottom: 10,
                            //                         left: 20),
                            //                     child: Text(
                            //                       movies[index].title,
                            //                       style: TextStyle(
                            //                         fontSize: 16,
                            //                         color: Colors.black,
                            //                         fontWeight: FontWeight.w500,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               )
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(0),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Icon(Icons.play_arrow)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFF8F71),
                    borderRadius: BorderRadius.circular(50)),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent)),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Upcoming()));
                    },
                    child: Icon(Icons.upcoming)),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent)),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Search()));
                  },
                  child: Icon(Icons.search)),
              ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent)),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Favorite()));
                  },
                  child: Icon(Icons.favorite)),
            ],
          ),
        ),
      ),
    );
  }
}
