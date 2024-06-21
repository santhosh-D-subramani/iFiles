import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupMenuButtonWidget extends StatefulWidget {
  const PopupMenuButtonWidget({super.key, required this.childBuilder});

  final Widget Function(VoidCallback hideMenu) childBuilder;

  @override
  State<PopupMenuButtonWidget> createState() => _PopupMenuButtonWidgetState();
}

class _PopupMenuButtonWidgetState extends State<PopupMenuButtonWidget>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position =
        button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size size = button.size;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double menuWidth =
        screenWidth / 1.4; // Dynamic width based on screen width

    // Calculate the left position to ensure the popup menu doesn't go out of screen
    double leftPosition = position.dx;
    if (leftPosition + menuWidth > screenWidth) {
      leftPosition =
          screenWidth - menuWidth - 16; // Adding some padding from right
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hideMenu,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: leftPosition,
                top: position.dy + size.height,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      alignment: Alignment.topRight,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    // padding: const EdgeInsets.all(8.0),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(8),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black26,
                    //       blurRadius: 10,
                    //       spreadRadius: 2,
                    //     ),
                    //   ],
                    // ),
                    width: menuWidth, // Dynamic width based on screen width
                    child: widget.childBuilder(_hideMenu),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _hideMenu() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.ellipsis_circle, color: Colors.blue),
      onPressed: () {
        if (_overlayEntry == null) {
          _showMenu(context);
        } else {
          _hideMenu();
        }
      },
    );
  }
}
