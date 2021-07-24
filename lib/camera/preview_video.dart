part of flutter_plugin_camera;

class PreviewVideo extends StatefulWidget {
  final String videoPath;
  final bool compress;
  final bool saveMedia;
  final bool ghiChu;
  final ValueChanged<File> fileVideo;
  final ValueChanged<String>? ghiChuText;

  PreviewVideo(
      {required this.fileVideo,
      required this.videoPath,
      this.ghiChuText,
      this.ghiChu = false,
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
  final TextEditingController _textEditingControllerGhiChu =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController = VideoPlayerController.file(File(widget.videoPath))
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => videoController!.play());
  }

  Future video() async {
    widget.fileVideo(File(widget.videoPath));
    if (widget.ghiChu == true) {
      widget.ghiChuText!(_textEditingControllerGhiChu.text);
    }
    if (widget.saveMedia == true) {
      GallerySaver.saveVideo(widget.videoPath, albumName: albumName)
          .then((bool? success) {
        print('Luu thanh cong');
      });
    }
    Get.back(result: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController!.dispose();
    _visibilityCompress.close();
    _textEditingControllerGhiChu.dispose();
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
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 80, bottom: 80),
                  //   child: ,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 65),
                  //   child: VideoPlayerWidget(controller: videoController!),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: (_keyboardIsVisible()) ? 50 : 65,
                      top: (_keyboardIsVisible()) ? 0 : 50,
                    ),
                    child: VideoPlayerBothWidget(controller: videoController!),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
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
                      height: (_keyboardIsVisible()) ? 50 : 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black12.withOpacity(0.5),
                      child: Column(
                        children: [
                          (widget.ghiChu)
                              ? Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Nhập ghi chú',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        icon: Icon(
                                          Icons.keyboard,
                                          color: Colors.white,
                                        )),
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.multiline,
                                    controller: _textEditingControllerGhiChu,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),

                  (widget.ghiChu)
                      ? Positioned(
                          bottom: 0,
                          right: 15,
                          child: GestureDetector(
                            onTap: () {
                              video();
                            },
                            child: (!_check)
                                ? Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
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
                                  )
                                : SizedBox.shrink(),
                          ))
                      : Positioned(
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              video();
                            },
                            child: (!_check)
                                ? Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
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
                                  )
                                : SizedBox.shrink(),
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
            }),
      ),
    );
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
