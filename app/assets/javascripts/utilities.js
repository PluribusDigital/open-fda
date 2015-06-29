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
  
  ,replaceAll: function(str, find, replace) {
    return str.replace(new RegExp("["+find+"]", 'g'), replace);
  }

  ,replaceCaseInsensitive: function (string,target,replaceWith) {
    // find the start position if the offending string 
    var n = string.toLowerCase().search(target.toLowerCase());
    // if it is found, remove it
    if (n > -1) {
      beginning = string.substring(0,n); // everything before the offending bit
      end = string.substring(n+target.length); // everything after
      string = beginning + end;
    }
    return string;
  }

  ,ellipsizeAfter: function (string,chars) {
     if (string.length > chars) {
       return string.substring(0,chars) + "...";
     } else {
       return string;
     }
   }

  ,surroundSubstringWith: function (string,target,before,after) {
    // find the start position if the target string 
    var n = string.toLowerCase().search(target.toLowerCase());
    // if it is found, remove it
    if (n > -1) {
      beginning = string.substring(0,n); // everything before the offending bit
      middle = string.substring(n,n+target.length); // target string
      end = string.substring(n+target.length); // everything after
      string = beginning + before + middle + after + end; // put it all together
    }
    return string;
   }

}