import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movietime/pages/Home.dart';
import 'package:movietime/pages/search.dart';
import 'package:movietime/pages/upcoming.dart';
import 'package:share/share.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15141F),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(),
              child: Text(
                'Your Favorite Movies',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection('favorite')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        (snapshot.data! as QuerySnapshot).docs.isEmpty) {
                      return Center(
                        child: Text('No data available'),
                      );
                    }

                    final documents = (snapshot.data! as QuerySnapshot).docs;

                    return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var document = documents[index];
                          // Inside your build method where you get the 'Tanggal' value
                          var title = document['title'];
                          var backdropPath = document['backdropPath'];
                          var backdropUrl =
                              'http://image.tmdb.org/t/p/w185/$backdropPath';
                          return Column(
                            children: [
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          backdropUrl,
                                          width: 250,
                                          fit: BoxFit
                                              .cover, // Adjust the width as needed // Adjust the height as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      // Add your logic to remove from the database
                                      // You can use document.id to identify the document
                                      var docId = document.id;
                                      FirebaseFirestore.instance
                                          .collection('favorite')
                                          .doc(docId)
                                          .delete();
                                    },
                                  ), // IconButton for share
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      // Share the title and backdrop URL
                                      Share.share('Check out this movie: $title\nImage: $backdropUrl');
                                    },
                                  ),
                                ],
                              ),
                              // Add unfavorite button
                            ],
                          );
                        });
                  }),
            )
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
                          MaterialPageRoute(builder: (context) => Favorite()));
                    },
                    child: Icon(Icons.favorite)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
