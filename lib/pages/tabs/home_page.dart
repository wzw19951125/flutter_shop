import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/config/config.dart';
import 'package:flutter_shop/model/hot_model.dart';
import 'package:flutter_shop/model/swiper_model.dart';
import 'package:flutter_shop/widget/cached_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<SwiperItemModel> _swiperData = [];

  List<HotItemModel> _hotData = [];
  List<HotItemModel> _likeData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSwiperData();
    _getHotData();
    _getLikeData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            print("搜索");
          },
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "笔记本",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.message),
          )
        ],
      ),
      body: ListView(
        children: [
          _buildSwiper(),
          SizedBox(
            height: 10,
          ),
          _buildTitle("热门推荐"),
          _buildHotList(),
          _buildTitle("猜你喜欢"),
          _buildLikeList(),
        ],
      ),
    );
  }

  _buildSwiper() {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: Swiper(
        autoplay: true,
        loop: false,
        itemCount: _swiperData.length,
        itemBuilder: (context, index) {
          return cachedImage(
              "${Config.DOMAIN}${_swiperData[index].pic.replaceAll("\\", "/")}");
        },
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            size: 6,
            activeSize: 12,
            activeColor: Colors.red,
          ),
        ),
      ),
    );
  }

  void _getSwiperData() async {
    var api = "${Config.DOMAIN}api/focus";
    print("swiper_url: $api");

    var response = await Dio().get(api);
    var data = SwiperModel.fromJson(response.data);

    setState(() {
      _swiperData = data.result;
    });
  }

  _buildTitle(String title) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.red, width: 5))),
      child: Text(title),
    );
  }

  _buildHotList() {
    return Container(
      height: 130,
      padding: EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 10,
      ),
      child: ListView.builder(
          itemCount: _hotData.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
              ),
              child: Column(
                children: [
                  Container(
                    height: 77,
                    width: 70,
                    child: cachedImage(
                        "${Config.DOMAIN}${_hotData[index].pic.replaceAll("\\", "/")}"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 30,
                    child: Text(
                      "￥${_hotData[index].price}",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  _buildLikeList() {
    var itemWidth = (MediaQuery.of(context).size.width - 30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: _likeData.map((e) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black26)),
            width: itemWidth,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: cachedImage(
                      "${Config.DOMAIN}${e.pic.replaceAll("\\", "/")}"),
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text("${e.title}"),
                  alignment: Alignment.topLeft,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "￥${e.price}",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    Text(
                      "￥${e.oldPrice}",
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _getHotData() async {
    var api = "${Config.DOMAIN}api/plist?is_hot=1";
    print("hot_url: $api");

    var response = await Dio().get(api);
    var data = HotModel.fromJson(response.data);

    setState(() {
      _hotData = data.result;
    });
  }

  void _getLikeData() async {
    var api = "${Config.DOMAIN}api/plist?is_best=1";
    print("like_url: $api");

    var response = await Dio().get(api);
    var data = HotModel.fromJson(response.data);

    setState(() {
      _likeData = data.result;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
