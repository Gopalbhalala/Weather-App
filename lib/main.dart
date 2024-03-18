import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/consts/colors.dart';
import 'package:weather_app/consts/images.dart';
import 'package:weather_app/controllers/main_controller.dart';
import 'package:weather_app/our_themes.dart';
import 'package:weather_app/services/api_services.dart';

import 'consts/strings.dart';
import 'models/current_weather_model.dart';
import 'models/hourly_weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      themeMode: ThemeMode.system,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    var date=DateFormat("yMMMd").format(DateTime.now());
    var theme=Theme.of(context);
    var controller= Get.put(MainController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: date.text.color(theme.primaryColor).make(),
        backgroundColor: Colors.transparent,
        actions: [

          Obx(() =>
             IconButton(onPressed: (){
              // Get.changeThemeMode(ThemeMode.dark);
               controller.changeTheme();

            }, icon: Icon(controller.isDark.value ? Icons.light_mode : Icons.dark_mode,color: theme.iconTheme.color)),
          ),

          IconButton(onPressed: (){

          }, icon: Icon(Icons.more_vert,color: theme.iconTheme.color)),
        ],
      ),
      body: Obx(() =>
      controller.isloaded.value == true ?
        Container(
          padding: EdgeInsets.all(12),
          child:FutureBuilder(
            future:controller.currentWeatherData,
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.hasData){

                CurrentWeatherData data = snapshot.data;

                return  SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "${data.name}".text.uppercase.fontFamily('poppins_bold').size(32).color(theme.primaryColor).letterSpacing(3).make(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/weather/${data.weather![0].icon}.png",width: 80,height: 80,),
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(text: "${data.main!.temp}$degree",
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      letterSpacing: 3,
                                      fontFamily: "poppins",
                                      fontSize: 64,
                                    )
                                ),
                                TextSpan(text: " ${data.weather![0].main}",
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      letterSpacing: 3,
                                      fontFamily: "poppins_light",
                                      fontSize: 14,
                                    )
                                )
                              ]
                          ))
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.expand_less_rounded,color: theme.iconTheme.color),
                              label: "${data.main!.tempMax}$degree".text.color(theme.primaryColor).make()),
                          TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.expand_more_rounded,color: theme.iconTheme.color),
                              label: "${data.main!.tempMin}$degree".text.color(theme.primaryColor).make()),
                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(3, (index) {
                          var iconsList=[clouds,humidity,windspeed];
                          var values=["${data.clouds!.all}%", "${data.main!.humidity}%", "${data.wind!.speed} km/h"];
                          return Column(
                            children: [
                              Image.asset(
                                iconsList[index],
                                width: 60,height: 60,)
                                  .box.gray200.padding(EdgeInsets.all(8))
                                  .roundedSM.make(),
                              SizedBox(height: 10,),
                              values[index].text.gray400.make(),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: 10,),
                      Divider(),
                      SizedBox(height: 10,),

                      FutureBuilder(
                          future: controller.hourlyWeatherData,
                          builder: (BuildContext context,AsyncSnapshot snapshot){
                            if (snapshot.hasData) {
                              HourlyWeatherData hourlyData = snapshot.data;

                              return SizedBox(
                                height: 160,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: hourlyData.list!.length > 6 ? 6 : hourlyData.list!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var time = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                                        hourlyData.list![index].dt!.toInt() * 1000));

                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        color: Vx.gray200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          time.text.make(),
                                          Image.asset(
                                            "assets/weather/${hourlyData.list![index].weather![0].icon}.png",
                                            width: 80,
                                          ),
                                          10.heightBox,
                                          "${hourlyData.list![index].main!.temp}$degree".text.make(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            else{
                              return Center(child: CircularProgressIndicator());
                            }
                          }),

                      SizedBox(height: 10,),
                      Divider(),
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Next 7 Days".text.semiBold.color(theme.primaryColor).size(16).make(),
                          TextButton(onPressed: (){

                          }, child: "View All".text.color(theme.primaryColor).make()),

                        ],
                      ),

                      FutureBuilder(
                        future: controller.hourlyWeatherData,
                        builder: (BuildContext context,AsyncSnapshot snapshot) {
                          if(snapshot.hasData){
                            HourlyWeatherData hourlyListData=snapshot.data;

                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 7,
                                itemBuilder: (context,index){
                                  var day=DateFormat("EEEE").format(DateTime.now().add(Duration(days: index+1)));

                                  return Card(
                                    color: theme.cardColor,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                                      margin: EdgeInsets.only(left: 10,right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: day.text.color(theme.primaryColor).semiBold.make()),

                                          Expanded(
                                            child: TextButton.icon(
                                                onPressed: null,
                                                icon: Image.asset('assets/weather/${hourlyListData.list[index].weather![0].icon}.png',width: 40,),
                                                label: "${hourlyListData.list[index].main.temp}$degree".text.color(theme.primaryColor).make()),
                                          ),

                                          RichText(text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: "${hourlyListData.list[index].main!.tempMax}$degree /",
                                                    style: TextStyle(
                                                      color: theme.primaryColor,
                                                      fontFamily: "poppins",
                                                      fontSize: 16,
                                                    )
                                                ),
                                                TextSpan(
                                                    text: "${hourlyListData.list[index].main.tempMin}$degree",
                                                    style: TextStyle(
                                                      color: theme.primaryColor,
                                                      fontFamily: "poppins",
                                                      fontSize: 16,
                                                    )
                                                ),
                                              ]
                                          ))
                                        ],
                                      ),
                                    ),
                                  );

                                });
                          }
                          else{
                            return Center(child: CircularProgressIndicator());
                          }

                        }
                      )
                    ],
                  ),
                );
              }else{
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
