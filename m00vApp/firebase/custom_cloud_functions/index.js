const admin = require("firebase-admin/app");
admin.initializeApp();

const geoFencing = require("./geo_fencing.js");
exports.geoFencing = geoFencing.geoFencing;
