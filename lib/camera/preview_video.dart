part of flutter_plugin_camera;

class PreviewVideo extends StatefulWidget {
  final String videoPath;
  final bool compress;
  final bool saveMedia;
  final ValueChanged<File> fileVideo;

  PreviewVideo(
      {required this.fileVideo,
      required this.videoPath,
      this.compress = false,
      this.saveMedia = false});
  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  // VoidCallback videoPlayerListener;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool startedPlaying = false;
  String albumName = 'Media';
  final BehaviorSubject<bool> _visibilityCompress =
  BehaviorSubject<bool>.seeded(false);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(widget.videoPath));
    videoPlayerListener = () {
      if (videoController != null ) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vcontroller.addListener(videoPlayerListener!);
    vcontroller.setLooping(true);
    vcontroller.initialize();
    videoController?.dispose();
    if (mounted) {
      setState(() {
        videoController = vcontroller;
      });
    }
    vcontroller.play();
  }

  Future video() async {

    if (widget.compress == true) {
      _visibilityCompress.sink.add(true);
      final info = await VideoCompress.compressVideo(
        widget.videoPath,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
        includeAudio: true,
      );


      final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

      final Directory tempDir = await getTemporaryDirectory();
      final String videoOutput =
          tempDir.path + '/' + path.basenameWithoutExtension(widget.videoPath) + '.mp4';
      var arguments = ["-i",info!.path, "-c:v", "mpeg4", videoOutput];
      final _compress = _flutterFFmpeg.executeWithArguments(arguments);

      if(_compress != null){
        widget.fileVideo(File(videoOutput));
        _visibilityCompress.sink.add(false);
      }
      if(widget.saveMedia == true){
        GallerySaver.saveVideo(videoOutput, albumName: albumName).then((bool? success) {
          print('Luu thanh cong');
        });
      }
      Get.back(result: 1);
    } else {
      widget.fileVideo(File(widget.videoPath));
      if(widget.saveMedia == true){
        GallerySaver.saveVideo(widget.videoPath, albumName: albumName).then((bool? success) {
          print('Luu thanh cong');
        });
      }
      Get.back(result: 1);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController!.dispose();
    _visibilityCompress.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: StreamBuilder(
          stream: _visibilityCompress.stream,
            initialData: false,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            bool _check = snapshot.data ?? false;
            return Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 100),
                  child: VideoPlayer(videoController!),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black12.withOpacity(0.5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              videoController!.pause();
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                            )),
                        Spacer(),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black12.withOpacity(0.5),
                    child: Row(
                      children: [],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 25,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        video();
                      },
                      child: (!_check)?Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(
                              50.0) //                 <--- border radius here
                          ),
                        ), //             <--- BoxDecoration here
                        child: Center(
                          child: Icon(
                            Icons.send_sharp,
                            color: Colors.blue,
                            size: 35,
                          ),
                        ),
                      ):SizedBox.shrink(),
                    )),
                Positioned.fill(
                  child: Center(
                    child: (_check)
                        ? const CircularProgressIndicator()
                        : Container(),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
