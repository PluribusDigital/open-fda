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
    var num = Math.round(Number(weightKg)*2.2);
    if ( isNaN(num) ) {
      return null;
    } else {
      return num + " lbs";
    }
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
    var num = Math.round(Number(age)*lookup_multiplier[ageUnit]);
    if ( isNaN(num) ) {
      return null;
    } else {
      return num + " yrs";
    }
  };
});

app.filter('indicationShort', function () {
  return function (item) {
    if (!item) { item = "";} 
    // strip out common intro 
    item = U.replaceCaseInsensitive(item,"Indications And Usage","");
    // find first sentence
    item = item.split(/\s*[.•]\s*/)[0].replace(/^[0-9\s]*/, '').toLowerCase();
    // cut short long text
    item = U.ellipsizeAfter(item,200);
    // if it's still too long, ellipsize
    return item;
  };
});

app.filter('indicationLong', function () {
  return function (item) {
    if (!item) { item = "";} 
    // strip out common intro 
    item = U.replaceCaseInsensitive(item,"Indications And Usage","");
    // find first sentence
    return item;
  };
});

app.filter('eventTableDrugs', function () {
  return function (drugsArray, textToHighlight) {
    names = drugsArray.map(function(d){
      if (d.drugcharacterization==="1") {
        return "<strong>"+d.medicinalproduct+"*</strong>";
      } else {
        return d.medicinalproduct;
      }
    });
    namesString = names.join(", ");
    return U.surroundSubstringWith( namesString, textToHighlight, '<mark>', '</mark>' );
  };
});

app.filter('eventTableReactions', function () {
  return function (reactionsArray, textToHighlight) {
    terms = reactionsArray.map(function(r){
        return r.reactionmeddrapt;
    });
    termsString = terms.join(", ");
    return U.surroundSubstringWith( termsString, textToHighlight, '<mark>', '</mark>' );
  };
});
