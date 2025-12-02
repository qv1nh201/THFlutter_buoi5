class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;
  final int humidity;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
  });

  // Factory method để tạo object từ JSON trả về của OpenWeatherMap
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      // Lấy tên thành phố
      cityName: json['name'] ?? '',
      // Lấy nhiệt độ từ object 'main', chuyển về double
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      // Lấy mô tả từ phần tử đầu tiên của mảng 'weather'
      description: json['weather'][0]['description'] ?? '',
      // Lấy mã icon để hiển thị hình ảnh
      iconCode: json['weather'][0]['icon'] ?? '',
      // Lấy độ ẩm
      humidity: json['main']['humidity'] ?? 0,
    );
  }
}