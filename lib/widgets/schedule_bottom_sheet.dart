import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatelessWidget {
  final String title;
  final Widget? child;
  final Widget? button;
  final bool isTwoButton;
  final Function()? buttonOnPressed;
  final Function()? buttonOnPressedForDelete;

  const ScheduleBottomSheet(
      {Key? key,
      required this.title,
      this.child,
      this.button,
      this.buttonOnPressed,
      this.buttonOnPressedForDelete,
        this.isTwoButton = false
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    textAlign: TextAlign.start,
                    style:
                        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF4F4F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0) +
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
        !isTwoButton ?
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(700, 50),
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
          onPressed: buttonOnPressed,
          child: button,
        ) :
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(205, 50),
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: buttonOnPressedForDelete,
              child: Text(
                '삭제',
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(205, 50),
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: buttonOnPressed,
              child: button,
            ),
          ],
        )

      ],
    );
  }
}
