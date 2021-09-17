import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradexa/controller/movieController.dart';
import 'package:tradexa/model/movie.dart';
import 'package:tradexa/provider/schedule.dart';
import 'package:tradexa/utils/helpers.dart';

class HomePage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppbar(),
      backgroundColor: Colors.grey.shade50,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            getSearchWidget(context),
            emptyVerticalBox(),
            Consumer<Schedule>(
              builder: (context, schedule, child) {
                return schedule.loading
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        ),
                      )
                    : schedule.notFound
                        ? Text(
                            "Movie not found -- try something else..",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: schedule.hasMovies
                                  ? schedule.movieList.length
                                  : 0,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return getMovieTile(schedule.movieList[index]);
                              },
                            ),
                          );
              },
            ),
            emptyVerticalBox(),
          ],
        ),
      ),
    );
  }

  getMovieTile(Movie movie) {
    double imdbRating = double.parse(movie.imdbRating!);
    return Container(
      height: 180,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(3, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            left: 10,
            height: 170,
            bottom: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: movie.poster == "assets/poster-not-found.png"
                  ? Image.asset(
                      movie.poster!,
                    )
                  : Image.network(
                      movie.poster!,
                    ),
            ),
          ),
          Positioned(
            left: 160,
            top: 60,
            child: SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title!,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    movie.tags!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  emptyVerticalBox(height: 5),
                  Container(
                    width: 60,
                    height: 15,
                    decoration: BoxDecoration(
                      color: imdbRating < 3.0
                          ? Colors.red
                          : imdbRating < 7.0
                              ? Colors.blue
                              : Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        imdbRating.toString() + " IMDB",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getSearchWidget(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Form(
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search for movies",
                ),
                cursorColor: Colors.grey.shade400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              MovieController controller = MovieController();
              await controller.fetchMovieByTitle(
                  title: searchController.text, context: context);
              searchController.text = "";
            },
            child: Icon(
              Icons.search,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: Text(
        "Home",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      elevation: 0,
    );
  }
}
