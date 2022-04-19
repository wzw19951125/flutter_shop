import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/config/config.dart';
import 'package:flutter_shop/model/shop_list_model.dart';
import 'package:flutter_shop/widget/cached_image.dart';
import 'package:flutter_shop/widget/show_toast.dart';

class ShopListPage extends StatefulWidget {
  final Map arguments;
  ShopListPage(this.arguments);

  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  List _headerList = [
    {"id": 0, "title": "综合", "s1": "all", "s2": -1},
    {"id": 1, "title": "销量", "s1": "salecount", "s2": -1},
    {"id": 2, "title": "价格", "s1": "price", "s2": -1},
    {"id": 3, "title": "综合"},
  ];

  List<ShopListItemModel> _shopListData = [];

  ScrollController _scrollController = ScrollController();

  int _page = 1;

  int _pageSize = 8;

  bool _hasMore = true;

  bool _hasData = true;

  bool _isLoading = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _sort = "";

  int _selectIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getShopListData();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (dis < 100 && !_isLoading && _hasMore) {
        _getShopListData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SafeArea(
        child: Drawer(
          child: Text("筛选功能"),
        ),
      ),
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          Container(),
        ],
      ),
      body: _hasData
          ? Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _shopListData.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black26),
                                ),
                              ),
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: cachedImage(
                                        "${Config.DOMAIN}${_shopListData[index].pic.replaceAll("\\", "/")}"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${_shopListData[index].title}",
                                        ),
                                        Text(
                                          "￥${_shopListData[index].price}",
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _showLoading(index),
                          ],
                        );
                      }),
                ),
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: Row(
                      children: _headerList.map((e) {
                        return Expanded(
                            child: InkWell(
                          onTap: () {
                            _changeHeader(e["id"]);
                          },
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  e["title"],
                                  style: TextStyle(
                                      color: _selectIndex == e["id"]
                                          ? Colors.red
                                          : Colors.black),
                                ),
                                showIcon(e["id"], _selectIndex == e["id"]),
                              ],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                          ),
                        ));
                      }).toList(),
                    ),
                  ),
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 50,
                )
              ],
            )
          : Center(
              child: Text("没有您要浏览的数据"),
            ),
    );
  }

  showIcon(int id, bool currentColor) {
    if (id == 1 || id == 2) {
      return _headerList[id]["s2"] == -1
          ? Icon(
              Icons.arrow_downward_outlined,
              size: 15,
              color: currentColor ? Colors.red : Colors.black,
            )
          : Icon(
              Icons.arrow_upward_outlined,
              size: 15,
              color: currentColor ? Colors.red : Colors.black,
            );
    } else {
      return Text("");
    }
  }

  void _getShopListData() async {
    setState(() {
      _isLoading = true;
    });

    var api =
        "${Config.DOMAIN}api/plist?cid=${widget.arguments["sid"]}&page=$_page&pageSize=$_pageSize&sort=$_sort";
    print(api);

    var response = await Dio().get(api);
    var data = ShopListModel.fromJson(response.data);

    if (data.result.isEmpty && _page == 1) {
      _hasData = false;
    } else {
      _hasData = true;
    }

    if (data.result.length < _pageSize) {
      _hasMore = false;
    } else {
      _hasMore = true;
    }

    if (_hasMore) {
      setState(() {
        _page++;
        _shopListData.addAll(data.result);
        _isLoading = false;
      });
    } else {
      setState(() {
        _shopListData.addAll(data.result);
        _isLoading = false;
      });
    }
  }

  void _changeHeader(int index) {
    if (index == 3) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      _selectIndex = index;
      _shopListData.clear();
      _page = 1;
      _headerList[index]["s2"] *= -1;
      _sort = "${_headerList[index]["s1"]}_${_headerList[index]["s2"]}";
      !_isLoading ? _getShopListData() : showWarnToast("不能一直请求");
    }
  }

  _showLoading(int index) {
    if (_hasMore) {
      return index == _shopListData.length - 1
          ? Container(
              height: 30,
              child: Center(child: Text("---加载中---")),
            )
          : Container();
    } else {
      return index == _shopListData.length - 1
          ? Container(
              height: 30,
              child: Center(child: Text("---我是有底线的---")),
            )
          : Container();
    }
  }
}
