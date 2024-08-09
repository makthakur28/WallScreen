# WallScreen - Flutter Wallpaper App

WallScreen is a Flutter-based mobile application that allows users to browse, search, and set high-quality wallpapers from the Pexels API. The app provides a seamless and interactive user experience, offering a variety of categories to choose from and the ability to set wallpapers directly from the app.

## Features

- **Curated Wallpapers**: Browse through a curated collection of high-quality wallpapers.
- **Category Search**: Explore wallpapers by categories such as Animals, Technology, Music, and more.
- **Search Functionality**: Search for wallpapers using specific keywords.
- **Full-Screen Preview**: Preview wallpapers in full-screen mode before setting them as your device background.
- **Set Wallpaper**: Set your favorite wallpapers directly from the app.
- **Load More**: Load more wallpapers as you scroll down.

## Screenshots

Add screenshots of your app here to showcase its UI and features.

## Installation

To run this project on your local machine, follow the instructions below:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/makthakur28/WallScreen.git
   cd WallScreen
   ```

2. **Install Dependencies**:
   Make sure you have Flutter installed on your system. If not, follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).

   Once Flutter is installed, navigate to the project directory and run:
   ```bash
   flutter pub get
   ```

3. **Add API Key**:
   - The app uses the Pexels API to fetch wallpapers. You need to add your API key to the `_WallpaperState` class in the `wallpaper.dart` file.
   - Replace the placeholder `api` variable with your API key:
     ```dart
     final String api = 'YOUR_PEXELS_API_KEY';
     ```

4. **Run the App**:
   - Connect your mobile device or start an emulator.
   - Run the app using the following command:
     ```bash
     flutter run
     ```

5. **Build the APK** (Optional):
   - If you want to build a release version of the app:
     ```bash
     flutter build apk --release
     ```

## Usage

- **Browse Wallpapers**: Open the app and browse through the curated wallpapers on the home screen.
- **Select Categories**: Use the horizontal category list to filter wallpapers by your preferred category.
- **Search for Wallpapers**: Tap the search icon in the app bar to search for specific wallpapers.
- **Set Wallpaper**: Tap on any wallpaper to view it in full screen. Press the "Set Wallpaper" button to set it as your device's background.

## Dependencies

The project uses the following Flutter packages:

- [`cached_network_image`](https://pub.dev/packages/cached_network_image): For efficiently loading and caching images from the network.
- [`http`](https://pub.dev/packages/http): For making HTTP requests to the Pexels API.
- [`flutter_wallpaper_manager`](https://pub.dev/packages/flutter_wallpaper_manager): To set the selected wallpaper as the device background.

## Contributing

If you'd like to contribute to this project, feel free to fork the repository and submit a pull request with your changes. Contributions are always welcome!

## Contact

If you have any questions or suggestions, feel free to reach out:

- GitHub: [makthakur28](https://github.com/makthakur28)
