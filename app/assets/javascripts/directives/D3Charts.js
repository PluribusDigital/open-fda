app.controller('D3BarController', function ($scope) {
    $scope.data = [];

    /************************************************************************************************
     * HTML Properties
     */
    $scope.domContainer = null;

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
        return $scope.yScale(d.term);
    };

    $scope.barWidth = function (d) {
        return $scope.xScale(d.count);
    }

    $scope.barHeight = function (d) {
        return $scope.yScale.rangeBand();
    };

    /************************************************************************************************
    * Main Methods
    */

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
        $scope.xScale.domain([0, d3.max($scope.data, function (d) { return d.count; })]);
        $scope.yScale.domain($scope.data.map(function (d) { return d.term; }));

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
               //.on('mouseover', $scope.barTip.show)
               //.on('mouseout', $scope.barTip.hide)
               .on("click", $scope.onClick);

        var yOffset = $scope.yScale.rangeBand() - 4;

        // Draw the label inside the bars
        inserts.append("text")
               .attr("class", "bar-label")
               .text(function (d) { return d.term; })
               .attr("x", $scope.barX)
               .attr("y", $scope.barY)
               .attr("transform", "translate(3," + yOffset + ")")
               .on("click", $scope.onClick);

        // Draw the value at the edge of the bar
        inserts.append("text")
               .attr("class", "bar-value")
               .text(function (d) { return d.count; })
               .attr("x", $scope.barWidth)
               .attr("y", $scope.barY)
               .attr("transform", "translate(2," + yOffset + ")")
               .on("click", $scope.onClick);
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
        $scope.clickTarget()(d.term);
    }
});


app.directive('barchart', function ($window) {
    var chart = {
        restrict: 'EA',
        scope: {
            series: "=",
            clickTarget: "&"
        },
        template: '<svg id="bar_{{$id}}"></svg>',
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