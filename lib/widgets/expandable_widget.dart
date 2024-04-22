import 'package:flutter/cupertino.dart';

class ExpandableWidget extends StatefulWidget {
  final String header;
  final Widget content;

  const ExpandableWidget(
      {super.key, required this.header, required this.content});

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: GestureDetector(
            onTap: _toggleExpanded,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                      widget.header,
                      style: const TextStyle(
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    )),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.25).animate(_animation),
                  child: const Icon(
                    CupertinoIcons.chevron_forward,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: widget.content,
        ),
      ],
    );
  }
}