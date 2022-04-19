import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/config/config.dart';
import 'package:flutter_shop/model/categroy_model.dart';
import 'package:flutter_shop/widget/cached_image.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  List<CategoryItemModel> _leftData = [];
  List<CategoryItemModel> _rightData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLeftData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("商品分类"),
      ),
      body: Container(
        child: Row(
          children: [
            _buildLeft(screenWidth / 4),
            _buildRight(screenWidth),
          ],
        ),
      ),
    );
  }

  _buildLeft(double width) {
    return Container(
      width: width,
      child: ListView.builder(
          itemCount: _leftData.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  _getRightData(_leftData[_selectedIndex].sId);
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                child: Text("${_leftData[index].title}"),
                decoration: BoxDecoration(
                  color:
                      _selectedIndex == index ? Colors.grey[300] : Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _getLeftData() async {
    var api = "${Config.DOMAIN}api/pcate";
    print("left_url:$api");

    var response = await Dio().get(api);
    var data = CategoryModel.fromJson(response.data);

    setState(() {
      _leftData = data.result;
    });

    _getRightData(_leftData[0].sId);
  }

  void _getRightData(String sId) async {
    var api = "${Config.DOMAIN}api/pcate?pid=${sId}";
    print("right_url:$api");

    var response = await Dio().get(api);
    var data = CategoryModel.fromJson(response.data);

    setState(() {
      _rightData = data.result;
    });
  }

  _buildRight(double screenWidth) {
    var rightWidth = screenWidth - screenWidth / 4;
    return Container(
      color: Colors.grey[300],
      width: rightWidth,
      padding: EdgeInsets.all(10),
      child: GridView.builder(
          itemCount: _rightData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1.35,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/shop_list",
                  arguments: {"sid": _rightData[index].sId},
                );
              },
              child: Container(
                width: (rightWidth - 40) / 3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: cachedImage(
                          "${Config.DOMAIN}${_rightData[index].pic.replaceAll("\\", "/")}"),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${_rightData[index].title}")
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
