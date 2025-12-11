import 'package:flutter/material.dart';
import 'package:medicare/common/color_extension.dart';
import 'package:medicare/screen/login/on_boarding_screen.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  int selectIndex = 0;

  List<String> cityCountryList = [
    "New Delhi - India",
    "Mumbai - India",
    "Bengaluru (Bangalore) - India",
    "Kolkata - India",
    "Chennai - India",
    "Hyderabad - India",
    "Ahmedabad - India",
    "Pune - India",
    "Jaipur - India",
    "Lucknow - India",
    "Surat - India",
    "Kanpur - India",
    "Nagpur - India",
    "Patna - India",
    "Indore - India",
    "Bhopal - India",
    "Ludhiana - India",
    "Agra - India",
    "Vadodara - India",
    "Nashik - India",
    "New York City - United States",
    "Los Angeles - United States",
    "Chicago - United States",
    "San Francisco - United States",
    "Miami - United States",
    "Washington, D.C. - United States",
    "London - United Kingdom",
    "Manchester - United Kingdom",
    "Birmingham - United Kingdom",
    "Edinburgh - United Kingdom",
    "Paris - France",
    "Marseille - France",
    "Lyon - France",
    "Toulouse - France",
    "Tokyo - Japan",
    "Osaka - Japan",
    "Kyoto - Japan",
    "Nagoya - Japan",
    "Berlin - Germany",
    "Munich - Germany",
    "Frankfurt - Germany",
    "Hamburg - Germany",
    "Sydney - Australia",
    "Melbourne - Australia",
    "Brisbane - Australia",
    "Perth - Australia",
    "Moscow - Russia",
    "Saint Petersburg - Russia",
    "Kazan - Russia",
    "Novosibirsk - Russia",
    "Beijing - China",
    "Shanghai - China",
    "Guangzhou - China",
    "Shenzhen - China",
    "São Paulo - Brazil",
    "Rio de Janeiro - Brazil",
    "Brasília - Brazil",
    "Salvador - Brazil",
    "Dubai - United Arab Emirates",
    "Abu Dhabi - United Arab Emirates",
    "Sharjah - United Arab Emirates",
    "Toronto - Canada",
    "Montreal - Canada",
    "Vancouver - Canada",
    "Calgary - Canada",
    "Rome - Italy",
    "Milan - Italy",
    "Naples - Italy",
    "Florence - Italy",
    "Mexico City - Mexico",
    "Guadalajara - Mexico",
    "Monterrey - Mexico",
    "Puebla - Mexico",
    "Seoul - South Korea",
    "Busan - South Korea",
    "Incheon - South Korea",
    "Daegu - South Korea",
    "Cairo - Egypt",
    "Alexandria - Egypt",
    "Giza - Egypt",
    "Luxor - Egypt",
    "Madrid - Spain",
    "Barcelona - Spain",
    "Valencia - Spain",
    "Seville - Spain",
    "Istanbul - Turkey",
    "Ankara - Turkey",
    "Izmir - Turkey",
    "Bursa - Turkey",
    "Buenos Aires - Argentina",
    "Córdoba - Argentina",
    "Rosario - Argentina",
    "Mendoza - Argentina",
    "Johannesburg - South Africa",
    "Cape Town - South Africa",
    "Durban - South Africa",
    "Pretoria - South Africa",
    "Singapore - Singapore",
    "Kuala Lumpur - Malaysia",
    "Bangkok - Thailand",
    "Jakarta - Indonesia"
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Select City - Country",
          style: TextStyle(
            color: TColor.primaryTextW,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 35,
                decoration: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3))
                    ]),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Search your City - Country",
                    hintStyle:
                        TextStyle(color: TColor.placeholder, fontSize: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      color: TColor.placeholder,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: TColor.black,
                  size: 25,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Use Your Current Location",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectIndex = index;
                      });

                      context.push( OnBoardingScreen() );

                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        cityCountryList[index],      //change 1
                        style: TextStyle(
                          color: selectIndex == index
                              ? TColor.black
                              : TColor.placeholder,
                          fontSize: 16,
                          fontWeight: selectIndex == index
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black26,
                  height: 1,
                ),
                itemCount: cityCountryList.length, //change 2
              ),
            ),
          )
        ],
      ),
    );
  }
}
