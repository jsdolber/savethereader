function validateUrl(url) {
  var expression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi;
  var regex = new RegExp(expression);
  return url.match(regex);
}

function parseIntWithEmpty(str) {
  if (str == undefined || str.length == 0) return 0;
  return parseInt(str);
}
