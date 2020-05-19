import 'dart:convert';

String main() {
  const clientID = "com.rightspot.iosapp";

// Note the trailing colon (:) after the clientID.
// A client identifier secret would follow this, but there is no secret, so it is the empty string.
  final String clientCredentials = const Base64Encoder().convert("$clientID:c2VjcmV0Zm9ycmlnaHRzcG90".codeUnits);

  print(clientCredentials);

  return clientCredentials;
}