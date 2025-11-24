const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.geoFencing = functions.https.onCall((data, context) => {
  return { inside: false };
});
