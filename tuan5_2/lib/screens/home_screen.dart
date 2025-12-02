import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();

  // Biến Future để FutureBuilder theo dõi
  Future<WeatherModel>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _loadLastCity();
  }

  // Tải tên thành phố lần cuối và tự động tìm kiếm
  Future<void> _loadLastCity() async {
    final lastCity = await _storageService.getLastCity();
    if (lastCity != null && lastCity.isNotEmpty) {
      _cityController.text = lastCity;
      _searchWeather();
    }
  }

  // Hàm kích hoạt tìm kiếm
  void _searchWeather() {
    final cityName = _cityController.text.trim();
    if (cityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên thành phố')),
      );
      return;
    }

    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    // Lưu tên thành phố và cập nhật Future để UI vẽ lại
    _storageService.saveLastCity(cityName);
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(cityName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức Thời tiết'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Khu vực nhập liệu
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Nhập tên thành phố (VD: Hanoi, London)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              onSubmitted: (_) => _searchWeather(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _searchWeather,
                child: const Text('Xem Thời Tiết'),
              ),
            ),
            const SizedBox(height: 30),

            // Khu vực hiển thị kết quả dùng FutureBuilder
            Expanded(
              child: _weatherFuture == null
                  ? const Center(child: Text('Hãy nhập tên thành phố để xem thời tiết.'))
                  : FutureBuilder<WeatherModel>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  // 1. Đang tải
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Có lỗi
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 50),
                          const SizedBox(height: 10),
                          Text(
                            'Lỗi: ${snapshot.error.toString().replaceAll("Exception: ", "")}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  // 3. Có dữ liệu (Thành công)
                  if (snapshot.hasData) {
                    final weather = snapshot.data!;
                    return _buildWeatherInfo(weather);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị thông tin chi tiết
  Widget _buildWeatherInfo(WeatherModel weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // Icon thời tiết từ OpenWeatherMap
        Image.network(
          'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
        ),
        Text(
          '${weather.temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        Text(
          weather.description.toUpperCase(),
          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blueAccent),
                    const SizedBox(height: 5),
                    Text('Độ ẩm: ${weather.humidity}%'),
                  ],
                ),
                // Bạn có thể thêm các thông tin khác ở đây nếu muốn
              ],
            ),
          ),
        )
      ],
    );
  }
}