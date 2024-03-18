import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/consts/strings.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';

// var link="https://api.openweathermap.org/data/2.5/weather?lat=21.1702&lon=72.8311&appid=0096a8cd1f686eac26c18ecfb4134336&units=metric";
// var hourlyLink="https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

getCurrentWeather(lat,long) async{
  var link="https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=0096a8cd1f686eac26c18ecfb4134336&units=metric";

  var res=await http.get(Uri.parse(link));


  if(res.statusCode==200){
    var data=currentWeatherDataFromJson(res.body.toString());
    return data;
  }
}


gethourlyWeather(lat,long) async{
  var hourlyLink="https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var res=await http.get(Uri.parse(hourlyLink));


  if(res.statusCode==200){
    var data=hourlyWeatherDataFromJson(res.body.toString());
    return data;
  }
}