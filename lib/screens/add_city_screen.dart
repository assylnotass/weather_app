import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/city_provider.dart';
import 'city_search_screen.dart';

class AddCityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE8E8E8),
      appBar: AppBar(
        title: Text("Добавить город"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFFE8E8E8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final selectedCity = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CitySearchScreen()),
                );
                if (selectedCity != null) {
                  cityProvider.addCity(selectedCity);
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.search, color: Color(0xFFA098AE)),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Введите город',
                      style: TextStyle(color: Color(0xFFA098AE), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cityProvider.cities.length,
                itemBuilder: (context, index) {
                  final city = cityProvider.cities[index];
                  return _buildCityCard(context, cityProvider, city);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityCard(BuildContext context, CityProvider cityProvider, String city) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.location_on, color: Color(0xFF363B64)),
        title: Text(city, style: TextStyle(fontSize: 16)),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            cityProvider.removeCity(city);
          },
        ),
        onTap: () {
          cityProvider.updateCity(city);
          Navigator.pop(context);
        },
      ),
    );
  }
}
