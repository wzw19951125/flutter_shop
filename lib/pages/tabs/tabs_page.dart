import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/tabs/cart_page.dart';
import 'package:flutter_shop/pages/tabs/category_page.dart';
import 'package:flutter_shop/pages/tabs/home_page.dart';
import 'package:flutter_shop/pages/tabs/user_page.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  late PageController _pageController;

  List<Widget> _pages = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "主页"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "分类"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "购物车"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "我的"),
        ],
        fixedColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        physics: const NeverScrollableScrollPhysics(),
        // onPageChanged: (index){
        //   setState(() {
        //     _currentIndex = index;
        //   });
        // },
      ),
    );
  }
}
