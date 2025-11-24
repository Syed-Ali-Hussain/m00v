const axios = require("axios").default;
const qs = require("qs");

async function _distanceMatrixCall(context, ffVariables) {
  var originLocation = ffVariables["originLocation"];
  var destinationLocation = ffVariables["destinationLocation"];

  var url = `https://maps.googleapis.com/maps/api/distancematrix/json`;
  var headers = {};
  var params = {
    origins: originLocation,
    destinations: destinationLocation,
    key: `AIzaSyD9yRnzYWIb23TYRxy4wC7dGLG_5YRSJs8`,
    mode: `driving`,
    units: `imperial`,
  };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _placesAutocompleteCall(context, ffVariables) {
  var searched = ffVariables["searched"];
  var userLocation = ffVariables["userLocation"];
  var sessionToken = ffVariables["sessionToken"];

  var url = `https://maps.googleapis.com/maps/api/place/autocomplete/json`;
  var headers = {};
  var params = {
    input: searched,
    key: `AIzaSyD9yRnzYWIb23TYRxy4wC7dGLG_5YRSJs8`,
    location: userLocation,
    language: `en`,
    sessiontoken: sessionToken,
    components: `country:pk`,
  };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _placeDetailsCall(context, ffVariables) {
  var placeId = ffVariables["placeId"];
  var sessionToken = ffVariables["sessionToken"];

  var url = `https://maps.googleapis.com/maps/api/place/details/json`;
  var headers = {};
  var params = {
    place_id: placeId,
    key: `AIzaSyD9yRnzYWIb23TYRxy4wC7dGLG_5YRSJs8`,
    sessiontoken: sessionToken,
    fields: `geometry/location,name,icon,icon_background_color`,
  };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}

/// Helper functions to route to the appropriate API Call.

async function makeApiCall(context, data) {
  var callName = data["callName"] || "";
  var variables = data["variables"] || {};

  const callMap = {
    DistanceMatrixCall: _distanceMatrixCall,
    PlacesAutocompleteCall: _placesAutocompleteCall,
    PlaceDetailsCall: _placeDetailsCall,
  };

  if (!(callName in callMap)) {
    return {
      statusCode: 400,
      error: `API Call "${callName}" not defined as private API.`,
    };
  }

  var apiCall = callMap[callName];
  var response = await apiCall(context, variables);
  return response;
}

async function makeApiRequest({
  method,
  url,
  headers,
  params,
  body,
  returnBody,
  isStreamingApi,
}) {
  return axios
    .request({
      method: method,
      url: url,
      headers: headers,
      params: params,
      responseType: isStreamingApi ? "stream" : "json",
      ...(body && { data: body }),
    })
    .then((response) => {
      return {
        statusCode: response.status,
        headers: response.headers,
        ...(returnBody && { body: response.data }),
        isStreamingApi: isStreamingApi,
      };
    })
    .catch(function (error) {
      return {
        statusCode: error.response.status,
        headers: error.response.headers,
        ...(returnBody && { body: error.response.data }),
        error: error.message,
      };
    });
}

const _unauthenticatedResponse = {
  statusCode: 401,
  headers: {},
  error: "API call requires authentication",
};

function createBody({ headers, params, body, bodyType }) {
  switch (bodyType) {
    case "JSON":
      headers["Content-Type"] = "application/json";
      return body;
    case "TEXT":
      headers["Content-Type"] = "text/plain";
      return body;
    case "X_WWW_FORM_URL_ENCODED":
      headers["Content-Type"] = "application/x-www-form-urlencoded";
      return qs.stringify(params);
  }
}

module.exports = { makeApiCall };
