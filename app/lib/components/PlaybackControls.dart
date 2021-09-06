import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayPauseButton extends StatefulWidget {
  final double iconSize;
  final bool isPlaying;

  const PlayPauseButton(
      {Key? key, this.iconSize = 24, this.isPlaying = false, this.onPressed})
      : super(key: key);

  final Function()? onPressed;

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed ?? () {},
      icon: Icon(
        widget.isPlaying ? Icons.pause : Icons.play_arrow,
        size: widget.iconSize,
      ),
    );
  }
}
