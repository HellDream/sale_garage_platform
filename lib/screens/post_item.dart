import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/models/item.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';

class PostScreen extends StatefulWidget {
  static String id = '/PostScreen';

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Asset> _images = [];
  String _title;
  String _description = '';
  double _price = 0.00;
  final int _maxSize = 9;
  bool isSave = false;
  bool _saving = false;
  bool _validate = false;
  bool _shareLocation = false;

  Future _getImage() async {
    List<Asset> images = await MultiImagePicker.pickImages(
      maxImages: _maxSize - _images.length,
      enableCamera: true,
    );
    setState(() {
      _images.addAll(images);
    });
  }

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('Post Item'),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              if (!isSave) {
                setState(() {
                  _saving = true;
                });
                await _onSaveItem();
                setState(() {
                  _saving = false;
                });
                final snackBar = SnackBar(
                  content: Text('Yay! You have posted Your Item!'),
                );
                globalKey.currentState.showSnackBar(snackBar);
              } else {
                final snackBar = SnackBar(
                  content: Text('Hey! You have already posted!'),
                );
                globalKey.currentState.showSnackBar(snackBar);
              }
            },
            child: Container(
              padding: EdgeInsets.only(top: 17, right: 25),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        opacity: 0.8,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              _imageGridView(context),
              _itemBasicInfoColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageGridView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: _generateList(),
      ),
    );
  }

  List<Widget> _generateList() {
    List<Widget> imgWidgets = List.generate(
      _images.length,
      (index) => AssetThumb(
        asset: _images[index],
        width: 300,
        height: 300,
      ),
    );
    if (_images.length < _maxSize) {
      imgWidgets.add(
        Container(
          height: 50,
          width: 50,
          color: Colors.grey.shade300,
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.grey.shade700),
            onPressed: _getImage,
          ),
        ),
      );
    }
    return imgWidgets;
  }

  Future<void> _onSaveItem() async {
    GeoFirePoint geo = await getGeoPoint();
    Item item = Item(
        title: _title, description: _description, price: _price, images: [], location: geo);
    print(item.toJson());
    await item.addImage(_images);
    await postService.createPost(item);
    setState(() {
      isSave = true;
    });
  }

  Widget _itemBasicInfoColumn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Title of Your Item',
              border: InputBorder.none,
              labelText: 'Title',
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
            ),
            onChanged: (String value) {
              setState(() {
                _title = value;
                _validate = value.length == 0;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '0.00',
              labelText: 'Price',
            ),
            onChanged: (String value) {
              setState(() {
                try {
                  _price = double.parse(value);
                } catch (ex) {
                  if (value.length == 0) return;
                  Alert(
                          title: 'The price should be Number',
                          type: AlertType.error,
                          context: context)
                      .show();
                }
              });
            },
          ),
          Row(
            children: <Widget>[
              Text("Share Location?"),
              Switch(
                onChanged: (bool value) {
                  setState(() {
                    _shareLocation = value;
                  });
                },
                value: _shareLocation,
              ),
            ],
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                hintText: 'Describe Your Item',
                border: InputBorder.none,
                labelText: 'Description'),
            onChanged: (String value) {
              setState(() {
                _description = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<GeoFirePoint> getGeoPoint() async {
    if(_shareLocation){
      LocationData data = await locationService.getLocation();
      return GeoFirePoint(data.latitude, data.longitude);
    }
    return null;
  }
}
