# Bookstore

Bookstore is a flutter app that uses the [Google Books APIs](https://developers.google.com/books) to show users books and lets them add/remove books from their favorite list. Authetication is handled using [Sign in With Google](https://developers.google.com/identity/gsi/web/guides/overview). Users favorite list is stored in [Firebase Cloud Firestore](https://firebase.google.com/docs/firestore)

Currently the `Add to favorite` & `Remove from favorite` is pretty much ambigous. Pressing on the `Heart` icon of book card checks if the book is already in favorites. Based on that it either removes the book from favorites or add the book in favorites. There's not much of a visual feedback to that. Only a toast is shown. 

## Getting Started

- clone the git repository `git clone https://github.com/NafiAsib/bookstore.git`
- cd into the directory `cd bookstore`
- install dependencies `flutter pub get`

***You'll need to add your google-services.json that contains your fingerprint(SHA-1) in order to Sign Up work***

### No splash screen?

- run `flutter pub run flutter_native_splash:create` to generate splash screen

### No app icon?

- run `flutter pub run flutter_launcher_icons:main` to generate app icon

This app utilizes [bloc](https://bloclibrary.dev/) to manage states. Typical data flow is shown with diagram below:

![image](https://user-images.githubusercontent.com/38901581/193500621-2eed6408-46fb-4aa1-a98d-cf7cf84bc3b6.png)

- Data models are generated with [json_serializable](https://pub.dev/packages/json_serializable)
- Images are show using [cached_network_image](https://pub.dev/packages/cached_network_image)
- [keyboard_dismisser](https://pub.dev/packages/keyboard_dismisser) is used to handle unfocusing of keyboard

## Build

```bash
flutter build apk --release
```


### Credits

- Gradients generated using [FLUTTER GRADIENT GENERATOR](https://fluttergradientgenerator.com/)
- Apps png icon from [Get Free SVG](https://getfreesvg.com/free-floral-book-svg-cut-file-png-dxf-eps-223/)
