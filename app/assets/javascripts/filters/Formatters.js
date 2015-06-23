app.filter('humanizeFdaDate',function() {
  return function(input) {
    var y,m,d;
    y = input.substring(0,4);
    m = input.substring(4,6);
    d = input.substring(6,8);
    return m + "/" + d + "/" + y + ""; 
  };
});

app.filter('dmyDate', function() {
  return function(dateString) {
    var y,m,d;
    y = dateString.substring(0,4);
    m = dateString.substring(4,6);
    d = dateString.substring(6,8);
    return m + d + y;
  };
});

app.filter('indicationShort', function () {
  return function (item) {
    if (item) {
      return item.split('. ')[0].replace(/^[0-9\s]*/, '');
    }
  };
});
