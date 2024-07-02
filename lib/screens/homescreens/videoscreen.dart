import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/screens/homescreens/home_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class MyVideoPlayer extends StatefulWidget {
//   const MyVideoPlayer({super.key});
//
//   @override
//   State<MyVideoPlayer> createState() => _MyVideoPlayerState();
// }
//
// class _MyVideoPlayerState extends State<MyVideoPlayer> {
//   late VideoPlayerController controller;
//   @override
//   void initState() {
//     controller = VideoPlayerController.network(
//         'http://www.ijobshunts.com/public/vedio.mp4'
//
//     );
//     controller.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//     controller.setLooping(true);
//     controller.initialize().then((value) => controller.play());
//     super.initState();
//
//     // setLandscap();
//   }
//
//   @override
//   void dispose() {
//     controller;
//     setAllOrentations();
//     super.dispose();
//   }
//
//   Future setLandscap() async {
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     await Wakelock.enable();
//   }
//
//   Future setAllOrentations() async {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//     await Wakelock.disable();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isMuted = controller.value.volume == 0;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const HomePage(),
//               ),
//             );
//           },
//           icon: const FaIcon(
//             FontAwesomeIcons.arrowLeft,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           VideoPlayerWidget(controller: controller),
//           const SizedBox(),
//           if (controller != null && controller.value.isInitialized)
//             Positioned(
//               bottom: 30,
//               right: 10,
//               child: CircleAvatar(
//                 backgroundColor: Colors.red,
//                 child: IconButton(
//                   onPressed: () {
//                     controller.setVolume(isMuted ? 1 : 0);
//                   },
//                   icon: Icon(
//                     isMuted ? Icons.volume_mute : Icons.volume_up,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({Key? key}) : super(key: key);

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId:
          'h0izSGeRNkQ', // https://www.youtube.com/watch?v=Tb9k9_Bo-G4
      flags: const YoutubePlayerFlags(
        // autoPlay: false,
        // mute: true,
        // isLive: false,
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.orangeAccent,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.arrowLeft,
              ),
            ),
            // title: const Text("Youtube Player"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: player,
              ),
            ),
          ),
        );
      },
    );
  }
}


