import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../main.dart';

class InfoView extends StatelessWidget {
  const InfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget title = const Text(
      'Flutter Animation',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 40,
        color: Color(0xFF666870),
        height: 1,
        letterSpacing: -1,
      ),
    );

    // here's an interesting little trick, we can nest Animate to have
    // effects that repeat and ones that only run once on the same item:
    title = title
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
        .slide();

    List<Widget> tabInfoItems = [
      for (final tab in FlutterAnimateExample.tabs)
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(tab.icon, color: const Color(0xFF80DDFF)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tab.description,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )
    ];

    // Animate all of the info items in the list:
    tabInfoItems = tabInfoItems
        .animate(interval: 600.ms)
        .fadeIn(duration: 6900.ms, delay: 300.ms)
        .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad);

    List<String> scrollingItems = List.generate(20, (index) => 'Item → ${index + 1}');

    // create the ScrollController for info view:
    ScrollController scrollController = ScrollController();

    // Add piano animation to the list of widgets
    Widget pianoAnimation = const Text('️🎹', style: TextStyle(fontSize: 100))
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
        .shake(hz: 3.5, rotation: 0.15); // wobble a bit

// Modify the existing ListView to use the scrollController
    return ListView(
      padding: const EdgeInsets.all(24),
      controller: scrollController,
      children: [
        title,
        hr,
        const Text('''The app shows off some of the features of Flutter Animate.

Check out the Source Code in the tweet.'''),
        hr,
        ...tabInfoItems,
        hr,

        Padding(
          padding: const EdgeInsets.only(top: 16), // Add desired padding
          child: const Text('Watch out!!!'),
        ),


        SizedBox(height: 0), // Add a separator (optional)

        // // Add the piano animation widget
        // pianoAnimation,

        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 16), // Add desired padding
          child: pianoAnimation,
        ),


        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: scrollingItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                scrollingItems[index],
                style: TextStyle(fontSize: 16, color: Color(0xFF80DDFF)),
              ),
            );
          },
        ),
      ],
    );
  }
  Widget get hr => Container(
    height: 2,
    color: const Color(0x8080DDFF),
    margin: const EdgeInsets.symmetric(vertical: 16),
  ).animate().scale(duration: 600.ms, alignment: Alignment.centerLeft);
}