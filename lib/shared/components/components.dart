// import 'package:flutter/material.dart';


// Widget baseAlertDialog({
//   required context,
//   String? title,
//   String? content,
//   String? outlinedButtonText,
//   String? elevatedButtonText,
//   IconData? elevatedButtonIcon,
// }) {
//   return AlertDialog(
//     backgroundColor: SocialCubit.get(context).isDark
//         ? ColorManager.titanWithColor
//         : ColorManager.greyDarkColor,
//     content: Padding(
//       padding: const EdgeInsetsDirectional.only(
//           start: AppPadding.p16, top: AppPadding.p16),
//       child: Text(
//         AppString.deleteMessage,
//         style: Theme.of(context).textTheme.titleLarge,
//       ),
//     ),
//     elevation: 8,
//     contentPadding: const EdgeInsets.all(AppPadding.p16),
//     actions: [
//       TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(AppString.deleteForEveryOne);
//           },
//           child: const Text(AppString.deleteForEveryOne)),
//       TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(AppString.deleteForMe);
//           },
//           child: const Text(AppString.deleteForMe)),
//       TextButton(
//           onPressed: () {
//             pop(context);
//           },
//           child: const Text(AppString.cancel)),
//     ],
//   );
// }
