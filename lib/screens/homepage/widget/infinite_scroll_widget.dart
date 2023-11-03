import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:employee_forums/helpers/database_helper.dart';
import 'package:employee_forums/screens/homepage/models/post_model.dart';
import 'package:employee_forums/screens/homepage/widget/seemore_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfiniteScrollingWidget extends StatefulWidget {
  @override
  _InfiniteScrollingWidgetState createState() =>
      _InfiniteScrollingWidgetState();
}

class _InfiniteScrollingWidgetState extends State<InfiniteScrollingWidget> {
  ScrollController _scrollController = ScrollController();
  List<PostModel> posts = [];
  List<PostModel> displayPosts = [];
  int currentPage = 1;
  Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more data when the user reaches the bottom of the list
      fetchPosts();
    }
  }

  Future<void> fetchPosts() async {
    final hasInternet = await isInternetConnected();
    print(hasInternet);
    print(currentPage);
    if (hasInternet) {
      final url = Uri.parse(
          'https://post-api-omega.vercel.app/api/posts?page=${currentPage}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Map<String, dynamic>> dataList = [];
        for (var data in jsonData) {
          PostModel value = PostModel.fromJson(data);
          dataList.add(data);
          posts.add(value);
        }
        // Save fetched posts to the local database
        if(jsonData!=[]) {
          savePostsLocally(dataList);
        }
        setState(() {
          currentPage++;
        });
      }
    } else {
      // No internet connection, load posts from the local database
      final db = DatabaseHelper.instance;
      final localPosts = await db.getPosts();
      posts.clear();
      for (var data in localPosts) {
        PostModel value = PostModel.fromJson(data);
        posts.add(value);
      }
      setState(() {
        currentPage++;
      });
    }
    setState(() {
      displayPosts = posts;

    });
  }

  Future<void> savePostsLocally(List<Map<String, dynamic>> posts) async {
    final db = DatabaseHelper.instance;
    posts.forEach((post) async {
      await db.insertPost(post);
    });
  }

  String query = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0XFFEBF2FA),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                onChanged: (String newVal) {
                                  setState(() {
                                    query = newVal;
                                  });
                                  displayPosts = posts.where((element) {
                                    return element.title!.contains(query) ||
                                        element.description!.contains(query) ||
                                        element.eventCategory!.contains(query);
                                  }).toList();
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search messages"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Image.asset('assets/icons/filter.png')
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == displayPosts.length) {
                return Center(
                  child:
                      CircularProgressIndicator(), // Show a loading indicator at the end
                );
              }
              // Build your list items using data from the 'displayPosts' list
              return PostsWidget(index);
            },
            itemCount: displayPosts.length + 1, // +1 for the loading indicator
          ),
        ),
      ],
    );
  }

  bool comments = false;

  Padding PostsWidget(int index) {
    TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Image.asset('assets/Avatar.png'),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Arneo Paris",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Arneo",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.more_horiz)
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ))
              ],
            ),
            CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: false, // Disable infinite scrolling
                autoPlay: false, // Disable auto-play
                enableInfiniteScroll: false,
              ),
              items: displayPosts[index].image?.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          i,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Image is fully loaded.
                              return child;
                            } else {
                              // While the image is loading, you can display a loading indicator.
                              return CircularProgressIndicator();
                            }
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            // If the network image fails to load, display a default/fallback image.
                            return Image.asset(
                                'assets/no-internet.png'); // Replace with your default image asset path.
                          },
                        ));
                  },
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.grey.shade200,
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpandableText(
                            text: displayPosts[index].description ?? "",
                            max: 0.4),
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.grey.shade400,
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          displayPosts[index].likePost();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          displayPosts[index].liked
                              ? Image.asset(
                                  "assets/icons/Vector.png",
                                  color: Colors.red,
                                )
                              : Image.asset(
                                  "assets/icons/Vector.png",
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            displayPosts[index].likes.toString() + " Likes",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          comments = !comments;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/Icon.png"),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            (displayPosts[index].comments?.length ?? 0)
                                    .toString() +
                                " Comments",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await FlutterShare.share(
                          title: displayPosts[index].title ?? "",
                          text: displayPosts[index].description ?? "",
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/Icon-1.png"),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Share",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (comments)
              (displayPosts[index].comments?.length == 0)
                  ? Text("No comments found")
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: displayPosts[index].comments?.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.account_circle),
                              Expanded(
                                  child: Text(displayPosts[index]
                                          .comments
                                          ?.elementAt(i)["text"] ??
                                      "")),
                              Icon(Icons.thumb_up_outlined),
                            ],
                          ),
                        );
                      }),
            Row(
              children: [
                Icon(Icons.comment),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Add Comment"),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        displayPosts[index].addComment(controller.text);
                      });
                    },
                    icon: Icon(Icons.send))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
