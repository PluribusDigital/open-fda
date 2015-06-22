app.filter('humanizeFdaDate',function() {
  return function(input) {
    var y,m,d;
    y = input.substring(0,4);
    m = input.substring(4,6);
    d = input.substring(6,8);
    return m + "/" + d + "/" + y + ""; 
  };
});