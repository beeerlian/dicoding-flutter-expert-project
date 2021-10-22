import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tvshow/domain/entities/tvshow.dart';
import 'package:ditonton/features/tvshow/domain/entities/tvshow_detail.dart';
import 'package:ditonton/features/tvshow/domain/repositories/tvshow_repository.dart';

class RemoveTvShowWatchList {
  final TvShowRepository repository;

  RemoveTvShowWatchList(this.repository);

  Future<Either<Failure, String>> execute(TvShowDetail tvShow) {
    return repository.removeTvShowWatchList(tvShow);
  }
}
