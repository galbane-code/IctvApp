import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class Companies extends StatelessWidget {
  Companies(this.username, {Key key});
  final String username;

  @override
  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ICTV',
        theme:
            ThemeData(brightness: Brightness.dark, primaryColor: Colors.white),
        home: Companies_screen(username),
      ),
    );
  }
}

// ignore: camel_case_types
class Companies_screen extends StatefulWidget {
  Companies_screen(this.username, {Key key}) : super(key: key);
  final String username;

  @override
  _Companies_screenState createState() => _Companies_screenState();
}

// ignore: camel_case_types
class _Companies_screenState extends State<Companies_screen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final CarouselController _controller = CarouselController();
  int _current = 0;
  bool _visible = true;
  bool _visibleTwo = false;
  List<String> imgList = [
    'https://www.malamteam.com/wp-content/uploads/2017/09/yes-logo.png',
    'https://upload.wikimedia.org/wikipedia/ru/4/4f/HOT_Logo.png',
    'https://upload.wikimedia.org/wikipedia/he/thumb/3/3f/Bezeq_logo.svg/442px-Bezeq_logo.svg.png',
    'https://www.leaderim.com/wp-content/uploads/2020/02/Partner-logo-2016.png'
  ];

  var boolList = [
    [false, false, true],
    [true, false, true],
    [true, false, false],
    [true, true, true]
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          child: Image.network(item, fit: BoxFit.fill),
                          onTap: () {
                            if (_visibleTwo) {
                              _visibleTwo = false;
                            } else {
                              _visibleTwo = true;
                            }
                            _visible = false;
                            setState(() {});
                          },
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    final List<Widget> buttoms = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      width: 15.0,
                      height: 15.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == imgList.indexOf(item)
                              ? Colors.white
                              : Color.fromRGBO(0, 0, 0, 0.4)),
                    )),
              ),
            ))
        .toList();

    return SideMenu(
      menu: buildMenu(widget.username, context, _sideMenuKey),
      child: SideMenu(
          background: Color(0xff3FC7DA),
          key: _sideMenuKey,
          menu: buildMenu(widget.username, context, _sideMenuKey),
          type: SideMenuType.slideNRotate,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final _state = _sideMenuKey.currentState;
                    if (_state.isOpened)
                      _state.closeSideMenu();
                    else
                      _state.openSideMenu();
                  },
                ),
              ),
            ),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomPadding: false,
            body: Stack(
              children: <Widget>[
                Image(
                  image: AssetImage("assets/companies_screen.jpg"),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Spacer(flex: 2),
                    Flexible(
                        flex: 2,
                        child: Text(
                          "Compaines Supported",
                          style: GoogleFonts.sansita(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Spacer(),
                    Flexible(
                        flex: 3,
                        child: AnimatedOpacity(
                          opacity: _visible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 1500),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Press on to See \n What The Companies \n Utilities Supported Here",
                                style: GoogleFonts.sansita(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              FaIcon(
                                FontAwesomeIcons.levelDownAlt,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                        )),
                    Spacer(),
                    Flexible(
                      flex: 8,
                      child: CarouselSlider(
                        items: imageSliders,
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            _visibleTwo = false;
                            _visible = true;
                            _current = index;
                            setState(() {});
                          },
                        ),
                        carouselController: _controller,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: buttoms),
                    ),
                    Spacer(),
                    Flexible(
                      flex: 3,
                      child: _visibleTwo
                          ? AnimatedOpacity(
                              opacity: _visibleTwo ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 2500),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.internetExplorer,
                                    color: boolList[_current][0]
                                        ? Colors.lightGreen[400]
                                        : Colors.red,
                                    size: 30,
                                  ),
                                  SizedBox(width: 15),
                                  FaIcon(
                                    FontAwesomeIcons.phone,
                                    color: boolList[_current][1]
                                        ? Colors.lightGreen[400]
                                        : Colors.red,
                                    size: 30,
                                  ),
                                  SizedBox(width: 15),
                                  FaIcon(
                                    FontAwesomeIcons.tv,
                                    color: boolList[_current][2]
                                        ? Colors.lightGreen[400]
                                        : Colors.red,
                                    size: 30,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
