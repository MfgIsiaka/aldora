import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rich_readmore/rich_readmore.dart';
import 'package:rolanda/main.dart';
import 'package:rolanda/src/constants/base_styles.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/models/models.dart';

class HotelDetailsPage extends StatefulWidget {
  Hotel hotel;
  HotelDetailsPage(this.hotel, {super.key});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  late Hotel _hotel;
  List _aminities = [
    {'icon': FontAwesomeIcons.waterLadder, 'name': 'Swimming pool'},
    {'icon': FontAwesomeIcons.shower, 'name': 'Shower'},
    {'icon': FontAwesomeIcons.airFreshener, 'name': 'AC'},
    {'icon': FontAwesomeIcons.wifi, 'name': 'Wifi'},
    {'icon': FontAwesomeIcons.shield, 'name': 'Security'},
    {'icon': FontAwesomeIcons.swimmingPool, 'name': 'swimming pool'},
    {'icon': FontAwesomeIcons.swimmingPool, 'name': 'swimming pool'},
    {'icon': FontAwesomeIcons.swimmingPool, 'name': 'swimming pool'},
    {'icon': FontAwesomeIcons.swimmingPool, 'name': 'swimming pool'}
  ];
  String description =
      '''Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The firs''';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hotel = widget.hotel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                print("Pinting image");
              },
              child: AbsorbPointer(
                child: Container(
                  height: screenSize.height * 0.35,
                  decoration: BoxDecoration(
                      color: lightGray,
                      image: DecorationImage(
                          image: AssetImage("assets/hotel_images/10.jpg"),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: () {
                      print("Pinting box");
                    },
                    child: AbsorbPointer(
                      child: Container(
                        margin: EdgeInsets.only(top: screenSize.height * 0.27),
                        height: 10,
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: _SliverPersistentHeaderDelegate(
                        child: SafeArea(
                          child: Container(
                            //margin: EdgeInsets.only(top: screenSize.height * 0.3),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                boxShadow: [BoxShadow(blurRadius: 10)],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: SafeArea(
                              top: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "DETAILS",
                                      style: textTheme.bodyLarge!
                                          .merge(baseTxtStyle),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dodoma hotel",
                                          style: textTheme.titleLarge!
                                              .merge(baseTxtStyle),
                                        ),
                                        Container(
                                          //color: Colors.red,
                                          child: ListTile(
                                            minVerticalPadding: 0,
                                            //dense: true,
                                            visualDensity: VisualDensity(
                                                horizontal: -3, vertical: -4),
                                            contentPadding: EdgeInsets.all(0),
                                            title: Text("${_hotel.street}"),
                                            subtitle: RatingBar.readOnly(
                                              filledIcon: Icons.star,
                                              size: 20,
                                              emptyIcon: Icons.star_border,
                                              initialRating: 4,
                                              maxRating: 5,
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.location_on,
                                                  size: 35,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Amenities ",
                                          style: baseTxtStyle.copyWith(
                                              fontSize: 22),
                                        ),
                                        GridView.builder(
                                            controller: ScrollController(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    mainAxisExtent: 50,
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 2),
                                            itemCount: _aminities.length,
                                            itemBuilder: (context, index) {
                                              var amenity = _aminities[index];
                                              return Container(
                                                // height: 100,
                                                // width: 100,
                                                color: Colors.black12,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    FaIcon(amenity['icon']),
                                                    Text(
                                                      amenity['name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: baseTxtStyle,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Description",
                                          style: baseTxtStyle.copyWith(
                                              fontSize: 22),
                                        ),
                                        RichReadMoreText.fromString(
                                          text: description,
                                          settings: LengthModeSettings(
                                            trimLength: 250,
                                            trimCollapsedText: ' Read more ',
                                            trimExpandedText: ' Read less ',
                                            onPressReadMore: () {
                                              /// specific method to be called on press to show more
                                            },
                                            onPressReadLess: () {
                                              /// specific method to be called on press to show less
                                            },
                                            lessStyle: TextStyle(
                                                color: primaryBlue,
                                                fontWeight: FontWeight.bold),
                                            moreStyle: TextStyle(
                                                color: primaryBlue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 108,
                                    child: ListView.builder(
                                        itemCount: 5,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            height: 100,
                                            width: 100 * (16 / 9),
                                            margin: EdgeInsets.only(
                                                right: 5, top: 4, bottom: 4),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(blurRadius: 2)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/hotel_images/${index + 1}.jpg'),
                                                    fit: BoxFit.cover)),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        minHeight:
                            screenSize.height - (screenSize.height * 0.3),
                        maxHeight: screenSize.height)),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: whiteColor),
                  onPressed: () {},
                  child: Text("Book now"))
            ],
          ),
        ));
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
