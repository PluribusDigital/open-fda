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

      var duration = d3.event && d3.event.altKey ? 5000 : 500;

      var makeLabel = function(d) {
        var label;
        if (d.type) {
          label = d.type+": "+d.name;
        } else {
          label =  d.name; 
        }
        if (label.length > labelMax) {
          label = label.substring(0,labelMax) + "...";
        }
        return label;
      }

      // Compute the new tree layout.
      var nodes = tree.nodes(root).reverse();

      // Normalize for fixed-depth.
      nodes.forEach(function(d) { d.y = d.depth * 180; });

      // Update the nodes…
      var node = $scope.vis.selectAll("g.node")
          .data(nodes, function(d) { return d.id || (d.id = ++i); });

      // Enter any new nodes at the parent's previous position.
      var nodeEnter = node.enter().append("svg:g")
          .attr("class", "node")
          .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; });

      nodeEnter.append("svg:circle")
          .attr("r", 1e-6)
          .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; })
          .on("click", function(d) { $scope.toggle(d); $scope.update(d); });

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
          .style("fill", function(d) { return d._children ? "#99f" : "#fff"; });

      nodeUpdate.select("text")
          .style("fill-opacity", 1);

      // Transition exiting nodes to the parent's new position.
      // var nodeExit = node.exit().transition()
      //     .duration(duration)
      //     .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
      //     .remove();

      // nodeExit.select("circle")
      //     .attr("r", 1e-6);

      // nodeExit.select("text")
      //     .style("fill-opacity", 1e-6);

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
      // link.exit().transition()
      //     .duration(duration)
      //     .attr("d", function(d) {
      //       var o = {x: source.x, y: source.y};
      //       return diagonal({source: o, target: o});
      //     })
      //     .remove();

      // Stash the old positions for transition.
      nodes.forEach(function(d) {
        d.x0 = d.x;
        d.y0 = d.y;
      });
    } // update

    root = $scope.data
    root.x0 = h / 10;
    root.y0 = 0;

    // Toggle children.
    $scope.toggle = function (d) {
      console.log("f:toggle");
      console.log(d);
      if (d.children) {
        console.log("f:toggle:if:children");
        console.log(d.children);
        d._children = d.children;
        d.children = null;
      } else {
        console.log("f:toggle:if:_children")
        d.children = d._children;
        d._children = null;
      }
      console.log(d);
    }

    $scope.toggleAll = function (d) {
      console.log("f:toggleAll");
      console.log(d);
      if (d.children) {
        d.children.forEach($scope.toggleAll);
        $scope.toggle(d);
      }
    }

    // Initialize the display to show a few nodes.
    if (root && root.name) {
      root.children.forEach($scope.toggleAll);
      root.children.forEach($scope.toggle);
      // $scope.toggle(root.children[0]);
      $scope.update(root);
    }

  } // drawViz


// ------
// EVENTS
// ------
    $scope.onModelLoaded = function (data) {
        if (data == null || data === [])
            return;
        $scope.data = data;
        $scope.drawViz();
    };

    // $scope.onClick = function (d) {
    //   console.log("f:onCLick")
    //     $scope.clickTarget(d.label);
    // }
    $scope.navToNode = function(d){
      console.log("f:navToNode");
      console.log(d);
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