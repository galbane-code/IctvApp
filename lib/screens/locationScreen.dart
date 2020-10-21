import 'package:flutter/material.dart';
import 'package:ictv/widgets/buildMenu.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

// ignore: camel_case_types
class locationScreen extends StatelessWidget {
  // ignore: type_init_formals
  const locationScreen(String this.username, {Key key}) : super(key: key);
  final String username;

  Widget build(BuildContext context) {
    return LiquidApp(
      materialApp: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ICTV',
          theme: ThemeData(
              brightness: Brightness.dark, primaryColor: Colors.white),
          home: companeis(username)),
    );
  }
}

// ignore: camel_case_types
class companeis extends StatefulWidget {
  // ignore: type_init_formals
  companeis(String this.username, {Key key}) : super(key: key);
  final String username;

  @override
  _companeisState createState() => _companeisState();
}

// ignore: camel_case_types
class _companeisState extends State<companeis> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  @override
  Widget build(BuildContext context) {
    return SideMenu(
      menu: buildMenu(widget.username, context, _sideMenuKey),
      child: SideMenu(
          background: Color(0xffD1D1CC),
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
                  image: AssetImage("assets/locationBackground.jpg"),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          )),
    );
  }
}
