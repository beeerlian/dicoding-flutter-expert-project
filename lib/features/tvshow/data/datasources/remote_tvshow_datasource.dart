import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/features/tvshow/data/models/tvshow_detail_model.dart';
import 'package:ditonton/features/tvshow/data/models/tvshow_model.dart';
import 'package:ditonton/features/tvshow/data/models/tvshows_response.dart';
import 'package:ditonton/features/tvshow/domain/entities/tvshow.dart';
import 'package:http/http.dart' as http;

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getNowPlayingTvShow();
  Future<List<TvShowModel>> getPopularTvShow();
  Future<List<TvShowModel>> getTopRatedTvShow();
  Future<TvShowDetailResponse> getTvShowDetail(int id);
  Future<List<TvShowModel>> getTvShowRecommendation(int id);
  Future<List<TvShowModel>> searchTvShow(String query);
}

class TvShowRemoteDataSourceImpl implements TvShowRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvShowRemoteDataSourceImpl(this.client);

  @override
  Future<List<TvShowModel>> getNowPlayingTvShow() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));
    if (response.statusCode == 200)
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
    else
      throw ServerException();
  }

  @override
  Future<List<TvShowModel>> getPopularTvShow() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }

  @override
  Future<List<TvShowModel>> getTopRatedTvShow() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }

  @override
  Future<TvShowDetailResponse> getTvShowDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowDetailResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<List<TvShowModel>> getTvShowRecommendation(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }

  @override
  Future<List<TvShowModel>> searchTvShow(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));
    if (response.statusCode != 200)
      throw ServerException();
    else
      return TvShowResponse.fromJson(jsonDecode(response.body)).tvShowList;
  }
}
