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
      body: InfiniteScrollingWidget(),
    );
  }
}
