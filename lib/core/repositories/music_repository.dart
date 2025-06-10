import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:music_player/feature/playlist/data/songs_response.dart';

class MusicRepository {
  final Client _dio;

  MusicRepository(this._dio);

  Future<Either<int?, SongsResponse?>> searchSongs({
    required String name,
  }) async {
    // Замените на ваш URL (localhost или IP)
    final url = 'http://62.60.149.142:3000/api/parse/';
    // Или для теста с реальным IP (если сервер доступен в сети):
    // final url = Uri.parse('http://192.168.1.100:3000/api/parse/');

    // Тело запроса в формате JSON
    final requestBody = {
      "songName": name, // Замените на реальное название
      "parserType": "mp3beast" // Или другой тип парсера
    };

    try {
      print("Отправка POST-запроса...");

      // Делаем POST-запрос с JSON-заголовком
      // final response = await Dio().get(
      //   url,
      //   data: requestBody,
      //   queryParameters: {
      //     'Content-Type': 'application/json', // Указываем тип JSON
      //   },
      // );
      // print('========= response = ${response.data}');

      final fakeResponse = {
        "message": "success",
        "results": [
          {
            "songTitle": "Трек: Metallica The Unforgiven Official Music Video",
            "downloadUrl":
                "https://cdn1.odt-converter.com/dl?hash=P1FwgNXazAt7L4B%2Byo55%2FG9GLSt%2Ftg3AWdwA2IOtYc6agHWYROrva0TuiPod8CSTAtxHZ8nv9wlBpZ5womtYNyWIUegA7QfG7duKm2FuLcnBDsACN21lJ7YavqEVWokm9hcYokR2fj%2F%2F1Stz%2FnnAKw%2Be8QFzSXOJcKSqUWZ5Qdl17MDFd766ZdfeftnIkKyCfZ36R1fhCQ9Cgzj9Tb6GjVlhUVFEHLzgToJvs%2BaMxLz3K8VHVVUvXBVm24UokICx"
          },
          {
            "songTitle": "Трек: For Whom The Bell Tolls Remastered",
            "downloadUrl":
                "https://cdn5.odt-converter.com/dl?hash=9Tu05bDXcJZ8nUg0sATTnfDpewO%2BD43dIigItq9GEC7CAb3NGe3AQZblQfjlO%2Fk%2FzzYSvGFmpW8SLet8t%2F1QjBUn6PPCjCLKLF09V%2F844GORcUIG2mbEiChnMfVIKsTkguVRkAbDq9DPIyQpINpLAB1%2Fp1%2FF7vDz%2BBLnJVfSa2jkOXWG7F%2B88Z9Wys7l1Cjn4DjbXDtjUzwYoE78m1DTmUDmdsW15cf%2Bxn5O6Jc5SLI%3D"
          },
          {
            "songTitle": "Трек: Master Of Puppets Remastered",
            "downloadUrl":
                "https://cdn5.odt-converter.com/dl?hash=2RjxNzJl0P4Y44%2BG8U0s1b%2FJy3YMsoRCfdDjA9QVdvWXwkuA95o8CcS1fmprvUfJfxDBvVCQSkyT7I5Q1YyzDh6O1EbK0c6iVLS6HYoxODCzh%2BCOOJ%2BngMXs6fBSiTw9iwhpjy0wCvXHG%2BJJM3IvslVWwB1uaKJlM0nuqdXwKi7uWXpeM4xAVMrUk5Eu9Hp%2FJfbaQry0NFbZqCOrHTl8iQ%3D%3D"
          },
          {
            "songTitle": "Трек: The Unforgiven",
            "downloadUrl":
                "https://cdn4.odt-converter.com/dl?hash=Ybkqq7yY4hmN%2B2F8IGwiJ06j8KpsTorJjvAjmhiFcU%2FtvBT0TIdllfaQ0ahlfBb3osgvL6nsGv5k2yuTVkFPeIb8N6NNkCzOFyPlUURYWtdJiKqSUqM3rS2DnWZ5MUxk%2F%2BVCBWIMfzZELym20TbAIVY0RUyM6191B%2BplBuR6KUYY7VmwYnQM5LQIvcYlZ8u%2F"
          },
          {
            "songTitle": "Трек: Metallica The Day That Never Comes Official Music Video",
            "downloadUrl":
                "https://cdn3.odt-converter.com/dl?hash=x3n%2FNn3bQnQLgqUh4G%2BVzg7INXlOglj3cEg9Yw7q%2BYuOkgfagwXtpYBeiLis09P99C7Uut%2FsCnEymjO9awor2LHftZaVEBR4kpwtFn4b3SM49yuBsMrIfXYbHNEmlSxCH%2FPs3%2FxJcq11SxV9rjz9FIKT0%2BbBBSZIJG0Kvt%2BqGK6J8eFZZOwYsKQI1ZMsGEQGn7Wv0Frs1CbumKxBjBs0XdTJ51Js3NMfNBl2tSwqyQqilpKdIkuwKLsAGS4B4Aws"
          },
          {
            "songTitle": "Трек: Nothing Else Matters Metallica Mozart Heroes Official Video",
            "downloadUrl":
                "https://cdn1.odt-converter.com/dl?hash=l%2BGAeZLB094uQh3Squx6k9M2RCT6Gf4YIm6PjQipgVgmLiyMjTOvn%2BVPlUqFQ0jLurPPm1ypYmXPMkeinrcZby7vjPJrpalCHqqzWglAi0sl2wOKJZTVD8QCA7PLJTlUQAM3CeVMT2crA0aL1udCrhyCZKR6JQvpXNleRx81HDAeT9rf9h6n6sPnvrnIMyr%2FsIUEP6Iq%2F25VA2RMYNeW%2Bw5betE909lhVJYhxK6kAZOz3f7XCS8Lfogrk4umrl9FtjKk31ADD%2BJP4b%2Fqiyu%2F5w%3D%3D"
          }
        ]
      };

      // print('======== response = ${response.data}');
      // Проверяем статус ответа
      // if (response.statusCode == 200) {
      print("Успешный ответ (200):");
      final jsonData = fakeResponse; //response.data;
      print("Полный ответ: $jsonData");

      // Пример вывода конкретных полей (если знаете структуру ответа)
      if (jsonData.containsKey('downloadUrl')) {
        print("Ссылка для скачивания: ${jsonData['downloadUrl']}");
      }
      return Right(SongsResponse.fromJson(jsonData));
      // } else {
      //   print("Ошибка сервера: ${response.statusCode}");
      //   print("Тело ошибки: ${response.data}");
      //
      //   return Left(response.statusCode);
      // }
    } catch (e) {
      print("Ошибка при запросе: $e");
      if (e is http.ClientException) {
        print("Проверьте, запущен ли сервер и доступен ли по адресу $url");
      }

      return Left(401);
    }
  }
}
