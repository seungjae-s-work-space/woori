// import 'package:woori/utils/localization_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// /// 비밀번호 찾기 버튼 위젯
// class FindPwButton extends StatelessWidget {
//   /// FindPwButton 생성자
//   const FindPwButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return TextButton(
//       style: TextButton.styleFrom(
//         /// textButton 내부 패딩제거 -> 줄맞춤
//         padding: EdgeInsets.zero,
//       ),
//       onPressed: () {
//         context.push('/forget-password');
//       },
//       child: Text(
//         context.l10n.button_text_find_password,
//         style: theme.textTheme.bodyLarge?.copyWith(
//           color: theme.colorScheme.secondary,
//         ),
//       ),
//     );
//   }
// }
