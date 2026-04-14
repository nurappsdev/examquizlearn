//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
//
// import '../../utils/utils.dart';
//
// class CustomPinCodeTextField extends StatelessWidget {
//   const CustomPinCodeTextField({super.key, this.textEditingController,
//     this.onCompleted,
//   });
//   final TextEditingController? textEditingController;
//   final Function(String)? onCompleted;
//   @override
//   Widget build(BuildContext context) {
//     return  PinCodeTextField(
//       backgroundColor: Colors.transparent,
//       cursorColor: AppColors.primaryColor,
//       controller: textEditingController,
//       textStyle:  TextStyle(color: AppColors.textColor4E4E4E, fontSize: 16.sp, fontFamily:"ComicNeue-Light",fontWeight: FontWeight.w400),
//       autoFocus: false,
//       appContext: context,
//       scrollPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
//       length: 6,
//       pinTheme: PinTheme(
//         shape: PinCodeFieldShape.box,
//         borderRadius: BorderRadius.circular(6.r),
//         fieldHeight: 50.h,
//         fieldWidth: 50.h,
//         activeColor: AppColors.primaryColor,
//         inactiveColor: Color(0xffE8F1EE),
//         selectedColor: AppColors.primaryColor,
//         activeFillColor: AppColors.primaryColor.withOpacity(0.1),
//         inactiveFillColor: AppColors.primaryColor.withOpacity(0.1),
//         selectedFillColor: AppColors.primaryColor.withOpacity(0.1),
//       ),
//       enableActiveFill: true,
//       obscureText: false,
//       keyboardType: TextInputType.number,
//       onChanged: (value) {},
//       onCompleted: (value) {
//         if (onCompleted != null) {
//           onCompleted!(value);   // 👈 AUTO VERIFY HERE
//         }
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utils/utils.dart';


class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({
    super.key,
    this.textEditingController,
    this.onCompleted,
    this.activeColor,
    this.inactiveColor,
    this.selectedColor,
    this.activeFillColor,
    this.inactiveFillColor,
    this.selectedFillColor,
    this.textColor,
  });

  final TextEditingController? textEditingController;
  final Function(String)? onCompleted;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? selectedColor;
  final Color? activeFillColor;
  final Color? inactiveFillColor;
  final Color? selectedFillColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: textEditingController,
      autoDisposeControllers: false,
      length: 6,
      autoFocus: false,
      enableActiveFill: true,
      keyboardType: TextInputType.number,

      textStyle: TextStyle(
        color: textColor ?? AppColors.textColor4E4E4E,
        fontSize: 16.sp,
      ),

      // ⭐ REQUIRED FOR PASTE TO WORK
      beforeTextPaste: (text) {
        return true; // Allow paste
      },

      // ⭐ REQUIRED: Don’t block paste by formatters
      inputFormatters: [],

      onChanged: (value) {
        // keep empty
      },

      onCompleted: (value) {
        if (onCompleted != null) {
          onCompleted!(value);
        }
      },

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8.r),
        fieldHeight: 56.h,
        fieldWidth: 45.w,
        activeColor: activeColor ?? AppColors.primaryColor,
        inactiveColor: inactiveColor ?? const Color(0xffE8F1EE),
        selectedColor: selectedColor ?? AppColors.primaryColor,
        activeFillColor: activeFillColor ?? AppColors.primaryColor.withOpacity(0.1),
        inactiveFillColor: inactiveFillColor ?? AppColors.primaryColor.withOpacity(0.1),
        selectedFillColor: selectedFillColor ?? AppColors.primaryColor.withOpacity(0.1),
      ),
    );
  }
}

