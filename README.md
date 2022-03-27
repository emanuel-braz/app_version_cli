### Get current app version from App Stores (Android and iOS) from within the command line interface

#### Install
`dart pub global activate app_version_cli`

#### Usage
`app_version --app-ids="ios:my.ios_app.id,android:my.android_app.id"`

or  
`app_version --app-ids="my.app.id"`

#### Using Variables
```shell
$ VERSIONS=`app_version --app-ids="my.app.id"`

$ echo $VERSIONS 

#Output
[
    {
        "platform": "android",
        "version": "2.4.3",
        "url": "https://play.google.com/store/apps/details?id=my.app.id"
    }, 
    {
        "platform": "ios",
        "version": "2.4.4",
        "url": "https://apps.apple.com/us/app/my.app.id/id00000000"
    }
]
```
