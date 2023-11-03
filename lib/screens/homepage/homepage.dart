import 'package:employee_forums/screens/homepage/widget/infinite_scroll_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("DEMO APP"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notification_add_outlined))
        ],
      ),
      backgroundColor: Color(0XFFC6C4C4),
      body: Column(
        children: [
          SizedBox(height: 5,),
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
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 10,),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search messages"
                                  ),
                                ),
                              )
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
          Expanded(child: InfiniteScrollingWidget())
        ],
      ),
    );
  }
}
