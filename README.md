# Bookstore

Bookstore is a flutter app that uses the [Google Books APIs](https://developers.google.com/books) to show users books and lets them add/remove in their favorite list. Authetication is handle using [Sign in With Google](https://developers.google.com/identity/gsi/web/guides/overview). Users favorite list is stored in [Firebase Cloud Firestore](https://firebase.google.com/docs/firestore)

## Getting Started

- clone the git repository `git clone https://github.com/NafiAsib/bookstore.git`
- cd into the directory `cd bookstore`
- install dependencies `flutter pub get`

### No splash screen?

- run `flutter pub run flutter_native_splash:create` to generate splash screen

### No app icon?

- run `flutter pub run flutter_launcher_icons:main` to generate app icon

This app utilizes [bloc](https://bloclibrary.dev/) to manage states.

### Credits

- Gradients generated using [FLUTTER GRADIENT GENERATOR](https://fluttergradientgenerator.com/)
- Apps png icon from [Get Free SVG](https://getfreesvg.com/free-floral-book-svg-cut-file-png-dxf-eps-223/)
