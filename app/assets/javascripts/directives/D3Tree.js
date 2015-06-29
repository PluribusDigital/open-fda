// D3 code patterned after http://mbostock.github.io/d3/talk/20111018/tree.html
app.controller('D3TreeController', function ($scope) {
  window.D3TreeControllerScope = $scope;

  $scope.data = [];

  // CONFIGURATION OPTIONS
  var m = [0, 50, 0, 200]; // margins [top, right, bottom, left]
  var w = 1280 - m[1] - m[3];
  var h =  500 - m[0] - m[2];
  var i = 0;
  var labelMax = 30; // longest size for text labels
  var animationDuration = 250; // transition of expand/collapse

  // DATA MASSAGING 
  // Shorten/ellipsize long labels
  var makeLabel = function(d) {
    var label;
    if (d.type) {label = d.type+": "+d.name;} else {label = d.name;}
    if (label.length > labelMax) {label = label.substring(0,labelMax) + "...";}
    return label;
  }
  // Handle large branches
  splitTreeData = function(treeData) {
    // The tree doesn't do well w/ huge sets
    // Break down each branch size to a max limit
    var limit = 20;
    var newChildren = [];
    if (treeData.children) {
      if (treeData.children.length > limit) {
        // figure out how many sets and how many in each
        var sets   = Math.ceil(treeData.children.length/limit);
        var perSet = Math.ceil(treeData.children.length/sets);
        for (i = 0; i < sets; i++) { 
          // slice out this set
          var thisSet = treeData.children.slice( i*perSet , (i+1)*perSet );
          // name this set by first letter range (e.g. A-M, M-Z)
          var alphaGroup = thisSet[0].name[0]+'-'+thisSet[thisSet.length-1].name[0];
          // add this completed set as a node to our new children group
          newChildren.push({
            name: "Drugs " + alphaGroup,
            isGrouping: true,
            children: thisSet
          });
        }
        // replace the old children with the new grouped children
        treeData.children = newChildren;        
      }
      // recursively crawl over the entire tree to break up nodes
      angular.forEach(treeData.children, function (child, index) {
        splitTreeData(child);
      });  
    }
    return treeData;
  }

  // DRAW THE VIZ
  $scope.drawViz = function(){

    // establish the tree & diagonals
    var tree = d3.layout.tree()
      .size([h, w]);
    var diagonal = d3.svg.diagonal()
      .projection(function(d) { return [d.y, d.x]; });

    // create the svg on the page
    // but first, get rid of any old svg (previous draws)
    d3.select($scope.node).selectAll("*").remove();
    vis = d3.select($scope.node).append("svg:svg")
      .attr("width", w + m[1] + m[3])
      .attr("height", h + m[0] + m[2])
      .append("svg:g")
      .attr("transform", "translate(" + m[3] + "," + m[0] + ")");

    update = function(source) {

      // Compute the new tree layout.
      var nodes = tree.nodes(root).reverse();

      // Normalize for fixed-depth.
      nodes.forEach(function(d) { d.y = d.depth * 180; });

      // Update the nodes...
      var node = vis.selectAll("g.node")
          .data(nodes, function(d) { return d.id || (d.id = ++i); });

      // Enter any new nodes at the parent's previous position.
      var nodeEnter = node.enter().append("svg:g")
          .attr("class", "node")
          .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; });

      nodeEnter.append("svg:circle")
          .attr("r", 1e-6)
          .attr("class", function(d) { return d._children ? "node-collapsed" : "node-expanded"; })
          .on("click", function(d) { toggle(d,source); update(d); });

      nodeEnter.append("svg:text")
          .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
          .attr("dy", ".35em")
          .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
          .attr("class", function(d){ return d.drillable ? "drillable" : ""; })
          .text(function(d) { return makeLabel(d); } )
          .style("fill-opacity", 1e-6)
          .on("click", function(d) { navToNode(d); });

      // Transition nodes to their new position.
      var nodeUpdate = node.transition()
          .duration(animationDuration)
          .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

      nodeUpdate.select("circle")
          .attr("r", 6.5)
          .attr("class", function(d) { return d._children ? "node-collapsed" : "node-expanded"; })

      nodeUpdate.select("text")
          .style("fill-opacity", 1);

      // Transition exiting nodes to the parent's new position.
      var nodeExit = node.exit().transition()
          .duration(animationDuration)
          .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
          .remove();

      nodeExit.select("circle")
          .attr("r", 1e-6);

      nodeExit.select("text")
          .style("fill-opacity", 1e-6);

      // Update the links…
      var link = vis.selectAll("path.link")
          .data(tree.links(nodes), function(d) { return d.target.id; });

      // Enter any new links at the parent's previous position.
      link.enter().insert("svg:path", "g")
          .attr("class", "link")
          .attr("d", function(d) {
            var o = {x: source.x0, y: source.y0};
            return diagonal({source: o, target: o});
          })
          .transition()
          .duration(animationDuration)
          .attr("d", diagonal);

      // Transition links to their new position.
      link.transition()
          .duration(animationDuration)
          .attr("d", diagonal);

      // Transition exiting nodes to the parent's new position.
      link.exit().transition()
          .duration(animationDuration)
          .attr("d", function(d) {
            var o = {x: source.x, y: source.y};
            return diagonal({source: o, target: o});
          })
          .remove();

      // Stash the old positions for transition.
      nodes.forEach(function(d) {
        d.x0 = d.x;
        d.y0 = d.y;
      });

    } // update

    root = $scope.data
    root.x0 = h / 2;
    root.y0 = w / 2;

    // Toggle children
    toggle = function (d,source) {
      var collapse = function(n) { n._children = n.children;  n.children  = null; }
      var expand   = function(n) { n.children  = n._children; n._children = null; }
      // d.children: displayed/expanded kids; d._children: hidden/collapsed kids
      if (d.children) {
        collapse(d);
      } else {
        expand(d);
        // check if we are a grouping, and if so, collapse our siblings
        if (d.isGrouping) {
          source.children.forEach(function(sibling,i){
            if (sibling != d && sibling.children) {
              collapse(sibling);
            }
          });
        }
      }
    } // toggle
    toggleAll = function (d) {
      if (d.children) {
        d.children.forEach(toggleAll);
        toggle(d,{});
      }
    } // toggleAll

    // Initialize the display to show a few nodes.
    if (root && root.name) {
      root.children.forEach(toggleAll);
      update(root);
    }

  } // drawViz


  // EVENTS - Tie in to directive/bindings
  $scope.onModelLoaded = function (data) {
    // make sure we have data
    if (data == null || data === []) return;
    $scope.data = splitTreeData(data);
    $scope.drawViz();
  };
  navToNode = function(d){
    $scope.drillOnNode()(d);
  }

}); // controller


app.directive('treeChart', function ($window) {
    var chart = {
        restrict: 'EA',
        scope: {
            series: "=",
            drillOnNode: "&"
        },
        template: '<div style="position: relative;"><svg id="tree_{{$id}}"></svg></div>',
        controller: 'D3TreeController',
        link: function (scope, element, attrs) {
            // Bind this scope to its container in the DOM
            scope.node = element[0];

            // Resize when the window does
            window.onresize = function () {
                scope.$apply();
            };
            scope.$watch(function () {
                return angular.element($window)[0].innerWidth;
            }, function () {
                scope.drawViz();
            });

            // watch for the value to bind
            scope.$watch('series', function (newValue, oldValue) {
                if (newValue) scope.onModelLoaded(newValue);
            });
        }
    }
    return chart;
});