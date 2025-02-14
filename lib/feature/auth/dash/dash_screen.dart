import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:woori/utils/image_generated/assets.gen.dart';
import 'package:woori/utils/localization_extension.dart';

class DashScreen extends StatelessWidget {
  const DashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Image.asset(
            //   'assets/images/dash/appLogo.png',
            //   height: 200,
            //   width: 200,
            // ),
            Assets.images.dash.appLogo.image(width: 200),
            Assets.images.dash.appLogoCharacter.image(width: 143),
            Center(
                child: GestureDetector(
              onTap: () {
                context.push('/login');
              },
              child: Container(
                  decoration: BoxDecoration(color: Color(0xff545454)),
                  child: Text(
                    context.l10n.button_text_login,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
            )
                // child: TextButton(
                //     onPressed: () {
                //       context.push('/login');
                //     },
                //     child: Text(context.l10n.button_text_login)),
                )
          ],
        ),
      ),
    );
  }
}
