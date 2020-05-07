import 'dart:convert';

String main() {
  const clientID = "com.rightspot.postman";

// Note the trailing colon (:) after the clientID.
// A client identifier secret would follow this, but there is no secret, so it is the empty string.
  final String clientCredentials = const Base64Encoder().convert("$clientID:".codeUnits);

  print(clientCredentials);

  return clientCredentials;
}