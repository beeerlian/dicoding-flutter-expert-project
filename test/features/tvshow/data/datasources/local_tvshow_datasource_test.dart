import 'package:ditonton/common/exception.dart';
import 'package:ditonton/features/tvshow/data/datasources/local_tvshow_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late TvShowLocalDataSourceImpl dataSource;
  late MockTvShowDatabaseHelper mockTvShowDatabaseHelper;

  setUp(() {
    mockTvShowDatabaseHelper = MockTvShowDatabaseHelper();
    dataSource = TvShowLocalDataSourceImpl(mockTvShowDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockTvShowDatabaseHelper.insertWatchlist(testTvShowTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlist(testTvShowTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockTvShowDatabaseHelper.insertWatchlist(testTvShowTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlist(testTvShowTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockTvShowDatabaseHelper.removeWatchlist(testTvShowTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlist(testTvShowTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockTvShowDatabaseHelper.removeWatchlist(testTvShowTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlist(testTvShowTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Movie Detail By Id', () {
    final tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      // arrange
      when(mockTvShowDatabaseHelper.getTvShowById(tId))
          .thenAnswer((_) async => testTvShowMap);
      // act
      final result = await dataSource.getTvShowById(tId);
      // assert
      expect(result, testTvShowTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockTvShowDatabaseHelper.getTvShowById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvShowById(tId);
      // assert
      expect(result, null);
    });
  });

  group('Get TvShow Detail By Id', () {
    final tId = 1;

    test('should return TvShow Detail Table when data is found', () async {
      // arrange
      when(mockTvShowDatabaseHelper.getTvShowById(tId))
          .thenAnswer((_) async => testTvShowMap);
      // act
      final result = await dataSource.getTvShowById(tId);
      // assert
      expect(result, testTvShowTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockTvShowDatabaseHelper.getTvShowById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvShowById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tvshows', () {
    test('should return list of TvShowTable from database', () async {
      // arrange
      when(mockTvShowDatabaseHelper.getWatchlistTvShows())
          .thenAnswer((_) async => [testTvShowMap]);
      // act
      final result = await dataSource.getWatchlistTvShows();
      // assert
      expect(result, [testTvShowTable]);
    });
  });
}
