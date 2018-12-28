
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flim/TMDBConfig.dart';
import 'package:flutter_flim/model/MovieDetail.dart';
import 'package:flutter_flim/ui/MovieDetailHeader.dart';
import 'package:flutter_flim/ui/ProductionCompaniesScroller.dart';
import 'package:flutter_flim/ui/StoryLine.dart';
// ignore: uri_does_not_exist
import 'package:http/http.dart' as http;

class MovieDetailsPage extends StatelessWidget {
  MovieDetailsPage(this.id);

  var id;

  MovieDetail detail;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new FutureBuilder<MovieDetail>(
        // ignore: undefined_operator, equality_cannot_be_equality_operand
        future: Future<MovieDetail> getMovieDetail(id),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            print("Result $snapshot");
            return new Container(
              child: new Center(
                child: new CircularProgressIndicator(),
              ),
            );
          }else if(snapshot.hasError){
            return new Center(
              child: new Text("${snapshot.error}"),
            );
          } else {
            MovieDetail movies = snapshot.data;
            return new SingleChildScrollView(
              child: new Column(
                children: [
                  new MovieDetailHeader(movies),
                  new Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new StoryLine(movies.synopsis),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      bottom: 50.0,
                    ),
                    child: new ProductionCompaniesScroller(
                      movies.productionCompanies
                    ),
                  )
                ],
              ),
            );
          }
        }
      ),
    );
  }

  Future<MovieDetail> getMovieDetail(id) async{
    final String nowPlaying = 'https://api.themoviedb.org/3/movie/' +
      id.toString() +
      '?api_key=' +
      TMDBConfig.apiKey +
      '&page=' +
      '1';

    var httpClient = new HttpClient();
    try{
      final response = await http.get(nowPlaying);
      final responseJson = json.decode(response.body);

      MovieDetail movieDetail = createDetailList(responseJson);

      return movieDetail;
    }catch (exception){
      print(exception.toString());
    }
    return null;
  }

  MovieDetail createDetailList(data) {
    List<String> genresList = new List();
    List<ProductionCompanies> productionCompaniesList = new List();

    var id = data["id"];
    var title = data["original_title"];
    var productionCompany = data["production_companies"];
    for (int i = 0; i < productionCompany.length; i++){
      var id = productionCompany[i]["id"];
      String name = productionCompany [i]["name"];
      String logoPath = productionCompany[i]["logo_path"];
      ProductionCompanies productionCompanies = new ProductionCompanies(id, name, logoPath);
      productionCompaniesList.add(productionCompanies);
    }
    var genres = data["genres"];
    for (int i = 0; i < genres.length; i++){
      String name = genres[i]["name"];
      genresList.add(name);
    }
    var overview = data["overview"];
    var posterPath = data["poster_path"];
    var backdropPath = data["backdrop_path"];
    var voteAverage = data["vote_average"];
    MovieDetail detail = MovieDetail(id, title, genresList, overview, posterPath, backdropPath, voteAverage, productionCompaniesList);
    return detail;
  }
}