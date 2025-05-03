import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

PreferredSizeWidget buildAppBarContent(
    BuildContext context, double widthMul, String title,
    {int? index}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(60 * widthMul),
    child: Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
      child: AppBar(
        backgroundColor: const Color(0xffffffff),
        scrolledUnderElevation: 0,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 30 * widthMul,
            fontWeight: FontWeight.w500,
            color: const Color(0xff1E1E1E),
          ),
        ),
        actions: <Widget>[
          index == 0
              ? IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.go('/camera');
                  },
                )
              : SizedBox()
        ],
        centerTitle: false,
      ),
    ),
  );
}
/**
 *       appBar: AppBar(
        title: Text(context.l10n.meal_log_screen_title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/camera');
            },
          ),
        ],
      ),

 */
