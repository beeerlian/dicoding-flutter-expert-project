import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tvshow/domain/entities/tvshow.dart';
import 'package:ditonton/features/tvshow/domain/entities/tvshow_detail.dart';

abstract class TvShowRepository {
  Future<Either<Failure, List<TvShow>>> getNowPlayingTvShow();
  Future<Either<Failure, List<TvShow>>> getPopularTvShow();
  Future<Either<Failure, List<TvShow>>> getTopRatedTvShow();
  Future<Either<Failure, TvShowDetail>> getTvShowDetail(int id);
  Future<Either<Failure, List<TvShow>>> getTvShowRecommendation();
  Future<Either<Failure, List<TvShow>>> searchTvShows(String query);
  Future<Either<Failure, List<TvShow>>> saveTvShowWatchList(
      TvShowDetail tvShow);
  Future<Either<Failure, List<TvShow>>> removeTvShowWatchList(
      TvShowDetail tvShow);
  Future<bool> getWatchListStatus(int id);
  Future<Either<Failure, List<TvShow>>> getWatchListTvShow();
}
