import 'package:covidtrack/main.dart';
import 'package:flutter/material.dart';

class PseudoAppBar extends StatefulWidget {
  final String textTop;
  final String textBottom;
  final double offset;
  const PseudoAppBar({Key key, this.textTop, this.textBottom, this.offset})
      : super(key: key);

  @override
  _PseudoAppBarState createState() => _PseudoAppBarState();
}

class _PseudoAppBarState extends State<PseudoAppBar> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 50, right: 20),
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F),
            ],
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/virus.png"),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 20 - widget.offset / 2,
                    // left: MediaQuery.of(context).size.width / 2 - 130,
                    child: Text(
                      "${widget.textTop} \n${widget.textBottom}",
                      textAlign: TextAlign.center,
                      style: kHeadingTextStyle.copyWith(
                        fontSize: 28.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
