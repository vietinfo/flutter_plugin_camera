part of flutter_plugin_camera;

class PreviewScreen extends StatefulWidget {
  String imgPath;
  bool compress;
  final bool saveMedia;
  ValueChanged<File> fileImage;

  PreviewScreen(
      {this.fileImage,
      this.imgPath,
      this.compress = false,
      this.saveMedia = false});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  File cropped;
  bool check = false;
  String albumName = 'Media';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.compress == true) {
      compressImage(widget.imgPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            (cropped == null)
                ? Positioned.fill(
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ))
                : Positioned(
              top: 150,
              bottom: 150,
              child: Image.file(
                File(cropped.path),
                width: 500,
                height: 500,
                fit: BoxFit.cover,
              ),
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
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        )),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          cropImage(widget.imgPath);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Icon(
                            Icons.crop,
                            color: Colors.white,
                          ),
                        )),
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
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            check = !check;
                          });
                        },
                        child: Icon(
                          Icons.filter,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 25,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    if (cropped != null) {
                      widget.fileImage(File(cropped.path));
                      if(widget.saveMedia == true){
                        GallerySaver.saveImage(cropped.path, albumName: albumName)
                            .then((bool success) {
                          print('Luu thanh cong');
                        });
                      }
                      Get.back(result: 1);
                    } else {
                      widget.fileImage(File(widget.imgPath));
                      if(widget.saveMedia == true){
                        GallerySaver.saveImage(widget.imgPath, albumName: albumName)
                            .then((bool success) {
                          print('Luu thanh cong');
                        });
                      }
                      Get.back(result: 1);
                    }
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

  Future cropImage(String patch) async {
    cropped = await ImageCropper.cropImage(
        sourcePath: patch,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Cắt ảnh",
          // toolbarColor: Colors.deepOrange,
          // statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
        ));
    print(cropped.path);
    this.setState(() {
      widget.imgPath = cropped.path;
    });
  }

  void compressImage(String patch) async {
    final filePath = patch;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        minWidth: 1000, minHeight: 1000, quality: 20);
    this.setState(() {
      widget.imgPath = compressedImage.absolute.path;
    });
  }
}
