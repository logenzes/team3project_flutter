import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/data_table.dart';

class VideoPlay extends StatefulWidget {
  const VideoPlay({
    Key? key,
  }) : super(key: key);
  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  //----------------------------------------
  Future<List<Video>> getSQLData() async {
    final List<Video> videoList = [];
    final Mysql db = Mysql();
    await db.getConnection().then((conn) async {
      String sqlQuery = 'select file_name from Video order by file_name DESC';
      await conn.query(sqlQuery).then((result) {
        for (var res in result) {
          final videoModel = Video(
            // id: res["id"],
            file_name: res["file_name"],
            // Datetime: res["Datetime"],
          );
          videoList.add(videoModel);
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return videoList;
  }
  //------------------------------------------------

  late VideoPlayerController controller;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer() {
    controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play Video from Assets/URL"),
        backgroundColor: Color(0xff1160aa),
      ),
      body: Container(
          child: ListView(children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        Container(
          //duration of video
          child:
              Text("Total Duration: " + controller.value.duration.toString()),
        ),
        Container(
            child: VideoProgressIndicator(controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  backgroundColor: Colors.redAccent,
                  playedColor: Colors.green,
                  bufferedColor: Colors.purple,
                ))),
        Container(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }

                    setState(() {});
                  },
                  icon: Icon(controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow)),
              IconButton(
                  onPressed: () {
                    controller.seekTo(Duration(seconds: 0));

                    setState(() {});
                  },
                  icon: Icon(Icons.stop))
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Text(
            'Video history',
            textAlign: TextAlign.center,
          ),
        ),
        //new Row
        //new Row(
        //  children: <Widget>[
        //    Expanded(
        //        child: SizedBox(
        //      height: 50,
        //      child: getDBData(),
        //    ))
        //  ],
        //)
        Container(
          child: SizedBox(
            child: getDBData(),
            height: 300,
          ),
        ),
      ])),
    );
  }

  //------------------------------------------------
  FutureBuilder<List> getDBData() {
    return FutureBuilder<List>(
        future: getSQLData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data as List;
              return ListTile(
                leading: Text(
                  data[index].file_name.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                //title: Text(
                //  data[index].Datetime.toString(),
                //  style: const TextStyle(
                //    fontSize: 20,
                //    fontWeight: FontWeight.bold,
                //  ),
                //),
                //subtitle: Text(
                //  data[index].Datetime.toString(),
                //  style: const TextStyle(fontSize: 20),
                //),
              );
            },
          );
        });
  }
  //---------------------------------------------
}
