var authApiLoaded = false;
var pickerApiLoaded = false;
var oauthToken;
var viewIdForhandleAuthResult;
function onApiLoad() {
  gapi.load('auth', {
    'callback' : onAuthApiLoad
  });
  gapi.load('picker', {
    'callback' : onPickerApiLoad
  });
}
function onAuthApiLoad() {
  authApiLoaded = true;
}
function onPickerApiLoad() {
  pickerApiLoaded = true;
}
