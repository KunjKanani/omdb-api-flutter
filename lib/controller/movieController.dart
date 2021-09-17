import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tradexa/model/movie.dart';
import 'package:tradexa/provider/schedule.dart';

class MovieController {
  final http.Client client = http.Client();

  Future fetchMovieByTitle({required String? title,required BuildContext context}) async {
    var schedule = Provider.of<Schedule>(context, listen: false);
    schedule.loading = true;

    // Send request to api
    Uri url = Uri.parse("https://www.omdbapi.com/?apikey=4756bde8&t=$title");
    http.Response response = await client.get(url);

    //Check Response Code
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      //Check Response has data
      if(responseData["Response"] == "True") {
        // Create movie obj using model
        String responseTitle = responseData["Title"] ?? "";
        String tags = responseData["Genre"].toString().replaceAll(",", " |");
        String imdbRating = responseData["imdbRating"] ?? "";
        String poster = responseData["Poster"] ?? "";
        if(responseTitle == "" || responseTitle == "N/A") {
          responseTitle = "Title";
        }
        if(poster == "" || poster == "N/A") {
          poster = "assets/poster-not-found.png";
        }
        if(imdbRating == "" || imdbRating == "N/A") {
          imdbRating = "0.0";
        }
        if(tags == "" || tags == "N/A") {
          tags = "No Tags";
        }
        Movie fetchedMovie = new Movie(title: responseTitle, tags: tags, imdbRating: imdbRating, poster: poster);

        // Updating the state with movie
        schedule.movieList = [fetchedMovie];
        schedule.hasMovies = true;
        schedule.notFound = false;
        schedule.loading = false;
      } else {
        // If response doesn't container any data
        schedule.notFound = true;
        schedule.loading = false;
      }
    } else {
      schedule.notFound = true;
      schedule.loading = false;
    }
  }
}
