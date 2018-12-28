import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flim/TMDBConfig.dart';
import 'package:flutter_flim/model/NowPlayingMovie.dart';
import 'package:flutter_flim/model/PopularMovie.dart';
import 'package:flutter_flim/model/UpcomingMovie.dart';
import 'package:flutter_flim/ui/MovieDetailsPage.dart';
// ignore: uri_does_not_exist
import 'package:transparent_image/transparent_image.dart';

//void main() => runApp(MyApp());

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Movies',
      home: MainPage(),
    );
  }
}

Future<List<NowPlayingMovie>> getNowPlayingMovies() async {
  final String nowPlaying = 'https://api.themoviedb.org/3/movie/now_playing?api_key=' + TMDBConfig.apiKey + '&page=' + '1';

  var httpClient = new HttpClient();
  try{
    var request = await httpClient.getUrl(Uri.parse(nowPlaying));
    var response = await request.close();
    if(response.statusCode == HttpStatus.OK){
      var jsonResponse = await response.transform(utf8.decoder).join();

      var data = jsonDecode(jsonResponse);

      List results = data["results"];

      List<NowPlayingMovie> movieList = createNowPlayingMovieList(results);
      return movieList;
    }else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

Future<List<UpcomingMovie>> getUpcomingMovies() async {
  final String nowPlaying = 'https://api.themoviedb.org/3/movie/upcoming?api_key=' + TMDBConfig.apiKey + '&page=' + '1';

  var httpClient = new HttpClient();
  try{
    var request = await httpClient.getUrl(Uri.parse(nowPlaying));
    var response = await request.close();
    if(response.statusCode == HttpStatus.OK){
      var jsonResponse = await response.transform(utf8.decoder).join();

      var data = jsonDecode(jsonResponse);

      List results = data["results"];

      List<UpcomingMovie> movieList = createUpcomingMovieList(results);
      return movieList;
    }else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

Future<List<PopularMovie>> getPopularMovies() async {
  final String nowPlaying = 'https://api.themoviedb.org/3/movie/popular?api_key=' + TMDBConfig.apiKey + '&page=' + '1';

  var httpClient = new HttpClient();
  try{
    var request = await httpClient.getUrl(Uri.parse(nowPlaying));
    var response = await request.close();
    if(response.statusCode == HttpStatus.OK){
      var jsonResponse = await response.transform(utf8.decoder).join();

      var data = jsonDecode(jsonResponse);

      List results = data["results"];

      List<PopularMovie> movieList = createPopularMovieList(results);
      return movieList;
    }else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

List<NowPlayingMovie> createNowPlayingMovieList(List data) {
  List<NowPlayingMovie> list = new List();
  for(int i = 0; i < data.length; i++){
    var id = data[i]["id"];
    String title = data[i]["title"];
    String posterPath = data[i]["poster_path"];
    String backdropImage = data[i]["backdrop_path"];
    String originalTitle = data[i]["original_title"];
    String voteAverage = data[i]["vote_average"];
    String overview = data[i]["overview"];
    String releaseDate = data[i]["release_date"];
    
    NowPlayingMovie movie = new NowPlayingMovie(
      id, title, posterPath, backdropImage, originalTitle, voteAverage, overview, releaseDate
    );
    list.add(movie);
  }
  return list;
}

List<UpcomingMovie> createUpcomingMovieList(List data) {
  List<UpcomingMovie> list = new List();
  for(int i = 0; i < data.length; i++){
    var id = data[i]["id"];
    String title = data[i]["title"];
    String posterPath = data[i]["poster_path"];
    String backdropImage = data[i]["backdrop_path"];
    String originalTitle = data[i]["original_title"];
    String voteAverage = data[i]["vote_average"];
    String overview = data[i]["overview"];
    String releaseDate = data[i]["release_date"];

    UpcomingMovie movie = new UpcomingMovie(
        id, title, posterPath, backdropImage, originalTitle, voteAverage, overview, releaseDate
    );
    list.add(movie);
  }
  return list;
}

List<PopularMovie> createPopularMovieList(List data) {
  List<PopularMovie> list = new List();
  for(int i = 0; i < data.length; i++){
    var id = data[i]["id"];
    String title = data[i]["title"];
    String posterPath = data[i]["poster_path"];
    String backdropImage = data[i]["backdrop_path"];
    String originalTitle = data[i]["original_title"];
    String voteAverage = data[i]["vote_average"];
    String overview = data[i]["overview"];
    String releaseDate = data[i]["release_date"];

    PopularMovie movie = new PopularMovie(
        id, title, posterPath, backdropImage, originalTitle, voteAverage, overview, releaseDate
    );
    list.add(movie);
  }
  return list;
}

List<Widget> createNowPlayingMovieCardItem(
  List<NowPlayingMovie> movies, BuildContext context){
  
  List<Widget> listElementWidgetList = new List<Widget>();
  if (movies != null){
    var lengthOfList = movies.length;
    for (int i = 0; i < lengthOfList; i++){
      NowPlayingMovie movie = movies[i];
      
      var imageURL = "https://image.tmdb.org/t/p/w500/" + movie.posterPath;
      
      var listItem = new GridTile(
        footer: new GridTileBar(
          backgroundColor: Colors.black45,
          title: new Text(movie.title),
        ),
        child: new GestureDetector(
          onTap: () {
            if (movie.id > 0) {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (_) => new MovieDetailsPage(movie.id)),
              );
            }
          },
          child: new FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: imageURL,
            fit: BoxFit.cover,
          ),
        ),
      );
      listElementWidgetList.add(listItem);
    }
  }
  return listElementWidgetList;
}

List<Widget> createUpcomingMovieCardItem(
    List<UpcomingMovie> movies, BuildContext context){

  List<Widget> listElementWidgetList = new List<Widget>();
  if (movies != null){
    var lengthOfList = movies.length;
    for (int i = 0; i < lengthOfList; i++){
      UpcomingMovie movie = movies[i];

      var imageURL = "https://image.tmdb.org/t/p/w500/" + movie.posterPath;

      var listItem = new GridTile(
        footer: new GridTileBar(
          backgroundColor: Colors.black45,
          title: new Text(movie.title),
        ),
        child: new GestureDetector(
          onTap: () {
            if (movie.id > 0) {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (_) => new MovieDetailsPage(movie.id)),
              );
            }
          },
          child: new FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: imageURL,
            fit: BoxFit.cover,
          ),
        ),
      );
      listElementWidgetList.add(listItem);
    }
  }
  return listElementWidgetList;
}

