part of flutter_plugin_camera;

class PreviewScreen extends StatefulWidget {
  late final String imgPath;
  final bool compress;
  final bool saveMedia;
  final bool ghiChu;
  final ValueChanged<File> fileImage;
  final ValueChanged<String>? ghiChuText;

  PreviewScreen(
      {required this.fileImage,
      required this.imgPath,
      this.ghiChuText,
      this.ghiChu = false,
      this.compress = false,
      this.saveMedia = false});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  File? cropped;
  bool check = false;
  String albumName = 'Media';
  final TextEditingController _textEditingControllerGhiChu =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.compress == true) {
    //   compressImage(widget.imgPath);
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            (cropped == null)
                ? Center(
                    child: PhotoView(
                    enableRotation: true,
                    imageProvider: FileImage(File(widget.imgPath)),
                  )
                    // Image.file(
                    //   File(widget.imgPath),
                    //   fit: BoxFit.cover,
                    // ),
                    )
                : Positioned(
                    top: 150,
                    bottom: 150,
                    child: Image.file(
                      File(cropped!.path),
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
                height: (_keyboardIsVisible()) ? 50 : 80,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12.withOpacity(0.5),
                child: Column(
                  children: [
                    (widget.ghiChu)?Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nhập ghi chú',
                            hintStyle: TextStyle(color: Colors.white),
                            icon: Icon(
                              Icons.keyboard,
                              color: Colors.white,
                            )),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.multiline,
                        controller: _textEditingControllerGhiChu,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ):const SizedBox.shrink(),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: (_keyboardIsVisible()) ? 25 : 50,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    if (cropped != null) {
                      widget.fileImage(File(cropped!.path));
                      if(widget.ghiChu == true){
                        widget.ghiChuText!(_textEditingControllerGhiChu.text);
                      }
                      if (widget.saveMedia == true) {
                        GallerySaver.saveImage(cropped!.path,
                                albumName: albumName)
                            .then((bool? success) {
                          print('Luu thanh cong');
                        });
                      }
                      Get.back(result: 1);
                    } else {
                      widget.fileImage(File(widget.imgPath));
                      if(widget.ghiChu == true){
                        widget.ghiChuText!(_textEditingControllerGhiChu.text);
                      }
                      if (widget.saveMedia == true) {
                        GallerySaver.saveImage(widget.imgPath,
                                albumName: albumName)
                            .then((bool? success) {
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
    print(cropped!.path);
    this.setState(() {
      widget.imgPath = cropped!.path;
    });
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingControllerGhiChu.dispose();
  }

// void compressImage(String patch) async {
//   final filePath = patch;
//   final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
//   final splitted = filePath.substring(0, (lastIndex));
//   final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
//
//   final compressedImage = await FlutterImageCompress.compressAndGetFile(
//       filePath, outPath,
//       minWidth: 1000, minHeight: 1000, quality: 20);
//   this.setState(() {
//     widget.imgPath = compressedImage!.absolute.path;
//   });
// }
}
