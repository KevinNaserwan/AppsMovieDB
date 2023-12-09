import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:movietime/pages/Home.dart';
import 'package:movietime/pages/detail.dart';
import 'package:movietime/pages/favorite.dart';
import 'dart:convert';
import 'package:movietime/Movie.dart' as Movies;

import 'package:movietime/pages/upcoming.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _searchController;
  late PageController _pageController;
  List<String> searchSuggestions = [];
  final String baseUrl = 'http://image.tmdb.org/t/p/w185/';
  final String apiKey = 'c5c96a6cdc8a22403898d9ae2308545d';
  List<Movies.Movie> movies = [];
  List<String> searchHistory = [];

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
    _searchController = TextEditingController();
    _pageController = PageController(viewportFraction: 0.8);
  }

  Future<void> _searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=c5c96a6cdc8a22403898d9ae2308545d&language=en-US&query=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      setState(() {
        movies = data.map((movieData) => Movies.Movie.fromJson(movieData)).toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }

    setState(() {
      searchSuggestions = movies.map((movie) => movie.title).toList();
      // Add the searched query to the search history
      if (query.isNotEmpty && !searchHistory.contains(query)) {
        searchHistory.insert(0, query);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15141F),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30, left: 50),
                child: Row(
                  children: [
                    // Text(
                    //   'Stream',
                    //   style: TextStyle(
                    //       fontSize: 24,
                    //       fontWeight: FontWeight.w400,
                    //       color: Color(0xFFFF8F71)),
                    // ),
                    // SizedBox(width: 6),
                    // Text(
                    //   'Everywhere',
                    //   style: TextStyle(
                    //       fontSize: 24,
                    //       fontWeight: FontWeight.w400,
                    //       color: Colors.white),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, top: 30),
                child: Container(
                  width: 283,
                  child: Text(
                    'Find Movies, Tv series, and more..',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF211F30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search movies...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_searchController.text.isNotEmpty) {
                                  _searchMovies(_searchController.text);
                                }
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (searchHistory.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search History:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: searchHistory.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _searchController.text =
                                            searchHistory[index];
                                        _searchMovies(searchHistory[index]);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF211F30),
                                      ),
                                      child: Text(searchHistory[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 60),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '$baseUrl${movies[index].posterPath}',
                              width: double.infinity,
                              height: double
                                  .infinity, // Adjust the height as needed
                              fit: BoxFit.cover,
                            ),
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
              ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent)),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Upcoming()));
                  },
                  child: Icon(Icons.upcoming)),
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
                          MaterialPageRoute(builder: (context) => Search()));
                    },
                    child: Icon(Icons.search)),
              ),
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


