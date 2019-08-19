/* Data-Viz for Actor Stacked Diagram*/

function actorStacked(){
    // Dimensions
// Create visStacked and svgStacked

    // Adjust width of second graph based on screen width
    console.log("Window width: " + window.innerWidth);
    if (window.innerWidth < 1300)
    {
        var width = 600; // 300
        var move = 0; // 100
    }
    else {
        var width = 600;
        var move = 0;
    }

    var height = 350,
        padding = {left: 50, right: 250, top: 20, bottom: 30},
        xRangeWidth = width - padding.left - padding.right,
        yRangeHeight = height - padding.top - padding.bottom;
    var visStacked = d3.select("#actorStacked")
        .append("div")
        .attr({margin: "10", id: "visStacked"});

    var svgStacked = visStacked.append("svg")
        .attr("width", width)
        .attr("height", height)
        .append("g")
        .attr("transform", "translate(" + [padding.left, padding.top] + ")");


// Selectors using JS (comes from js/select.js, source: https://gitcdn.xyz/repo/cool-Blue/d3-lib/master/inputs/select/select.js")
// Based on documentation:
// isoLines = d3.ui.select({
// base: inputs,
// onUpdate: update,
// data: [{text: "show lines", value: "#ccc"}, {text: "hide lines", value: "none"}]})
//

// Choose Source vs Target
    selectedDataSet = dataSetSource;
        widthp = $("#actorStacked").width();
        heightp = $("#actorStacked").height();
        
    var dataSetSelect = d3.ui.select({
        base: visStacked,
        before: "svgStacked",
        style: ({position: "relative",left:widthp - 240+ "px",top:heightp - 670+ "px", opacity: 0.8}),        
        //style: ({position: "absolute", left: widthp - 950 + "px", top: heightp+950 + "px", color: "black", opacity: 0.8}),
        data: [{text: "Source", value: "dataSetSource"}, {text: "Target", value: "dataSetTarget"}],
        onchange: function() {
            if (dataSetSelect.value() == "dataSetSource") {
                var selectedDataSet = dataSetSource;
            } else if (dataSetSelect.value() =="dataSetTarget") {
                var selectedDataSet = dataSetTarget;
            };
            updateStacked(selectedDataSet);
        }
    }).attr("class", "selector");

// Choose Zero vs. Stacked
    var offsetSelect = d3.ui.select({
        base: visStacked,
        //before: "svgStacked",
        //style: {position: "absolute", left: widthp - 850 - move*0.25 + "px", top: heightp+950 + "px", color: "black", opacity: 0.8},
        style: {position: "relative", left:widthp - 200+ "px" ,top:heightp - 670+ "px",opacity: 0.8},
        onchange: function() {
            if (dataSetSelect.value() == "dataSetSource") {
                var selectedDataSet = dataSetSource;
            } else if (dataSetSelect.value() =="dataSetTarget") {
                var selectedDataSet = dataSetTarget;
            };
            updateStacked(selectedDataSet);
        },
        data: [{text: "Total", value: "zero"}, {text: "Relative", value: "expand"}]
    }).attr("class", "selector");



// Create Stack Layout - Documentation: https://github.com/mbostock/d3/wiki/Stack-Layout
    var stack  = d3.layout.stack()
        .values(function(d) { return d.violence; })
        .x(function(d) { return d.year; })
        .y(function(d) { return d.events; })
        .out(function out(d, y0, y) {
                d.p0 = y0;
                d.y = y;
            }
        );

// Axes
// x Axis
    var xPadding = {inner: 0.1, outer: 0.3};
    var xScale   = d3.scale.ordinal()
        .rangeBands([0, xRangeWidth], xPadding.inner, xPadding.outer);
    var xAxis    = d3.cbPlot.d3Axis()
        .scale(xScale)
        .orient("bottom");
    var xAxis_group  = svgStacked.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + yRangeHeight + ")")
        .style({"pointer-events": "none", "font-size": "12px"});
