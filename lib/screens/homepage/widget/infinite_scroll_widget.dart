import 'package:carousel_slider/carousel_slider.dart';
import 'package:employee_forums/screens/homepage/models/post_model.dart';
import 'package:employee_forums/screens/homepage/widget/seemore_text.dart';
import 'package:flutter/material.dart';
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
  int currentPage = 1;

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
    final url = Uri.parse(
        'https://post-api-omega.vercel.app/api/posts?page=${currentPage}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      for (var data in jsonData) {
        PostModel value = PostModel.fromJson(data);
        posts.add(value);
      }
      setState(() {
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == posts.length) {
          return Center(
            child:
                CircularProgressIndicator(), // Show a loading indicator at the end
          );
        }
        // Build your list items using data from the 'posts' list
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
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
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.more_horiz)
                      ],
                    ),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: false, // Disable infinite scrolling
                    autoPlay: false, // Disable auto-play
                    enableInfiniteScroll: false,
                  ),
                  items: posts[index].image?.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(i));
                      },
                    );
                  }).toList(),
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpandableText(
                                text: posts[index].description ?? "", max: 0.4),
                          )),
                    ),
                  ],
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/Vector.png"),

                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              posts[index].likes.toString()+" Likes",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/Icon.png"),
                            SizedBox(
                              width: 5,
                            ),
                            Text((posts[index].comments?.length ?? 0)
                                .toString()+" Comments",style: TextStyle(
                              color: Colors.grey.shade500,
                            ),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/Icon-1.png"),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Share",style: TextStyle(
                              color: Colors.grey.shade500,
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: posts.length + 1, // +1 for the loading indicator
    );
  }
}
