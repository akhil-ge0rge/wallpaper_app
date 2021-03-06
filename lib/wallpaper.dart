import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:wallpaper_app/fullscreen.dart';

class Wallpapper extends StatefulWidget {
  @override
  State<Wallpapper> createState() => _WallpapperState();
}

class _WallpapperState extends State<Wallpapper> {
  //============================================================
  List images = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              'API Key Paste Here',
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          'API Key Paste Here',
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

//============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreen(
                                    imageurl: images[index]['src']["large2x"],
                                  )));
                    },
                    child: Container(
                        child: Image.network(
                          images[index]['src']["tiny"],
                          fit: BoxFit.cover,
                        ),
                        color: Colors.white),
                  );
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              loadmore();
            },
            child: Container(
              color: Colors.black,
              height: 60,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Load More",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
