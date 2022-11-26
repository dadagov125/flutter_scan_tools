
#Flutter scan tools
Flutter tool pack for scanning credit card, qr code, mrz.


## Before usage
##### ios
info.list
```
<key>NSCameraUsageDescription</key>
<string>camera</string>

<key>io.flutter.embedded_views_preview</key>
<true/>
```
##### android
```xml
<uses-permission android:name="android.permission.FLASHLIGHT"/>
<uses-permission android:name="android.permission.CAMERA"/>
....
<application>
  <meta-data
    android:name="flutterEmbedding"
    android:value="2" />
</application>
```



## Usage


```dart
void _startScan() async {
  await Permission.camera.request();

  final scanResul = await FlutterScanTools.scanCard(context);

  setState(() {
    this.scanResul = scanResul;
  });
}
```

## Additional information
....
