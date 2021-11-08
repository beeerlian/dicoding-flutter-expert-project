import 'package:ditonton/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/features/movies/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/features/tvshow/presentation/pages/watchlist_tvshow_page.dart';
import 'package:ditonton/features/tvshow/presentation/provider/watchlist_tvshow_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  final _listBottomItem = [
    BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movie'),
    BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TvShow')
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false)
            .fetchWatchlistMovies());
    Future.microtask(() =>
        Provider.of<WatchlistTvShowNotifier>(context, listen: false)
            .fetchWatchlistTvShows());
    _pageController =
        PageController(initialPage: _currentIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: pageChanged,
        children: [WatchlistMoviesPage(), WatchlistTvShowsPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: bottomTapped,
          items: _listBottomItem),
    );
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
