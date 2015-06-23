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

app.filter('sexToString', function() {
  return function(code) {
    var lookup = {
      '0': 'Sex Unknown',
      '1': 'Male',
      '2': 'Female'
    };
    return lookup[code];
  };
});

app.filter('kgToLbs', function() {
  return function(weightKg) {
    return Math.round(Number(weightKg)*2.2) + " lbs";
  };
});

app.filter('ageToYrs', function() {
  return function(age,ageUnit) {
    var lookup_multiplier = {
      '800':0.1,  
      '801':1.0,
      '802':12.0,
      '803':52.0,
      '804':365.0,
      '805':0
    };
    return Math.round(Number(age)*lookup_multiplier[ageUnit]) + " yrs";
  };
});

app.filter('indicationShort', function () {
  return function (item) {
    if (item) {
      return item.split('. ')[0].replace(/^[0-9\s]*/, '').toLowerCase();
    }
  };
});
