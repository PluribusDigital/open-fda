app.controller('D3TreeController', function ($scope) {
  window.D3TreeControllerScope = $scope;

  $scope.data = [];

  /************************************************************************************************
   * HTML Members
   */
  // $scope.domContainer = null;

  /************************************************************************************************
  * Main Methods
  */

  // set up dimensions
  var m = [0, 50, 0, 200]; // margins [top, right, bottom, left]
  var w = 1280 - m[1] - m[3];
  var h =  500 - m[0] - m[2];
  var i = 0;
  var labelMax = 30; // longest size for text labels

  var tree = d3.layout.tree()
    .size([h, w]);

  // tree.separation = function(a,b){return 50;};  

  var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

  $scope.drawViz = function(){

    // get rid of any old svg (previous draws)
    d3.select($scope.node).selectAll("*").remove();

    $scope.vis = d3.select($scope.node).append("svg:svg")
      .attr("width", w + m[1] + m[3])
      .attr("height", h + m[0] + m[2])
      .append("svg:g")
      .attr("transform", "translate(" + m[3] + "," + m[0] + ")");

    $scope.update = function(source) {
      var duration = 500;

      var makeLabel = function(d) {
        var label;
        if (d.type) {label = d.type+": "+d.name;} else {label = d.name;}
        if (label.length > labelMax) {label = label.substring(0,labelMax) + "...";}
        return label;
      }

      // Compute the new tree layout.
      var nodes = tree.nodes(root).reverse();

      // Normalize for fixed-depth.
      nodes.forEach(function(d) { d.y = d.depth * 180; });

      // Update the nodes...
      var node = $scope.vis.selectAll("g.node")
          .data(nodes, function(d) { return d.id || (d.id = ++i); });

      // Enter any new nodes at the parent's previous position.
      var nodeEnter = node.enter().append("svg:g")
          .attr("class", "node")
          .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; });

      nodeEnter.append("svg:circle")
          .attr("r", 1e-6)
          .attr("class", function(d) { return d._children ? "node-collapsed" : "node-expanded"; })
          .on("click", function(d) { $scope.toggle(d,source); $scope.update(d); });

      nodeEnter.append("svg:text")
          .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
          .attr("dy", ".35em")
          .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
          .attr("class", function(d){ if (d.drillable) {return "drillable";} })
          .text(function(d) { return makeLabel(d); } )
          .style("fill-opacity", 1e-6)
          .on("click", function(d) { $scope.navToNode(d); });

      // Transition nodes to their new position.
      var nodeUpdate = node.transition()
          .duration(duration)
          .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

      nodeUpdate.select("circle")
          .attr("r", 6.5)
          .attr("class", function(d) { return d._children ? "node-collapsed" : "node-expanded"; })

      nodeUpdate.select("text")
          .style("fill-opacity", 1);

      // Transition exiting nodes to the parent's new position.
      var nodeExit = node.exit().transition()
          .duration(duration)
          .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
          .remove();

      nodeExit.select("circle")
          .attr("r", 1e-6);

      nodeExit.select("text")
          .style("fill-opacity", 1e-6);

      // Update the links…
      var link = $scope.vis.selectAll("path.link")
          .data(tree.links(nodes), function(d) { return d.target.id; });

      // Enter any new links at the parent's previous position.
      link.enter().insert("svg:path", "g")
          .attr("class", "link")
          .attr("d", function(d) {
            var o = {x: source.x0, y: source.y0};
            return diagonal({source: o, target: o});
          })
        .transition()
          .duration(duration)
          .attr("d", diagonal);

      // Transition links to their new position.
      link.transition()
          .duration(duration)
          .attr("d", diagonal);

      // Transition exiting nodes to the parent's new position.
      link.exit().transition()
          .duration(duration)
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

    // Toggle children.
    $scope.toggle = function (d,source) {
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
      return d;
    }

    $scope.toggleAll = function (d) {
      if (d.children) {
        d.children.forEach($scope.toggleAll);
        $scope.toggle(d,{});
      }
    }

    // Initialize the display to show a few nodes.
    if (root && root.name) {
      root.children.forEach($scope.toggleAll);
      // root.children.forEach($scope.toggle);
      // $scope.toggle(root.children[0]);
      $scope.update(root);
    }

  } // drawViz

  $scope.splitTreeData = function(treeData) {
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
        $scope.splitTreeData(child);
      });  
    }
    return treeData;
  }


// ------
// EVENTS
// ------
    $scope.onModelLoaded = function (data) {
        if (data == null || data === [])
            return;
        $scope.data = $scope.splitTreeData(data);
        $scope.drawViz();
    };
    $scope.navToNode = function(d){
      $scope.drillOnNode()(d);
    }
});


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
                if (newValue)
                    scope.onModelLoaded(newValue);
            });
        }
    }

    return chart;
});