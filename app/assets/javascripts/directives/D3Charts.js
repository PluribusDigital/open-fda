app.controller('D3BarController', function ($scope) {
    $scope.data = [];

    /************************************************************************************************
     * HTML Members
     */
    $scope.domContainer = null;

    $scope.textWidth = function (text) {
        var div = d3.select($scope.node).select('span');
        div.text(text);
        return div.node().clientWidth;
    };

    /************************************************************************************************
     * Graph Properties
     */

    $scope.BAR_HEIGHT = 25;
    $scope.MAX_COUNT_MARGIN = 20;

    $scope.xScale = d3.scale.linear();
    $scope.yScale = d3.scale.ordinal();

    $scope.xAxis = d3.svg.axis().orient("bottom");
    $scope.yAxis = d3.svg.axis().orient("left")

    /************************************************************************************************
    * Bar Properties
    */

    $scope.barX = function (d) 
    { 
        return 0; 
    };

    $scope.barY = function (d) {
        return $scope.yScale(d.label);
    };

    $scope.barWidth = function (d) {
        return $scope.xScale(d.value);
    }

    $scope.barHeight = function (d) {
        return $scope.yScale.rangeBand();
    };

    $scope.barLabel = function (d) {
        return d.label;
    };

    $scope.barValue = function (d) {
        return d.value;
    };

    $scope.barLabelClipped = function (d) {
        label = $scope.barLabel(d);
        clipAt = $scope.barWidth(d);
        fullWidth = $scope.textWidth(label);
        while (fullWidth > clipAt && label != "...") {
            label = label.slice(0, -4) + "...";
            fullWidth = $scope.textWidth(label);
        }

        return label;
    };

    $scope.barToolTip = function (d) {
        return d.label + ' : ' + d.value;
    };

    /************************************************************************************************
    * Main Methods
    */

    $scope.postCreateElement = function (selection) {
        selection.on("click", $scope.onClick)
                 .append("title")
                 .text($scope.barToolTip);
    }

    $scope.renderGraph = function () {
        var container = d3.select($scope.node);
        var node = container.node();
        var width = node.clientWidth;
        var height = ($scope.data.length == 0) ? node.clientHeight : $scope.data.length * $scope.BAR_HEIGHT;

        // 'scale' = The size of the viewport/window
        $scope.xScale.range([0, width - $scope.MAX_COUNT_MARGIN]);
        $scope.yScale.rangeRoundBands([0, height], 0.2);

        $scope.xAxis.scale($scope.xScale);
        $scope.yAxis.scale($scope.yScale);

        // 'domain' = The values to display in the viewport/window
        $scope.xScale.domain([0, d3.max($scope.data, function (d) { return d.value; })]);
        $scope.yScale.domain($scope.data.map(function (d) { return d.label; }));

        // Start building the chart
        var svg = container.select("svg")
                           .attr("width", width)
                           .attr("height", height);

        // Remove the old elements
        svg.selectAll("*").remove();

        // Start the enumeration/bind of the data
        var inserts = svg.append("g")
                         .selectAll(".bar")
                         .data($scope.data)
                         .enter();

        // Draw the bars
        inserts.append("rect")
               .attr("class", "bar")
               .attr("x", $scope.barX)
               .attr("y", $scope.barY)
               .attr("width", $scope.barWidth)
               .attr("height", $scope.barHeight)
               .call($scope.postCreateElement);               

        var yOffset = $scope.yScale.rangeBand() - 4;

        // Draw the label inside the bars
        inserts.append("text")
               .attr("class", "bar-label")
               .text($scope.barLabelClipped)
               .attr("x", $scope.barX)
               .attr("y", $scope.barY)
               .attr("transform", "translate(3," + yOffset + ")")
               .call($scope.postCreateElement);

        // Draw the value at the edge of the bar
        inserts.append("text")
               .attr("class", "bar-value")
               .text($scope.barValue)
               .attr("x", $scope.barWidth)
               .attr("y", $scope.barY)
               .attr("transform", "translate(2," + yOffset + ")")
               .call($scope.postCreateElement);
    };

    /************************************************************************************************
     * Events
     */

    $scope.onModelLoaded = function (data) {
        if (data == null)
            return;

        $scope.data = data;
        $scope.renderGraph();
    };

    $scope.onClick = function (d) {
        $scope.clickTarget()(d.label);
    }
});


app.directive('barchart', function ($window) {
    var chart = {
        restrict: 'EA',
        scope: {
            series: "=",
            clickTarget: "&"
        },
        template: '<div style="position: relative;"><svg id="bar_{{$id}}"></svg><span class="bar-label" style="visibility: hidden; position: absolute; top: 0; left: 0;">measure strings here!</span></div>',
        controller: 'D3BarController',
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
                scope.renderGraph();
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
