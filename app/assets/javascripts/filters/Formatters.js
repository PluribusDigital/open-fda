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
    // Need to remove leading all caps words.
    return item.split('. ')[0];
  };
});
