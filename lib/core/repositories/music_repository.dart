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
      final response = await Dio().get(
        url,
        data: requestBody,
        queryParameters: {
          'Content-Type': 'application/json', // Указываем тип JSON
        },
      );
      // print('========= response = ${response.data}');

      final fakeResponse = {
        "message": "success",
        "results": [
          {
            "musicLogo": "https://mp3beast.cc/img/crop/NDgzY0RMLUUtREM.jpg",
            "musicLength": 331,
            "songTitle": "Трек: Metallica Enter Sandman Official Music Video",
            "downloadUrl":
                "https://cdn1.odt-converter.com/dl?hash=sdWX5LYJagRRGEllsNPBvKGOQryaclU3nTWulKB8QXcOJFFnJaagbAkipwGd9UZdsakttyiCASQlmBGMf1U%2B%2BvM3NiQxOQ%2FKsN3xy%2BbSYIMN8AckJBKIZsSAJ1K3F5W%2B6zfrOoqNAf09V0R9dQ8mzDfiuibN31u402XWPiWVnOmUzVwQ0NCkzZWUUSqF57I33vx2BTmuZb7Di%2BRIRNaALBGulnNOLu%2F4FdyaP8oekjQ%3D"
          },
          {
            "musicLogo": "https://mp3beast.cc/img/crop/MDYtZ0Z6NE11Wlg.jpg",
            "musicLength": 332,
            "songTitle": "Трек: Enter Sandman Remastered",
            "downloadUrl":
                "https://cdn5.odt-converter.com/dl?hash=QSb8mfzO61W5RbVuyWF39aWeB%2F%2BIgMMHOm8DzfEq%2FMBeCWjMgvzgsyuJJmQNr7V%2FjnA1V971J9SlBbxnj68DEfoKI0SnFTpcG9FnDS0T0a2L2ak4Hz1HDSHIPe%2FOP8vg%2B0mlskKpkvx4KElXtsVQFnKStjyHSS8ogn2zIZuuKr2cdLtgOugQjN6t8ORIZDSbrbbptDOBMcbk7sLuIcKcKw%3D%3D"
          },
          {
            "musicLogo": "https://mp3beast.cc/img/crop/d0x4ZmpEMXliNzg.jpg",
            "musicLength": 407,
            "songTitle":
                "Трек: Metallica Enter Sandman Live In Mexico City Orgullo Pasión Y Gloria",
            "downloadUrl":
                "https://cdn5.odt-converter.com/dl?hash=flWn%2BPJ3OTX2Ca2d%2BbRJ7mLJDDDAPO1Hm51kvYkoFEnCPZMVFmF2Jdb%2Baal4piE%2BK3r7IDOEj%2Beai2VHnAnDr7jyV5G9O7mhwaGO3hHMkFOsgpm87VJSyh7MpBOHZ7rSS9Q0l7gPPOCWOln9%2B78IVPKhsgG%2BUljYCuFj7FVjiHW8E2b%2F1SuLNu0ZWacssfjJ3mPvU%2BUY2qnET8TAm6gB1BOfhjn359LvaLTpivyw8Bp3rAQTPF5Z2inkgLgu3hkscw0sdsm%2B65TR0Rl35ZAQmw%3D%3D"
          },
          {
            "musicLogo": "https://mp3beast.cc/img/crop/VVQtYXdRcXc3V18.jpg",
            "musicLength": 371,
            "songTitle": "Трек: Metallica Enter Sandman Live Moscow 1991 Hd",
            "downloadUrl":
                "https://cdn5.odt-converter.com/dl?hash=YDnJu%2Bb916SUpvkGi0YGAh%2BChbc%2Bp9UiK8jPAq%2FGrd%2F%2Fs2DRvKPAZRN4h55ZybQjAkNy2UD2DZQN80yz%2FA8EZGU852wurbUVu8XIYfF1M8%2Fg9RMHrwvaTsuo8bHewRWlGOPMiCd9iq%2Bf%2B8wlj3RoiSVoqpcO%2B3kVgBf38%2F7RWL4WfR5eyMA4apVCs34Ip%2FR50Ob7g3UElM8QFQTqywlW9QTERQFLz0PkxLWh2wIbtrQ%3D"
          }
        ]
      };

      // print('======== response = ${response.data}');
      // Проверяем статус ответа
      // if (response.statusCode == 200) {
      print("Успешный ответ (200):");
      final jsonData = response.data;
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
