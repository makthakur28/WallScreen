import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/full_screen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List<dynamic> images = [];
  List<String> categories = ['All', 'Animal', 'Technology', 'Music', 'People'];
  final String api = '6FqXWym9qx46T2tswGdGd0cyi2ySX0q7ip0ohG2wzbSrzLyKDVefYsMY';
  // final String categoryUrl =
  //     'https://api.pexels.com/v1/search?query={query}&per_page={per_page}';
  final String url = 'https://api.pexels.com/v1/';
  int perpage=80;
  dynamic allData = [];
  String selectedCategory = '';
  final categoryImages = {};
  final SearchController _searchController = SearchController();
  final ScrollController _scrollController = ScrollController();
  bool showLoadmore = false;

  late bool searchVisiblity;
  @override
  void initState() {
    super.initState();
    searchVisiblity = false;
    perpage = 80;
    String modifiedUrl = '${url}curated?per_page=$perpage';
    _fetchdata(modifiedUrl);
    _fetchCategoryImages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          showLoadmore = true;
        });
      } else {
        setState(() {
          showLoadmore = false;
        });
      }
    });
    _searchController.addListener(() {
      if(_searchController.isAttached){

      }
    });
  }

  _fetchdata(url) async {
    // print('fetching data');
    final http.Response response =
        await http.get(Uri.parse(url), headers: {'Authorization': api});
    if (response.statusCode == 200) {
      // print('got response as ${response.body}');
      final data = response.body;
      // print(jsonDecode(data)['photos'].length);
      allData = jsonDecode(data);
      setState(() {
        images.addAll(allData['photos']);
        // pageNo = allData['page'];
        // pageNo++;
      });
    }
    // print(response.statusCode);
  }

  _fetchCategoryImages() async {
    for (var category in categories) {
      if (category == 'All') continue;
      String categoryUrl = '${url}search?query=$category&per_page=1';
      final response = await http
          .get(Uri.parse(categoryUrl), headers: {'Authorization': api});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photos'].isNotEmpty) {
          setState(() {
            categoryImages[category] = data['photos'][0]['src']['medium'];
          });
        }
      }
    }
  }

  void loadMore() {
    _fetchdata(allData['next_page']);
  }

  getCategory(String category) {
    String modifiedUrl = '${url}search?query=$category&per_page=$perpage';
    images.clear();
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 1500), curve: Curves.easeInOut);
    if (category.isEmpty || category.toLowerCase() == 'all') {
      modifiedUrl = '${url}curated?per_page=$perpage';
    }
    _fetchdata(modifiedUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WallScreen',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 249, 255),
        leading: const Icon(Icons.home),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  searchVisiblity = !searchVisiblity;
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(8),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: searchVisiblity? 
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: SearchBar(
                  // padding: EdgeInsets.all(8),
                  controller: _searchController,
                  backgroundColor: WidgetStateColor.transparent,
                  elevation: const WidgetStatePropertyAll(0),
                  onSubmitted: (value) => getCategory(value),
                  hintText: 'Search',
                  leading: const Icon(Icons.search),
                  // trailing: _searchController.text.isEmpty?null:[ IconButton(onPressed: getCategory('all'), icon: const Icon(Icons.cancel))],
                ),
              ):const SizedBox.shrink()
            ),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    width: 80,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                categoryImages[categories[index]].toString()),
                            fit: BoxFit.cover),
                        gradient: LinearGradient(colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.grey.withOpacity(0.3)
                        ])),
                    child: InkWell(
                      onTap: () => getCategory(categories[index]),
                      child: Center(
                          child: Text(
                        categories[index],
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  color: Colors.black,
                                  blurRadius: 6,
                                  offset: Offset(1, 1))
                            ]),
                      )),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: false,
                trackVisibility: false,
                interactive: true,
                child: GridView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 4),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                  images: images, initialpage: index),
                            ));
                      },
                      child: Hero(
                        tag: 'imageIndex$index',
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      images[index]['src']['tiny']),
                                  fit: BoxFit.cover),
                              color: const Color.fromARGB(96, 208, 208, 208),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          // child: Image.network(images[index]['src']['tiny'],fit: BoxFit.cover,),// width: 100,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: showLoadmore,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: loadMore,
                  child: const Text('Load More'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
