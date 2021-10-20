import 'package:dartz/dartz.dart';
import 'package:ditonton/features/tvshow/domain/entities/tvshow.dart';
import 'package:ditonton/features/tvshow/domain/repositories/tvshow_repository.dart';
import 'package:ditonton/features/tvshow/domain/usecases/get_popular_tvshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvShow usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetPopularTvShow(mockTvShowRepository);
  });

  final tTvShows = <TvShow>[];
  test(
      'should get list of popular tvShow from repository when execute function is called',
      () async {
    //arrange
    when(mockTvShowRepository.getPopularTvShow())
        .thenAnswer((_) async => Right(tTvShows));
    //act
    final result = await usecase.execute();
    //assert
    expect(result, Right(tTvShows));
  });
}
