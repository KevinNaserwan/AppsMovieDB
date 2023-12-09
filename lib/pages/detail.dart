import 'package:flutter/material.dart';
import 'package:movietime/Database/database.dart';
import 'package:movietime/pages/Home.dart';
import 'package:movietime/Movie.dart' as Movies;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailMovie extends StatefulWidget {
  final Movies.Movie movie;
  final String baseUrl;

  const DetailMovie({Key? key, required this.movie, required this.baseUrl})
      : super(key: key);

  @override
  State<DetailMovie> createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {
  bool isFavorite = false; // Track the favorite state
  List<Movies.Movie> favoriteMovies = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseMethods _databaseMethods =
      DatabaseMethods(); // Create an instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15141F),
      body: Container(
        child: Column(
          children: [
            Image.network(
              '${widget.baseUrl}${widget.movie.backdropPath}',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      // Toggle the favorite state
                      setState(() {
                        isFavorite = !isFavorite;
                      });

                      if (isFavorite) {
                        // Add to favorite logic
                        addFavoriteToFirestore(widget.movie.title,widget.movie.backdropPath);
                      } else {
                        // Remove from favorite logic
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      '${widget.movie.title}',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.how_to_vote,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${widget.movie.voteCount}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(width: 15),
                        Row(
                          children: [
                            Icon(
                              Icons.star_sharp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${widget.movie.voteAverage} (IMDb)',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Divider(
                          thickness: 1,
                          color: Color(0xFF515151),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Release date',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${widget.movie.releaseDate}',
                                      style: TextStyle(
                                          color: Color(0xFFBCBCBC),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                SizedBox(width: 50),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Genre',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color(0x0DFAF0CA),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Text(
                                              '${widget.movie.genreIds}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    )
                                  ],
                                )
                              ]),
                        ),
                        Divider(
                          thickness: 1,
                          color: Color(0xFF515151),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Synopsis',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${widget.movie.overview}',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addFavoriteToFirestore(String title, String backdropPath) async {
    // Save the favorite to Firestore
    Map<String, dynamic> favoriteMap = {
      'title': title,
      'backdropPath' : backdropPath,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _databaseMethods.addFavorite(favoriteMap);
  }
}