List<Widget> createPopularMovieCardItem(
  List<PopularMovie> movies, BuildContext context){
  List<Widget> listElementWidgetList = new List<Widget>();
  if(movies != null) {
    var lengthOfList = movies.length;
    for (int i = 0; i < lengthOfList; i++){
      PopularMovie movie = movies [i];

      var imageURL = "https://image.tmdb.org/t/p/w500/" + movie.posterPath;

      var listItem = new GridTile(
        footer: new GridTileBar(
          backgroundColor: Colors.black45,
          title: new Text(movie.title),
        ),
        child: new GestureDetector(
          onTap: () {
            if (movie.id > 0) {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (_) => new MovieDetailsPage(movie.id)),
              );
            }
          },
          child: new FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: imageURL,
            fit: BoxFit.cover,
          ),
        ),
      );
      listElementWidgetList.add(listItem);
    }
  }
  return listElementWidgetList;
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return MainPageState();
  }

}

class MainPageState extends State<MainPage> {

  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Movies"),
      ),
      body: PageView(
        children: <Widget>[
          new Offstage(
            offstage: _page != 0,
            child: new TickerMode(
                enabled: _page == 0,
                child: new FutureBuilder(
                  future: getNowPlayingMovies(),
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot){
                    if(!snapshot.hasData)
                      return new Container(
                        child: new Center(
                          child: new CircularProgressIndicator(),
                        ),
                      );

                    List movies = snapshot.data;
                    return new CustomScrollView(
                      primary: false,
                      slivers: <Widget>[
                        new SliverPadding(
                          padding: const EdgeInsets.all(10.0),
                          sliver: new SliverGrid.count(
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            crossAxisCount: 2,
                            children: createNowPlayingMovieCardItem(movies, context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ),
          ),
          new Offstage(
            offstage: _page != 1,
            child: new TickerMode(
              enabled: _page == 1,
              child: new FutureBuilder(
                future: getUpcomingMovies(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot){
                  if (!snapshot.hasData){
                    return new Container(
                      child: new Center(
                        child: new CircularProgressIndicator(),
                      ),
                    );
                  }
                  List movies = snapshot.data;
                  return new CustomScrollView(
                    primary: false,
                    slivers: <Widget>[
                      new SliverPadding(
                        padding: const EdgeInsets.all(10.0),
                        sliver: new SliverGrid.count(
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          crossAxisCount: 2,
                          children: createUpcomingMovieCardItem(movies,context),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          new Offstage(
            offstage: _page != 1,
            child: new TickerMode(
              enabled: _page == 1,
              child: new FutureBuilder(
                future: getUpcomingMovies(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot){
                  if (!snapshot.hasData){
                    return new Container(
                      child: new Center(
                        child: new CircularProgressIndicator(),
                      ),
                    );
                  }
                  List movies = snapshot.data;
                  return new CustomScrollView(
                    primary: false,
                    slivers: <Widget>[
                      new SliverPadding(
                        padding: const EdgeInsets.all(10.0),
                        sliver: new SliverGrid.count(
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          crossAxisCount: 2,
                          children: createPopularMovieCardItem(movies,context),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_seat), title: Text("Now Playing")),
          BottomNavigationBarItem(
            icon: Icon(Icons.event), title: Text("Upcoming")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), title: Text("Popular")
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page){
    setState(() {
      this._page = page;
    });
  }


}
