import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdapterView extends StatelessWidget {
  const AdapterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    // example of driving an animation with a ValueNotifier

    // create the ValueNotifier:
    ValueNotifier<double> notifier = ValueNotifier(0);

    // create the ScrollController:
    ScrollController scrollController = ScrollController();

    // create some dummy items for the list:
    List<Widget> items = [
      const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Text(
          'Keep scrolling ...',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24, color: Colors.black),
        ),
      )
    ];

    for (int i = 0; i < 26; i++) {
      items.add(Text('Item X $i', style: const TextStyle(height: 2.5)));
    }

    // layer the indicators & rocket behind the list, and assign the
    // the animations (via ScrollAdapter), and the list:
    Widget list = Stack(
      children: [
        // background color:
        Container(color: const Color(0xFFFFFFFF)),

        // top indicator:
        Container(
          height: 64,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x40000000), Color(0x0080DDFF)]),
          ),
        )
            .animate(
              adapter: ScrollAdapter(
                scrollController,
                end: 500, // end 500px into the scroll
              ),
            )
            .scaleY(alignment: Alignment.topCenter),

        // bottom indicator:
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 64,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFF000000), Color(0xFFFFFF)],
              ),
            ),
          )
              .animate(
                adapter: ScrollAdapter(
                  scrollController,
                  begin: -500, // begin 500px before the end of the scroll
                ),
              )
              .scaleY(alignment: Alignment.bottomCenter, end: 0),
        ),


        // the list (with the scrollController assigned):
// the updated list (with the scrollController assigned):
        ListView.builder(
          padding: const EdgeInsets.all(24.0),
          controller: scrollController,
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return items[index]; // display the first item (title)
            }

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: const Color(0xFF000000),
              ),
              child: Text(
                'Item → ${index - 1}',
                style: const TextStyle(height: 1.5, fontSize: 16, color: Colors.white),
              ),
            );
          },
        ),


        // piano:
        const Text('️🎹', style: TextStyle(fontSize: 100))
            .animate(
          adapter: ScrollAdapter(
            scrollController,
            animated: true, // smooth the scroll input
          ),
        )
            .scaleXY(end: 0.5, curve: Curves.easeIn)
            .fadeOut()
            .custom(
          // custom animation to move it via Align
          begin: -1,
          builder: (_, value, child) => Align(
            alignment: Alignment(value, -value),
            child: child,
          ),
        )
            .shake(hz: 3.5, rotation: 0.15), // wobble a bit
      ],
    );

    return Column(
      children: [
        Flexible(child: list),
      ],
    );
  }
}
