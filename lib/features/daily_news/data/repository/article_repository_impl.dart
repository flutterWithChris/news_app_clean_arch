import 'dart:io';

import 'package:dio/dio.dart';
import 'package:news_app_clean_arch/core/constants/constants.dart';
import 'package:news_app_clean_arch/core/resources/data_state.dart';
import 'package:news_app_clean_arch/features/daily_news/data/data_sources/news_api_service.dart';
import 'package:news_app_clean_arch/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/repositories/article_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;

  ArticleRepositoryImpl(this._newsApiService);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: DotEnv().env['newsApiKey'],
        category: categoryQuery,
        country: countryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
