part of flutter_plugin_camera;


class PreviewVideo extends StatefulWidget {
  String videoPath;
  bool compress;
  final bool saveMedia;
  ValueChanged<File> fileVideo;

  PreviewVideo({this.fileVideo,this.videoPath, this.compress = false, this.saveMedia = false});
  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  // VoidCallback videoPlayerListener;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool startedPlaying = false;
  String albumName = 'Media';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final VideoPlayerController vcontroller =
    VideoPlayerController.file(File(widget.videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
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

  Future video() async{

    if(widget.compress == true){
      final info = await VideoCompress.compressVideo(
        widget.videoPath,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      widget.fileVideo(File(info.path));
      if(widget.saveMedia == true){
        GallerySaver.saveVideo(info.path, albumName: albumName).then((bool success) {
          print('Luu thanh cong');
        });
      }

    }else{
      widget.fileVideo(File(widget.videoPath));
      if(widget.saveMedia == true){
        GallerySaver.saveVideo(widget.videoPath, albumName: albumName).then((bool success) {
          print('Luu thanh cong');
        });
      }
    }


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: VideoPlayer(videoController),
            ),
            Positioned(
              top: 0,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12.withOpacity(0.5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          videoController.pause();
                          Get.back();
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
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
                  children: [
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 25,
                right: 15,
                child: GestureDetector(
                  onTap: (){
                    video();
                  },
                  child: Container(
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
                  ),
                ))
          ],
        ),
      ),
    );
  }


}