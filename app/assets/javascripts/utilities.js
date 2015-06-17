/*
  Custom Utility Functions
*/

U = {

  isNumber: function (val) {
    return !isNaN(parseFloat(val)) && isFinite(val);
  }
 
  ,isDate: function (val) {
    return (!isNumber(val)) && (Date.parse(val)) ? true : false;
  }
   
  ,isBlank: function (val) {
    // returns true for "", null, etc. -- returns false for 0, 1, "a", etc.
    if (val) {
      return false; 
    } else {
      return (val===0) ? false : true
    }
  }
   
  ,uniqueValues: function (values_array) {
    var unique = [];
    for(var i = 0, l = values_array.length; i < l; ++i){
      var e = values_array[i];
      if ( (!U.isBlank(e)) && (unique.indexOf(e) == -1) ) { 
        unique.push(e);
      }
    }
    return unique;
  }

  ,uniqueValuesForKey: function (values_array,key) {
    var unique = [];
    for(var i = 0, l = values_array.length; i < l; ++i){
      var e = values_array[i];
      if ( (!U.isBlank(e)) && (unique.indexOf(e[key]) == -1) ) { 
        unique.push(e[key]);
      }
    }
    return unique;
  }

}