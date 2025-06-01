import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  // Замените на ваш URL (localhost или IP)
  final url = Uri.parse('http://localhost:3000/api/parse/');
  // Или для теста с реальным IP (если сервер доступен в сети):
  // final url = Uri.parse('http://192.168.1.100:3000/api/parse/');

  // Тело запроса в формате JSON
  final requestBody = {
    "songName": "имя музыки",  // Замените на реальное название
    "parserType": "mp3beast"   // Или другой тип парсера
  };

  try {
    print("Отправка POST-запроса...");

    // Делаем POST-запрос с JSON-заголовком
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Указываем тип JSON
      },
      body: jsonEncode(requestBody), // Кодируем Map в JSON-строку
    );

    // Проверяем статус ответа
    if (response.statusCode == 200) {
      print("Успешный ответ (200):");
      final jsonData = jsonDecode(response.body);
      print("Полный ответ: $jsonData");

      // Пример вывода конкретных полей (если знаете структуру ответа)
      if (jsonData.containsKey('downloadUrl')) {
        print("Ссылка для скачивания: ${jsonData['downloadUrl']}");
      }
    } else {
      print("Ошибка сервера: ${response.statusCode}");
      print("Тело ошибки: ${response.body}");
    }
  } catch (e) {
    print("Ошибка при запросе: $e");
    if (e is http.ClientException) {
      print("Проверьте, запущен ли сервер и доступен ли по адресу $url");
    }
  }
}