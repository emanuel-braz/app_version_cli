import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

/// [AppVersionStatus]
class AppVersionStatus {
  String platform;
  String storeVersion;
  String appStoreUrl;
  AppVersionStatus(
      {required this.storeVersion,
      required this.appStoreUrl,
      required this.platform});

  @override
  String toString() {
    return '{"platform":"$platform","version":"$storeVersion","url":"$appStoreUrl"}';
  }
}

/// [AppVersion]
class AppVersion {
  List<String> appIds;

  AppVersion({required this.appIds});

  Future<AppVersionStatus?> getiOSAtStoreVersion(String appId) async {
    try {
      final response = await http
          .get(Uri.parse('http://itunes.apple.com/lookup?bundleId=$appId'));
      if (response.statusCode != 200) {
        // The app with id: $appId was not found in app store
        return null;
      }
      final jsonObj = jsonDecode(response.body);
      final versionStatus = AppVersionStatus(
          storeVersion: jsonObj['results'][0]['version'],
          appStoreUrl: jsonObj['results'][0]['trackViewUrl'],
          platform: 'ios');

      return versionStatus;
    } catch (e) {
      return null;
    }
  }

  Future<AppVersionStatus?> getAndroidAtStoreVersion(
      String applicationId) async {
    try {
      final url =
          'https://play.google.com/store/apps/details?id=$applicationId';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        // The app with application id: $applicationId was not found in play store
        return null;
      }
      final document = html.parse(response.body);
      final elements = document.getElementsByClassName('hAyfc');
      final versionElement = elements.firstWhere(
        (elm) => elm.querySelector('.BgcNfc')?.text == 'Current Version',
      );

      final versionStatus = AppVersionStatus(
          storeVersion: versionElement.querySelector('.htlgb')?.text ?? '',
          appStoreUrl: url,
          platform: 'android');

      return versionStatus;
    } catch (e) {
      return null;
    }
  }

  /// [getInfo]
  Future<List<AppVersionStatus>> getInfo() async {
    final appVersions = <AppVersionStatus>[];
    for (var appId in appIds) {
      if (appId.startsWith('android:')) {
        final version = await getAndroidAtStoreVersion(appId.split(':').last);
        if (version != null) appVersions.add(version);
      } else if (appId.startsWith('ios:')) {
        final version = await getiOSAtStoreVersion(appId.split(':').last);
        if (version != null) appVersions.add(version);
      } else {
        final versionIos = await getiOSAtStoreVersion(appId);
        if (versionIos != null) appVersions.add(versionIos);

        final versionAndroid = await getAndroidAtStoreVersion(appId);
        if (versionAndroid != null) appVersions.add(versionAndroid);
      }
    }

    String jsonList = '[${appVersions.join(',')}]';

    print(jsonList);
    return appVersions;
  }

  /// WIP [check]
  Future<void> check(String platform) async {}
}
