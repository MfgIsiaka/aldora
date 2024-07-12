import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rolanda/src/actions/common_actions.dart';
import 'package:rolanda/src/constants/base_styles.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/models/models.dart';
import 'package:rolanda/src/views/hotel_details_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HotelListView extends StatefulWidget {
  bool loading;
  ScrollController scrollController;

  HotelListView(this.loading, this.scrollController, {super.key});

  @override
  State<HotelListView> createState() => _HotelListViewState();
}

class _HotelListViewState extends State<HotelListView> {
  bool? _loading;
  late ScrollController _scrollController;
  bool _loadingMore = false;
  void _fetchMore() {
    setState(() {
      _loadingMore = true;
    });
    Future.delayed(Duration(seconds: 7), () {
      hotels.addAll(hotels.toList().sublist(0, 10));
      setState(() {
        _loadingMore = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = widget.scrollController;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _loading = widget.loading;
    print(_loading);
    return SliverList.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          Hotel hotel = hotels[index];
          int img = int.parse((index + 1).toString().split("").last);
          if (img == 0) {
            img = 11;
          }
          return GestureDetector(
            onTap: _loading!
                ? () {}
                : () =>
                    commonActions.shiftPage(context, HotelDetailsPage(hotel)),
            child: AbsorbPointer(
              child: Skeletonizer(
                enabled: _loading! ? true : false,
                containersColor: lightGray,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5, left: 2, right: 2),
                      padding: EdgeInsets.all(2),
                      height: 130,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(blurRadius: 2)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 1.4 * 130,
                            height: 130,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(blurRadius: 0.4, color: blackColor)
                                ],
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/hotel_images/${img}.jpg'))),
                          ),
                          Expanded(
                            child: SizedBox.expand(
                              child: Container(
                                padding: EdgeInsets.all(3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotel.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 13,
                                        ),
                                        Expanded(
                                          child: Text(
                                            hotel.street,
                                            maxLines: 1,
                                            style: TextStyle(color: mediumGray),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Tsh${hotel.price}/=",
                                          style: baseTxtStyle.copyWith(
                                              color: primaryBlue),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 13,
                                              color: orangeColor,
                                            ),
                                            Text(
                                              "4.5",
                                              style: baseTxtStyle.copyWith(
                                                  fontSize: 12),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    _loadingMore == true && (index == (hotels.length - 1))
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator()))
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
