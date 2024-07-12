import 'package:flutter/material.dart';
import 'package:rolanda/main.dart';
import 'package:rolanda/src/actions/common_actions.dart';
import 'package:rolanda/src/constants/base_styles.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/models/models.dart';
import 'package:rolanda/src/views/common_views/hotel_list_view.dart';
import 'package:rolanda/src/views/hotel_details_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scrollController = ScrollController();
  bool _loading = true;
  List<String> _catecogories = ["All", "Hotel", "Lodge", "Apartment"];
  int _currentCategory = 0;
  int lastHotel = 10;

  void _initLoading() {
    setState(() {
      _loading = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: whiteColor,
            title: Text(
              'Rolanda',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
            ),
            actions: [
              Container(
                  margin: EdgeInsets.only(right: 5),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(
                    Icons.notifications_active,
                    size: 30,
                  ))
            ],
          ),
          Expanded(
              child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                    //height: 100,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover your',
                      style: textTheme.titleLarge!.copyWith(color: mediumGray),
                    ),
                    Text(
                      'Perfect place to stay',
                      style: textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                  ],
                )),
              ),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverPersistentHeaderDelegate(
                      child: Column(
                        children: [
                          Container(
                            height: 43,
                            decoration: BoxDecoration(
                                boxShadow: [BoxShadow(blurRadius: 2)],
                                borderRadius: BorderRadius.circular(40),
                                color: whiteColor),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "Search hotel",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide()),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.filter_list_outlined))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 35,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _catecogories.length,
                                itemBuilder: (context, ind) {
                                  String text = _catecogories[ind];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _currentCategory = ind;
                                        _initLoading();
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: ind == _currentCategory
                                            ? darkBlue
                                            : lightGray,
                                        boxShadow: [BoxShadow(blurRadius: 2)],
                                        borderRadius: BorderRadius.circular(
                                            ind == _currentCategory ? 10 : 50),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Center(
                                          child: Text(
                                        text,
                                        style: TextStyle(
                                            color: ind == _currentCategory
                                                ? whiteColor
                                                : Colors.black45,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      minHeight: 83,
                      maxHeight: 83)),
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nearby",
                            style: baseTxtStyle.copyWith(fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            child: Text(
                              "See all",
                              style: baseTxtStyle,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 134,
                        child: ListView.builder(
                            itemCount: hotels.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              Hotel hotel = hotels[index];
                              return GestureDetector(
                                onTap: _loading
                                    ? () {}
                                    : () => commonActions.shiftPage(
                                        context, HotelDetailsPage(hotel)),
                                child: AbsorbPointer(
                                  child: Skeletonizer(
                                    enabled: _loading,
                                    containersColor: lightGray,
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Container(
                                          width: (16 / 9) * 130,
                                          margin: EdgeInsets.only(
                                              right: 5,
                                              bottom: 2,
                                              top: 2,
                                              left: 2),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              boxShadow: [
                                                BoxShadow(blurRadius: 3)
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: _loading
                                                  ? null
                                                  : DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/hotel_images/${index + 1}.jpg'))),
                                          child: null,
                                        ),
                                        Container(
                                          width: (16 / 9) * 130 * 0.7,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 3),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                hotel.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: baseTxtStyle.copyWith(
                                                    color: whiteColor),
                                              ),
                                              Text(
                                                "Tsh${hotel.price}/=",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: baseTxtStyle.copyWith(
                                                    color: whiteColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Other",
                            style: baseTxtStyle.copyWith(fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            child: Text(
                              "See all",
                              style: baseTxtStyle,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
              HotelListView(_loading, _scrollController)
            ],
          ))
        ],
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  final Widget child;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverPersistentHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight;
  }
}
