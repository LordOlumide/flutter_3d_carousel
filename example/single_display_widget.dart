import 'package:_3d_carousel/flutter_3d_carousel.dart';
import 'package:flutter/material.dart';

class SingleDisplayWidget extends StatelessWidget {
  final Color backgroundColor;
  final String assetPath;
  final Function onForwardPressed;
  final Function onBackPressed;

  const SingleDisplayWidget({
    super.key,
    required this.backgroundColor,
    required this.assetPath,
    required this.onForwardPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(assetPath),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.white, width: 5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => onBackPressed(),
                  icon: Icon(Icons.arrow_back, size: 30),
                  color: UtilFunctions.getReverseContrastingColor(
                    backgroundColor,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      UtilFunctions.getContrastingColor(backgroundColor),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => onForwardPressed(),
                  icon: Icon(Icons.arrow_forward, size: 30),
                  color: UtilFunctions.getReverseContrastingColor(
                    backgroundColor,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      UtilFunctions.getContrastingColor(backgroundColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Lorem ipsum dolor sit amet',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: UtilFunctions.getContrastingColor(backgroundColor),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Suspendisse augue libero, condimentum ut vestibulum vitae, '
              'gravida nec sem. Suspendisse sit amet rutrum lacus, et '
              'varius enim',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: UtilFunctions.getContrastingColor(backgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
