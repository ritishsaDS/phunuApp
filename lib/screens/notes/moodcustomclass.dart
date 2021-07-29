import 'package:flutter/material.dart';
import 'package:vietnamese/common/constants.dart';
import 'package:vietnamese/common/size_config.dart';
import 'package:vietnamese/models/addnotes.dart';
import 'package:vietnamese/models/mood.dart';

class LanguageSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LanguageSelectionState();
  }
}

class LanguageSelectionState extends State<LanguageSelection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
      alignment: Alignment.center,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        elevation: 25.0,
        backgroundColor: Colors.white,
        child: dialogContent(context),
      ),
    );
  }
}

dialogContent(BuildContext context) {
  return Container(
    child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          alignment: Alignment.topRight,
          child: Icon(
            Icons.close,
            color: Colors.grey,
            size: 20.0,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
          color: Colors.white,
          child: Text("Select your preferred language"),
        ),
        Flexible(
          child: new MyDialogContent(), //Custom ListView
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () {},
            color: Colors.yellow,
            textColor: Colors.black,
            child: Text(
              "Submit",
            ),
          ),
        ),
      ],
    ),
  );
}

class MyDialogContent extends StatefulWidget {
  List<int> id;
  MyDialogContent({this.id});
  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  List<CustomRowModel> sampleData = new List<CustomRowModel>();
  var arr = [];
  List<Mood> mood = [];
  List<Mood> moodss = [];
  @override
  void initState() {
    super.initState();

    sampleData.add(CustomRowModel(title: "Khó chịu", selected: false, id: 0));
    sampleData.add(CustomRowModel(title: "Buồn", selected: false, id: 1));
    sampleData.add(CustomRowModel(title: "Buồn chán", selected: false, id: 2));
    sampleData.add(CustomRowModel(title: "Cô đơn", selected: false, id: 3));
    sampleData
        .add(CustomRowModel(title: "Dễ xúc động", selected: false, id: 4));
    sampleData.add(CustomRowModel(title: "Mệt đừ", selected: false, id: 5));
    sampleData
        .add(CustomRowModel(title: "Muốn gây chuyện", selected: false, id: 6));
    sampleData.add(CustomRowModel(title: "Nóng nảy", selected: false, id: 7));
    sampleData.add(CustomRowModel(title: "Tự tin", selected: false, id: 8));
    sampleData.add(CustomRowModel(title: "Yêu đời", selected: false, id: 9));
    sampleData
        .add(CustomRowModel(title: "Bình thường", selected: false, id: 10));
    for (int i = 0; i < widget.id.length; i++) {
      sampleData[widget.id[i]].selected = true;
      mood.add(Mood(id: sampleData[widget.id[i]].id.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        elevation: 25.0,
        backgroundColor: Colors.white,
        child: Container(
          height: SizeConfig.screenHeight / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHeader(context),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: sampleData.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    //highlightColor: Colors.red,
                    //splashColor: Colors.blueAccent,
                    onTap: () {
                      setState(() {
                        //  sampleData.forEach((element) => element.selected = false);
                        //sampleData[index].selected = true;
                        if (sampleData[index].selected == true) {
                          sampleData[index].selected = false;
                          arr += [sampleData[index].id];
                          if (widget.id != null) {
                            sampleData[index].selected = false;
                            // mood.remove(sampleData[index].id);
                            arr = [sampleData[index].id];
                            print(arr);
                            mood.removeWhere(
                                (item) => item.id == arr.toString().replaceAll("[", "").replaceAll("]", ""));
                            print(mood.length);
                          } else {
                            mood.removeAt(index);
                          }
                        } else if (sampleData[index].selected == false) {
                          setState(() {
                            sampleData[index].selected = true;
                            arr += [sampleData[index].id];
                            mood.add(Mood(id: sampleData[index].id.toString()));
                            print(arr);
                          });
                        }
                      });
                    },
                    child: new CustomRow(sampleData[index]),
                  );
                },
              ),
              SizedBox(
                height: 50,
                width: SizeConfig.screenWidth - 10,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    if (widget.id == null) {
                      Navigator.pop(context, mood);
                    } else if (widget.id != null && arr != null) {
                      Navigator.pop(context, mood);
                    } else {
                      Navigator.pop(context, mood);
                    }
                  },
                  color: kPrimaryColor,
                  textColor: Colors.white,
                  child: Text(
                    "Ok",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildHeader(context) {
    return Container(
      height: getProportionateScreenHeight(45),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: kPrimaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Mình cảm thấy..',
            style: title,
          ),
          IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: getProportionateScreenHeight(20),
              ),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
    );
  }

  final TextStyle title = TextStyle(
    fontSize: getProportionateScreenHeight(18),
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
}
