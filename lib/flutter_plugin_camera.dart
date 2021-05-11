library flutter_plugin_camera;

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import 'camera/widget/video_player_both_widget.dart';


import 'camera/widget/advanced_overlay_widget.dart';
part 'camera/camera_screen.dart';
part 'camera/preview_screen.dart';
part 'camera/preview_video.dart';
part 'camera/circular_progress_bar.dart';