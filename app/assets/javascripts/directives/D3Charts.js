app.controller('D3BarController', function ($scope) {
    $scope.event_data = [];

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

    $scope.resizeGraph = function () {
        var bbox = d3.select("#viewPort").node().parentNode.getBoundingClientRect();
        var width = bbox.width;
        var height = ($scope.event_data.length == 0) ? bbox.height : $scope.event_data.length * $scope.BAR_HEIGHT;

        $scope.xScale.range([0, width - $scope.MAX_COUNT_MARGIN]);
        $scope.yScale.rangeRoundBands([0, height], 0.2);

        $scope.xAxis.scale($scope.xScale);
        $scope.yAxis.scale($scope.yScale);

        $scope.svg = d3.select("#viewPort")
                       .attr("width", width)
                       .attr("height", height);
    }

    $scope.updateGraph = function (data) {
        $scope.event_data = data;

        $scope.resizeGraph();

        $scope.svg.selectAll("*").remove();

        $scope.xScale.domain([0, d3.max(data, function (d) { return d.count; })]);
        $scope.yScale.domain(data.map(function (d) { return d.term; }));

        var inserts = $scope.svg.append("g")
                                .selectAll(".bar")
                                .data(data)
                                .enter();

        inserts.append("rect")
               .attr("class", "bar")
               .attr("x", $scope.barX)
               .attr("y", $scope.barY)
               .attr("width", $scope.barWidth)
               .attr("height", $scope.barHeight)
               .on("click", $scope.onClick);

        var yOffset = $scope.yScale.rangeBand() - 4;

        inserts.append("text")
               .attr("class", "bar-term")
               .text(function (d) { return d.term; })
               .attr("x", $scope.barX)
               .attr("y", $scope.barY)
               .attr("transform", "translate(3," + yOffset + ")")
               .on("click", $scope.onClick);

        inserts.append("text")
               .attr("class", "bar-count")
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

        $scope.updateGraph(data);
    };

    $scope.onClick = function (d) {
        $scope.clickTarget()(d.term);
    }
});


app.directive('barchart', function () {
    var chart = {
        restrict: 'EA',
        scope: {
            series: "=",
            clickTarget: "&"
        },
//        template: '<table class="table"><tbody><tr ng-repeat="datum in event_data"><th>{{datum.term}}</th><td><a href="" ng-click="onClick(datum.term)">{{datum.count}}</a></td></tr></tbody></table>',
        template: '<svg id="viewPort"></svg>',
        controller: 'D3BarController',
        link: function (scope, element, attrs) {
            // watch for the value to bind
            scope.$watch('series', function (newValue, oldValue) {
                if (newValue)
                    scope.onModelLoaded(newValue);
            });
        }
    }

    return chart;
});