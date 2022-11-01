//* Packages
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/controllers/main_page_data_controller.dart';
import 'package:movie_app/models/main_page_data.dart';
import 'package:movie_app/models/movie.dart';

import '../models/search_category.dart';
import '../models/movie.dart';
import '../widgets/movie_tile.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController>((ref) {
  return MainPageDataController();
});

final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
  final movies = ref.watch(mainPageDataControllerProvider.state).movies;
  if (movies.isNotEmpty) {
    return movies[0].posterURL();
  } else {
    return null;
  }
});

class MainPage extends ConsumerWidget {
  double? deviceHeight;
  double? deviceWidth;

  MainPageDataController? mainPageDataController;

  MainPageData? mainPageData;

  TextEditingController? searchFieldController;

  var selectedMoviePosterURL;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    mainPageDataController = watch(mainPageDataControllerProvider);

    mainPageData = watch(mainPageDataControllerProvider.state);

    searchFieldController = TextEditingController();

    searchFieldController!.text = mainPageData!.searchText;

    selectedMoviePosterURL = watch(selectedMoviePosterURLProvider);
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            backgroundWidget(),
            foregroundWidget(),
          ],
        ),
      ),
    );
  }

  Widget backgroundWidget() {
    if (selectedMoviePosterURL.state != null) {
      return Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(selectedMoviePosterURL.state),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.2),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: deviceHeight,
        width: deviceWidth,
        color: Colors.black,
      );
    }
  }

  Widget foregroundWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, deviceHeight! * 0.02, 0, 0),
      width: deviceWidth! * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          topBarWidget(),
          Container(
            height: deviceHeight! * 0.83,
            padding: EdgeInsets.symmetric(vertical: deviceHeight! * 0.01),
            child: movieslistViewWidget(),
          ),
        ],
      ),
    );
  }

  Widget topBarWidget() {
    return Container(
      height: deviceHeight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: searchFieldWidget(),
          ),
          Flexible(
            child: categorySelectionWidget(),
          ),
        ],
      ),
    );
  }

  Widget searchFieldWidget() {
    const border = InputBorder.none;
    return Container(
      width: deviceWidth! * 0.50,
      height: deviceHeight! * 0.05,
      child: TextField(
        controller: searchFieldController,
        onSubmitted: (input) => mainPageDataController!.updateTextSearch(input),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: border,
          border: border,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
          filled: false,
          fillColor: Colors.white24,
          hintText: "Search",
        ),
      ),
    );
  }

  Widget categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: mainPageData!.searchCategory,
      icon: Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (value) => value.toString().isNotEmpty
          ? mainPageDataController!.updateSearchCategory(value as String)
          : null,
      items: [
        DropdownMenuItem(
          value: SearchCategory.popular,
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.upcoming,
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget movieslistViewWidget() {
    final List<Movie> movies = mainPageData!.movies;

    if (movies.isNotEmpty) {
      return NotificationListener(
        onNotification: (onScrollNotification) {
          if (onScrollNotification is ScrollEndNotification) {
            final before = onScrollNotification.metrics.extentBefore;
            final max = onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              mainPageDataController!.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int count) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: deviceHeight! * 0.01,
                  horizontal: 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    selectedMoviePosterURL.state = movies[count].posterURL();
                  },
                  child: MovieTile(
                    movie: movies[count],
                    height: deviceHeight! * 0.20,
                    width: deviceWidth! * 0.85,
                  ),
                ),
              );
            }),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