// y Axis
    var yAxisScale = d3.scale.linear()
        .range([yRangeHeight, 0]);
    var yAxis = d3.cbPlot.d3Axis()
        .scale(yAxisScale)
        .orient("left")
        .tickSubdivide(1);
    var yAxis_group = svgStacked.append("g")
        .attr("class", "y axis")
        .style({"pointer-events": "none", "font-size": "12px"});

    var yScale = d3.scale.linear()
        .range([0, yRangeHeight]);

//var yAxisTransition = 1000;

// Color scale (sames as ViolenceMap and ActorChord)
    var color = d3.scale.ordinal()
        //.range(["#1f78b4","#b2df8a","#e31a1c","#33a02c","#a6cee3","#fdbf6f","#ff7f00","#fb9a99"]);
        //.range(['#377eb8', '#4daf4a', '#e41a1c', '#ff7f00', '#ff08e8', '#a65628', '#ffff33', '#666666']);
        .range(['#377eb8', '#a65628', '#ffff33', '#4daf4a', '#e41a1c', '#ff7f00', '#ff08e8', '#666666']);


    function updateStacked(dataSet) {
        var normData = stack.offset("expand")(dataSet)
            .map(stack.values())
            .map(function(s) {
                return s.map(function(p) {return p.yNorm = p.y})
            });

        var stackedData  = stack.offset(offsetSelect.value())
            .order("default")(dataSet);

        var max_Y = d3.max(stackedData, function(d) {
            return d3.max(d.violence, function(s) {
                return s.events + s.p0
            })
        });

        var years = stackedData[0].violence.map(stack.x()),
            yearlyTotals = years.reduce(function(t, y) {
                return (t[y] = d3.sum(stackedData, function(o) {
                    return o.violence.filter(function(s) {
                        return s.year == y
                    })[0].events
                }), t)
            }, {});

        // Scales
        xScale.domain(years);
        yAxisScale.reset = function(){
            this.domain([0, offsetSelect.value() == "expand" ? 1 : max_Y])
                .range([yRangeHeight, 0])
                .ticks(10)

        };
        yAxisScale.reset();
        yScale.domain(yAxisScale.domain());

        var stackedArea = svgStacked.selectAll(".stackedArea")
            .data([stackedData]);

        stackedArea.enter().insert("g", ".axis")
            .attr(d3.cbPlot.transplot(yRangeHeight))
            .attr("class", "stackedArea");

        // (3) Add elements

        // Selectors labels


        svgStacked.append("text")
            .text("DATA TYPE")
            .attr("transform", "translate("+ (320) +","+(0)+")rotate(0)")
            .attr("fill", "white");

        svgStacked.append("text")
            .text("CHART TYPE")
            .attr("transform", "translate("+ (420) +","+(0)+")rotate(0)")
            .attr("fill", "white");

        svgStacked.append("text")
            .text("Jan-Apr")
            .attr("transform", "translate("+ (230) +","+(335)+")rotate(0)")
            .attr("fill", "lightgray");


        // Add Y label
        svgStacked.append("text")
            .text("Violence events")
            .attr("transform", "translate("+ (15) +","+(100)+")rotate(-90)")
            .attr("fill", "white");

        // Add Series
        stackedArea.series = stackedArea.selectAll(".series")
            .data(ID);
        stackedArea.series.enter()
            .append("g")
            .attr("class", "series");
        stackedArea.series.style("fill", function(d, i) {
            return color(i);
        });
        stackedArea.series.exit().remove();

        Object.defineProperties(stackedArea.series, d3._CB_selection_destructure);

        // Add Components
        stackedArea.series.components = stackedArea.series.selectAll(".components")
            .data(function(d) {
                return d3.entries(d);
            });
        stackedArea.series.components.enter().append("g")
            .attr("class", function(d){return d.key})
            .classed("components", true);
        stackedArea.series.components.exit().remove();

        // Add Values
        stackedArea.series.components.values = stackedArea.series.components.filter(function(d){
            return d.key == "violence"
        });
        Object.defineProperties(stackedArea.series.components.values, d3._CB_selection_destructure);

        // Add Labels
        stackedArea.series.components.labels = stackedArea.series.components.filter(function(d){
                return d.key == "name"
            })
            // reverse the stackedArea transform (it is it's own inverse)
            .attr(d3.cbPlot.transplot(yRangeHeight));
        Object.defineProperties(stackedArea.series.components.labels, d3._CB_selection_destructure);

        var s = xScale.rangeBand();

        var w = s - xPadding.inner;

        var drag = d3.behavior.drag()
            .on("dragstart", mouseOver);

        var points = stackedArea.series.components.values.points = stackedArea.series.components.values.selectAll("rect")
            .data(function(d){return d.value});

        points.enter()
            .append("rect")
            .attr({width: w, class: "point"})
            .on("mouseover", mouseOver)
            .on("mouseout", mouseOut)
            .call(drag);
        points.transition()
            .attr("x", function(d) {
                return xScale(d.year);
            })
            .attr("y", function(d) {
                return yScale(d.p0);
            })
            .attr("height", function(d) {
                return yScale(d.y);
            })
            .attr("stroke", "");

        points.exit().remove();

        Object.defineProperties(stackedArea.series.components.values.points, d3._CB_selection_destructure);

        // Axes transitions
        xAxis_group.transition().call(xAxis);
        yAxis_group.transition().call(yAxis);

        // (4) Mouse events

        // MOUSEOVER
        function mouseOver(pointData, pointIndex, groupIndex) {
            var selectedYear = pointData.year,

            // Wrap the node in a selection with the proper parent
                plotData = stackedArea.series.components.values.data,
                seriesData = plotData[groupIndex],
                currentYear = d3.transpose(plotData)[pointIndex],
                point         = stackedArea.series.components.values.points.nodes[groupIndex][pointIndex];

            window.setTimeout(tooltipStacked, 0); // Y axis static

            // Add Highlighting
            // 1. Points
            stackedArea.series.transition("fade")
                .attr("opacity", function(d, i) {
                    return i == groupIndex ? 1 : 0.2;
                });
            /* 2. X axis highlighting
             d3.selectAll(".x.axis .tick")
             .filter(function(d) {return d == selectedYear})
             .classed("highlight", true); */

            // 3. Move the selected element to the front
            d3.select(this.parentNode)
                .moveToFront();

            xAxis_group.moveToFront();

            // 4. Legend
            legendText(groupIndex);
            // TooltipStacked
            function tooltipStacked() {
                stackedArea.series
                    .append("g")
                    .attr("class", "tooltipStacked")
                    .attr("transform", "translate(" + [point.attr("x"), point.attr("y")] + ")")
                    .append("text")
                    .attr(d3.cbPlot.transflip())
                    //.text(d3.format(",d")(pointData.events))
                    .text(d3.format(">8.0%")(pointData.yNorm))
                    .attr({x: "1.15em", y: -point.attr("height") / 2, dy: ".35em", opacity: 0})
                    .transition("tooltipStacked").attr("opacity", 1)
                    .style({fill: "white", "pointer-events": "none"})
            }
        }

        // MOUSEOUT
        function mouseOut(d, nodeIndex, groupIndex) {
            var year = d.year;

            d3.selectAll(".x.axis .tick")
                .filter(function(d) {
                    return d == year
                })
                .classed("highlight", false);

            stackedArea.series.transition("fade")
                .attr({opacity: 1});

            var g = stackedArea.series.components.labels.nodes[groupIndex][0].select("text");
            g.classed("highlight", false);
            g.text(g.text().split(":")[0]);

            yAxisScale.reset();

            yAxis_group.selectAll(".minor").remove();

            yAxis_group
                .call(yAxis)
                //.transition("axis")
                .attr("transform", "translate(0,0)")
                .style({"font-size": "12px"})
                .call(function(t) {d3.select(t.node()).classed("fly-in", false)});

            stackedArea.series.selectAll(".tooltipStacked")
                .transition("tooltipStacked")
                .attr({opacity: 0})
                .remove();

            points.transition("points").attr("y", function(d) {
                return yScale(d.p0);
            })
        };


        var labHeight = 30,
            labRadius = 10;


        // Create the circles

        var labelCircle = stackedArea.series.components.labels.selectAll("circle")
            .data(function(d){return [d.value]});

        // Use the order created in stackedData
        var orderStacked = stackedData.map(function(d) {return {name: d.name, base: d.violence[0].p0}})
            .sort(function(a, b) {return b.base - a.base})
            .map(function(d) {return stackedData.map(function(p) {return p.name}).indexOf(d.name)}).reverse();

        // Add the circles and mouseover/mouseout
        labelCircle.enter().append("circle")
            .on("mouseover", function(pointData, pointIndex, groupIndex) {
                var node = this,
                    typicalP0 = d3.median(stackedArea.series.components.values.data[groupIndex],
                        function(d){return d.p0});
                stackedArea.series.components.values.points.transition("points")
                    .attr("y", alignY(typicalP0, groupIndex));
                stackedArea.series.transition("fade")
                    .attr("opacity", function(d) {
                        return d === d3.select(node.parentNode.parentNode).datum() ? 1 : 0.2;
                    });
                legendText(groupIndex);
            })
            .on("mouseout", function(pointData, pointIndex, groupIndex) {
                stackedArea.series.transition("fade")
                    .attr({opacity: 1});
                stackedArea.series.components.values.points.transition("points").attr("y", function(d) {
                    return yScale(d.p0);
                })
            });

        labelCircle.attr("cx", xRangeWidth + 20)
            .attr("cy", function(d, i, j) {return labHeight * orderStacked[j] + 80;})
            .attr("r", labRadius);

        // Add text to the labels
        var labelText = stackedArea.series.components.labels.selectAll("text")
            .data(function(d){return [d.value]});
        labelText.enter().append("text");
        labelText.attr("x", xRangeWidth + 40)
            .attr("y", function(d, i, j) {
                return labHeight * orderStacked[j] + 80;
            })
            .attr("dy", labRadius / 2)
            .text(function(d) {
                return d;
            });

        function legendText(groupIndex){
            var labelText = stackedArea.series.components.labels.nodes[groupIndex][0].select("text"),
                seriesData = stackedArea.series.components.values.data[groupIndex],
                format = [">8,.0f", ">8.0%"][(offsetSelect.value() == "expand") * 1];
            labelText.classed("highlight", true);
            labelText.text(labelText.datum().value + ": " + d3.format(format)(
                    offsetSelect.value() != "expand" ?
                        d3.sum(seriesData, stack.y()) :
                        d3.sum(seriesData, function(s) {
                            var totalViolence = d3.sum(d3.values(yearlyTotals));
                            return s.y * yearlyTotals[s.year] / totalViolence
                        })
                ));
        }

        function alignY(p0, series) {
            var offsets = stackedArea.series.components.values.data[series].map(function(d) {
                return p0 - d.p0;
            });
            return function(d, i) {
                return yScale(d.p0 + offsets[i]);
            }
        }

        function aID(d) {
            return [d];
        }
        function ID(d) {
            return d;
        }
    }


// Auxiliary functions

    d3.selection.prototype.moveToFront = function() {
        return this.each(function() {
            this.parentNode.appendChild(this);
        });
    };
    d3._CB_selection_destructure = {
        "nodes": {
            get: function() {
                return this.map(function(g) {
                    return g.map(function(n) {
                        return d3.select(n)
                    })
                })
            }
        },
        data: {
            get: function() {
                return this.map(function(g) {
                    return d3.select(g[0]).datum().value
                })
            }
        }
    };

// updateStacked with the selected database
    updateStacked(selectedDataSet);
    window.setTimeout(function(){
        updateStacked(selectedDataSet.map(function(d) {
                return {
                    name: d.name, violence: d.violence.map(function(y) {
                        return {year: y.year, events: y.events }
                    })
                }
            })
        )
    },1000);

// endAll
    function endAll(transition, callback) {
        var n = 0;
        transition
            .each(function() { ++n; })
            .each("end.endAll", function() { if (!--n) callback.apply(this, arguments); });
        if(transition.empty()) callback();
    }
}
