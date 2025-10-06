import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:io' show Platform;

final String googleMapKey = Platform.isAndroid
    ? "AIzaSyBZZ9l_l7BHvxdXciVvktiZmAsR00YJxKc"
    : "AIzaSyCafvoLv-uc357oW0ceC2PzFsodhdnVlu8";




const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(-25.274398, 133.775136),
  zoom: 14.4746,
);

/*

StreamBuilder<User?>(
stream: FirebaseAuth.instance.authStateChanges(),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none ) {
return const EntryPage();
}

if (snapshot.hasData) {
return const HomePage();
} else {
return EntryPage();
}
},
),*/