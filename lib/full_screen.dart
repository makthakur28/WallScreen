import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreenImage extends StatefulWidget {
  final List<dynamic> images;
  final int initialpage;

  const FullScreenImage({
    super.key,
    required this.images,
    required this.initialpage,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialpage);
  }

  Future<void> setWallpaper(String image) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Setting Wallpaper...')));
    int location = WallpaperManager.HOME_SCREEN;
    // debugPrint('Got location: $location');
    try {
      // debugPrint('trying to save to cache ');
      var file = await DefaultCacheManager().getSingleFile(image);
      // debugPrint('Got file: $file');
      bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      // debugPrint('Got result: $result');
      // debugPrint('Mounted ?? : $mounted');
      // if (!mounted) return;
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wallpaper Set Successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong, try Again!!')));
      }
    } catch (e) {
      // debugPrint('Something went wrong in SetWallpaper : $e');
      debugPrint('Error setting wallpaper: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to set wallpaper')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: widget.images.length,
          controller: _controller,
          itemBuilder: (context, index) {
            String image = widget.images[index]['src']['large2x'];
            debugPrint('Image URL: $image');
            if (image.isEmpty) {
              return const Center(child: Text('Image URL is null or empty'));
            }
            return Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: Stack(
                children: [
                  Hero(
                    tag: 'imageIndex$index',
                    child: SizedBox(
                      height: double.infinity,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: () => setWallpaper(image),
                        child: const Text('SET WALLPAPER'),
                      ))
                ],
              ),
            );
          }),
    );
  }
}
