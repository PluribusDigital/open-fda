// D3 code patterned after http://jsfiddle.net/MX7JC/9/
app.controller('D3DonutChartController', function ($scope) {

  $scope.drawChart = function() {


      var data = { label: $scope.data.title, pct: $scope.data.values }
      var labels = $scope.data.labels;

      var w = 300,                       // width and height, natch
          h = 300,
          r = Math.min(w, h) / 2,        // arc radius
          dur = 750,                     // duration, in milliseconds
          color = d3.scale.category10(),
          donut = d3.layout.pie().sort(null),
          arc = d3.svg.arc().innerRadius(r - 70).outerRadius(r - 20);

      // ---------------------------------------------------------------------
      
      // get rid of any old svg (previous draws)
      d3.select($scope.node).selectAll("*").remove();

      var svg = d3.select($scope.node).append("svg:svg")
          .attr("width", w).attr("height", h);

      var arc_grp = svg.append("svg:g")
          .attr("class", "arcGrp")
          .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")");

      var label_group = svg.append("svg:g")
          .attr("class", "lblGroup")
          .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")");

      // GROUP FOR CENTER TEXT
      var center_group = svg.append("svg:g")
          .attr("class", "ctrGroup")
          .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")");

      // CENTER LABEL
      var pieLabel = center_group.append("svg:text")
          .attr("dy", ".35em").attr("class", "chartLabel")
          .attr("text-anchor", "middle")
          .text(data.label);

      // DRAW ARC PATHS
      var arcs = arc_grp.selectAll("path")
          .data(donut(data.pct));
      arcs.enter().append("svg:path")
          .attr("stroke", "white")
          .attr("stroke-width", 0.5)
          .attr("fill", function(d, i) {return color(i);})
          .attr("d", arc)
          .append("title")
          .text(function(d,i) {
            return $scope.data.key_strings[i] +" : "+ $scope.data.values[i] +
            " events";
          })
          .each(function(d) {this._current = d;});

      // DRAW SLICE LABELS
      var sliceLabel = label_group.selectAll("text")
          .data(donut(data.pct));
      sliceLabel.enter().append("svg:text")
          .attr("class", "arcLabel")
          .attr("transform", function(d) {return "translate(" + arc.centroid(d) + ")"; })
          .attr("text-anchor", "middle")
          .text(function(d, i) {
            return d.value > 0 ? labels[i] : "";
          });

      // --------- "PAY NO ATTENTION TO THE MAN BEHIND THE CURTAIN" ---------

      // Store the currently-displayed angles in this._current.
      // Then, interpolate from this._current to the new angles.
      function arcTween(a) {
          var i = d3.interpolate(this._current, a);
          this._current = i(0);
          return function(t) {
              return arc(i(t));
          };
      }

      // update chart
      function updateChart(model) {
          data = eval(model); // which model?

          arcs.data(donut(data.pct)); // recompute angles, rebind data
          arcs.transition().ease("elastic").duration(dur).attrTween("d", arcTween);

          sliceLabel.data(donut(data.pct));
          sliceLabel.transition().ease("elastic").duration(dur)
              .attr("transform", function(d) {return "translate(" + arc.centroid(d) + ")"; })
              .style("fill-opacity", function(d) {return d.value==0 ? 1e-6 : 1;});
              
          pieLabel.text(data.label);
      }

  } // drawChart



// ------
// EVENTS
// ------
    $scope.onModelLoaded = function (data) {
        if (data == null || data === [])
            return;
        $scope.data = data;
        if ($scope.data.values)
          $scope.drawChart();
    };
});


app.directive('donutChart', function ($window) {
    var chart = {
        restrict: 'EA',
        scope: {
            chartData: "="
        },
        template: '<div style="position: relative;"><svg id="donut_chart_{{$id}}"></svg></div>',
        controller: 'D3DonutChartController',
        link: function (scope, element, attrs) {
            // Bind this scope to its container in the DOM
            scope.node = element[0];

            // watch for the value to bind
            scope.$watch('chartData', function (newValue, oldValue) {
                if (newValue)
                    scope.onModelLoaded(newValue);
            });
        }
    }

    return chart;
});
