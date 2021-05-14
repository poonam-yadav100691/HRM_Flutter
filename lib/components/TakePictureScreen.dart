import 'dart:async';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key key,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraDescription firstCamera;

  CameraController _controller;
  Future<void> _initializeControllerFuture;
  Future<void> _cameraInit() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.

    setState(() {
      firstCamera = cameras.first;
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        firstCamera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );

      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  void initState() {
    super.initState();
    _cameraInit();
    // To display the current output from the Camera,
    // create a CameraController.
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;


            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            // _controller.takePicture(path).then((value) {
            //
            // });
             var file = File(path);
            if (file != null) {
              print("helo");
              await _controller.takePicture();
              base64Encode(file.readAsBytesSync());
              var base64Image = base64Encode(file.readAsBytesSync());
              print("Imageee::: ${base64Image}");

              final bytes = Io.File(path).readAsBytesSync();

              String img64 = base64Encode(bytes);
              print("object");
              print(img64.substring(0, 100));
               Navigator.pop(context, base64Encode(file.readAsBytesSync()));
            }
            // Attempt to take a picture and log where it's been saved.


            //  Navigator.pop(context, path);

            // If the picture was taken, display it on a new screen.
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DisplayPictureScreen(imagePath: path),
            //   ),
            // );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Image.file(File(imagePath)),
          // FlatButton(
          //     // onPressed: () {
          //     //   var file = File(imagePath);
          //     //   if (file != null) {
          //     //     base64Encode(file.readAsBytesSync());
          //     //     print(base64Encode(file.readAsBytesSync()));
          //     //     // Navigator.pop(context, base64Encode(file.readAsBytesSync()));
          //     //   }
          //     // },
          //     child: Text("Get this Image"))
        ],
      ),
    );
  }
}
