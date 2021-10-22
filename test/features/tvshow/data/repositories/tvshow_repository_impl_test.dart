import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tvshow/data/models/tvshow_model.dart';
import 'package:ditonton/features/tvshow/data/repositories/tvshow_repository_impl.dart';
import 'package:ditonton/features/tvshow/domain/entities/tvshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late TvShowRepositoryImpl repository;
  late MockTvShowLocalDataSource mockLocalDataSource;
  late MockTvShowRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockTvShowLocalDataSource();
    mockRemoteDataSource = MockTvShowRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvShowRepositoryImpl(
        remoteDatasource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  final tTvShowModel = TvShowModel(
    id: 1,
    posterPath: "posterPath",
    backdropPath: "backdropPath",
    voteAverage: 2.0,
    overview: "overview",
    firstAirDate: "firstAirDate",
    originCountry: ["originCountry"],
    genreIds: [1, 2],
    originalLanguage: "originalLanguage",
    voteCount: 24,
    name: "name",
    originalName: "originalName",
  );

  final tTvShowModelList = <TvShowModel>[tTvShowModel];
  final tTvShowList = <TvShow>[testTvShow];

  group('Now Playing TvShow', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    test('Should check is the device online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenAnswer((_) async => []);
      //act
      await repository.getNowPlayingTvShow();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenAnswer((_) async => tTvShowModelList);
      // act
      final result = await repository.getNowPlayingTvShow();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTvShow());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvShowList);
    });

    test(
        'Should cache data locally when the call to remote data source is successful',
        () async {
      //arrange
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenAnswer((_) async => tTvShowModelList);
      //act
      await repository.getNowPlayingTvShow();
      //assert
      verify(mockRemoteDataSource.getNowPlayingTvShow());
      verify(mockLocalDataSource.cacheNowPlayingTvShows([testTvShowCache]));
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingTvShow();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTvShow());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvShow())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result =
          await repository.getNowPlayingTvShow();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTvShow());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
}
