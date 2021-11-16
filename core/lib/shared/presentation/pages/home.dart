import 'dart:developer';

import 'package:about/about.dart';
import 'package:core/features/movies/presentation/pages/home_movie_page.dart';
import 'package:core/features/movies/presentation/provider/movie_list_notifier.dart';
import 'package:core/features/tvshow/presentation/pages/home_tvshow_page.dart';
import 'package:core/features/tvshow/presentation/provider/tvshow_list_notifier.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search/search.dart';

import 'all_watchlist_page.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  int _currentIndex = 0;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
    Future.microtask(
        () => Provider.of<TvShowListNotifier>(context, listen: false)
          ..fetchNowPlayingTvShows()
          ..fetchPopularTvShows()
          ..fetchTopRatedTvShows());
  }

  final _bottomNavigationItems = [
    BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movie"),
    BottomNavigationBarItem(
      icon: Icon(Icons.tv),
      label: "Tv Show",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: _buildMyDrawer(),
      appBar: _buildMyAppBar(),
      body: widget._currentIndex == 0 ? HomeMoviePage() : HomeTvShowPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget._currentIndex,
        onTap: _changeSelectedNavBar,
        items: _bottomNavigationItems,
      ),
    );
  }

  AppBar _buildMyAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            _scaffoldkey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu)),
      title: Text('Ditonton'),
      actions: [
        IconButton(
          onPressed: () {
            FirebaseCrashlytics.instance.crash();
            var route = widget._currentIndex == 0
                ? MovieSearchPage.ROUTE_NAME
                : TvShowSearchPage.ROUTE_NAME;
            log(route);
            Navigator.pushNamed(context, route);
          },
          icon: Icon(Icons.search),
        )
      ],
    );
  }

  Drawer _buildMyDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/circle-g.png'),
            ),
            accountName: Text('Ditonton'),
            accountEmail: Text('ditonton@dicoding.com'),
          ),
          ListTile(
            leading: Icon(Icons.movie),
            title: Text('Movies'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: Text('Watchlist'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
            },
            leading: Icon(Icons.info_outline),
            title: Text('About'),
          ),
        ],
      ),
    );
  }

  void _changeSelectedNavBar(int index) {
    setState(() {
      widget._currentIndex = index;
    });
  }
}
