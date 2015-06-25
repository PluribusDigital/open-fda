app.controller('D3TreeController', function ($scope) {
    window.D3TreeControllerScope = $scope;
    $scope.data = [];

    /************************************************************************************************
     * HTML Members
     */
    $scope.domContainer = null;

    
    /************************************************************************************************
    * Main Methods
    */


    $scope.m = [20, 120, 20, 120];
    $scope.w = 1280 - $scope.m[1] - $scope.m[3];
    $scope.h = 800 - $scope.m[0] - $scope.m[2];
    $scope.i = 0;

    $scope.tree = d3.layout.tree()
      .size([$scope.h, $scope.w]);

    $scope.diagonal = d3.svg.diagonal()
      .projection(function(d) { return [d.y, d.x]; });



  $scope.drawViz = function(){

    $scope.vis = d3.select($scope.node).append("svg:svg")
      .attr("width", $scope.w + $scope.m[1] + $scope.m[3])
      .attr("height", $scope.h + $scope.m[0] + $scope.m[2])
      .append("svg:g")
      .attr("transform", "translate(" + $scope.m[3] + "," + $scope.m[0] + ")");

    $scope.root = $scope.data
    $scope.root.x0 = $scope.h / 2;
    $scope.root.y0 = 0;


    $scope.toggleAll = function (d) {
      if (d.children) {
        d.children.forEach($scope.toggleAll);
        toggle(d);
      }
    }


    $scope.update = function(source) {

      var duration = d3.event && d3.event.altKey ? 5000 : 500;

      // Compute the new tree layout.
      var nodes = $scope.tree.nodes($scope.root).reverse();

      // Normalize for fixed-depth.
      nodes.forEach(function(d) { d.y = d.depth * 180; });

      // Update the nodes…
      var node = $scope.vis.selectAll("g.node")
          .data(nodes, function(d) { return d.id || (d.id = ++$scope.i); });

      // Enter any new nodes at the parent's previous position.
      var nodeEnter = node.enter().append("svg:g")
          .attr("class", "node")
          .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
          .on("click", function(d) { toggle(d); $scope.update(d); });

      nodeEnter.append("svg:circle")
          .attr("r", 1e-6)
          .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

      nodeEnter.append("svg:text")
          .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
          .attr("dy", ".35em")
          .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
          .text(function(d) { return d.name; })
          .style("fill-opacity", 1e-6);

      // Transition nodes to their new position.
      var nodeUpdate = node.transition()
          .duration(duration)
          .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

      nodeUpdate.select("circle")
          .attr("r", 4.5)
          .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

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
          .data($scope.tree.links(nodes), function(d) { return d.target.id; });

      // Enter any new links at the parent's previous position.
      link.enter().insert("svg:path", "g")
          .attr("class", "link")
          .attr("d", function(d) {
            var o = {x: source.x0, y: source.y0};
            return $scope.diagonal({source: o, target: o});
          })
        .transition()
          .duration(duration)
          .attr("d", $scope.diagonal);

      // Transition links to their new position.
      link.transition()
          .duration(duration)
          .attr("d", $scope.diagonal);

      // Transition exiting nodes to the parent's new position.
      link.exit().transition()
          .duration(duration)
          .attr("d", function(d) {
            var o = {x: source.x, y: source.y};
            return $scope.diagonal({source: o, target: o});
          })
          .remove();

      // Stash the old positions for transition.
      nodes.forEach(function(d) {
        d.x0 = d.x;
        d.y0 = d.y;
      });
    } // update

    $scope.update($scope.root);

    // Toggle children.
    function toggle(d) {
      if (d.children) {
        d._children = d.children;
        d.children = null;
      } else {
        d.children = d._children;
        d._children = null;
      }
    }

  }


// ------
// EVENTS
// ------
    $scope.onModelLoaded = function (data) {
        if (data == null || data == [])
            return;
        $scope.data = data;
        $scope.drawViz();
    };

    $scope.onClick = function (d) {
        $scope.clickTarget()(d.label);
    }
});


app.directive('treeChart', function ($window) {
    var chart = {
        restrict: 'EA',
        scope: {
            series: "=",
            clickTarget: "&"
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