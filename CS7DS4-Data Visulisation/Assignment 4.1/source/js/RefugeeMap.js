
RefugeeMap = function(_parentElement, _mapdata, _campdata){
    this.parentElement = _parentElement;
    this.mapdata = _mapdata;
    this.campdata = _campdata;
    this.displayData = []; // see data wrangling

    var iso = d3.time.format.iso;

    this.campdata.forEach(function(d) {
        d.date = iso.parse(d.date);
    });

    this.campdata.sort(function(a,b){
        return a.date - b.date;
    });

    this.initVis();
};

RefugeeMap.prototype.initVis = function() {
    var vis = this;
    var properstring = function(d){return d.replace(" ",'').replace(" ",'');};

    // -------------------------------------------------------------------------
    // SVG Drawing area
    // -------------------------------------------------------------------------
    vis.margin = {top: 22, right: 20, bottom: 20, left: 20};
    vis.width = $("#" + vis.parentElement).width() - vis.margin.left - vis.margin.right;
    vis.height = 500 - vis.margin.top - vis.margin.bottom;

    // SVG drawing area
    vis.svg = d3.select("#" + vis.parentElement).append("svg")
        .attr("width", vis.width + vis.margin.left + vis.margin.right)
        .attr("style","border-radius: 25px; ,border: 2px solid #73AD21;")
        .attr("height", vis.height + vis.margin.top + vis.margin.bottom);

    vis.mapg = vis.svg.append("g")
        .attr("transform", "translate(" + vis.margin.left + "," + vis.margin.top + ")");
    //.attr("transform", "translate(0,0)");

    vis.mapg.append("defs").append("clipPath")
        .attr("id", "clip")
        .append("rect")
        .attr("width", vis.width)
        .attr("height", vis.height);

    // ----------------------------------------------------------------------------------------
    // Tooltips initialize
    // ----------------------------------------------------------------------------------------

    vis.tooltip = {
        element: null,
        init: function () {
            this.element = d3.select("body").append("div").attr("class", "rmtooltip").attr("id","camptooltip")
                .style("opacity", 0);
        },
        show: function(t) {
            this.element.html(t).transition().duration(200).style("left", d3.event.pageX + 10 + "px").style("top", d3.event.pageY - 10 + "px").style("opacity", .9);
        },
        move: function() {
            this.element.transition().duration(30).ease("linear").style("left", d3.event.pageX + 10 + "px").style("top", d3.event.pageY - 10 + "px").style("opacity", .9);
        },
        hide: function () {
            this.element.transition().duration(500).style("opacity", 0)
        }
    };

    vis.tooltip.init();

    // -------------------------------------------------------------------------
    // Initialize map projection (Region map created by Maria)
    // -------------------------------------------------------------------------
    vis.projection = d3.geo.mercator().translate([vis.width / 2, vis.height / 2]).scale(2200).center([38.3, 34]);
    vis.path = d3.geo.path().projection(vis.projection);
    vis.graticule = d3.geo.graticule();

    var merge = d3.set([7,9]);

    var names = ["Armenia", "1", "Cyprus (Turkey)", "Cyprus (Greece)", "Egypt", "Gaza", "6", "Iran", "Israel", "Jordan", "Lebanon", "Saudi Arabia", "14", "Syria", "Turkey", "West Bank"];

    // Render country shapes
    vis.countries = vis.mapg.selectAll(".land")
        //.data(topojson.feature(vis.mapdata, vis.mapdata.objects.subunits).features)
        .data(topojson.feature(vis.mapdata, vis.mapdata.objects.subunits).features.filter(function(d,i){return (i!=7) & (i!=9)}))
        .enter().append("path")
        .style("fill", function (d, i) {
            return "darkgrey";
        })
        .style("stroke", "white")
        .style("stroke-width", "2px")
        .attr("class", "land" )
        .attr("id", function(d,i){return "id_"+i;})
        .attr("d", vis.path);

    // Show country information
    //vis.countryname = {TUR: "Turkey", IRQ: "Iraq", JOR: "Jordan", LBN: "Lebanon", EGY: "Egypt"};

    vis.countries
        .on("mouseover", function (d,i) {
            vis.tooltip.show(function () {
                return "<span>" + names[i] + "</span>";
            })
        })
        .on("mousemove", function (d, i) {
            vis.tooltip.move();
        })
        .on("mouseout", function (d, i) {
            vis.tooltip.hide();
        });


    // Render country boundaries
    var merge = d3.set([7,9]);

    vis.mapg.append("path")
        .datum(topojson.merge(vis.mapdata, vis.mapdata.objects.subunits.geometries.filter(function(d, i) {
            return merge.has(i); })))
        .attr("class", "land" )
        .style("fill", function(d, i) {
            d.countryid = i;
            return "darkgrey";})
        .style("stroke", "white")
        .style("stroke-width", "2px")
        .attr("d", vis.path)
        .on("mouseover", function (d, i) {
            vis.tooltip.show(function(){
                return "<span>" + "Iraq" + "</span>";
            })
        })
        .on("mousemove", function (d, i) {
            vis.tooltip.move();})
        .on("mouseout", function (d, i) {
            vis.tooltip.hide();});

    // -------------------------------------------------------------------------
    // Legend
    // -------------------------------------------------------------------------
    vis.radius = d3.scale.sqrt()
        .domain([8, d3.max(vis.campdata, function(d){
            return d.refugee;
        })])
        .range([5,55]);

    vis.legend = vis.svg.append("g")
        .attr("class", "legend")
        .attr("transform", "translate(" + 60 + "," + (vis.height - vis.height/5) + ")")
        .selectAll("g")
        .data([100000, 1000000, 3000000])
        .enter().append("g");

    vis.legend.append("circle")
        .attr("class","legend-circle")
        .attr("cy", function(d) { return -vis.radius(d); })
        .attr("r", vis.radius);

    vis.legend.append("text")
        .attr("class","legend-text")
        .attr("y", function(d) { return -2 * vis.radius(d); })
        .attr("dy", "-0.5em")
        .attr("dx","-0.8em")
        .attr("anchor","center")
        .text(d3.format("s"));

    vis.jitter = 0.1;
    vis.nordist = d3.random.normal(0,1);

    vis.campById = {};
    vis.campdata.forEach(function (d) {
        vis.campById[d.level_3] = d
    });

    for (var key in vis.campById) {var value = vis.campById[key];}

    Object.keys(vis.campById).forEach(function(key){
        var val = vis.campById[key];
    });

    vis.vals = Object.keys(vis.campById).map(function (key) {
        return vis.campById[key];
    });

    vis.force = d3.layout.force()
        //  .gravity(0)
        .charge(0.1)
        .nodes(vis.vals)
        .size([0, 0])
        .start();


    var colores_g = ['#377eb8', '#4daf4a', '#e41a1c', '#ff7f00', '#ff08e8'];

    vis.colorScale = d3.scale.ordinal().range(colores_g);

    vis.colorScale
        .domain(["JOR","IRQ","TUR","LBN","EGY"]);

    vis.filter="";

    vis.begincamps = vis.mapg.selectAll(".beginbubbles")
        .data(vis.vals, function(d, index){return d.level_3;})
        .enter().append("g")
        .attr("id", function(d){
            return properstring(d.level_3);
        })
        .attr("class",function(d){
            return "bubble"+properstring(d.level_1);
        })
        .attr("fill", function(d){
            //return (d3.scale.category20().domain(["JOR","IRQ","TUR","LBN","EGY"])(d.level_1));
            return vis.colorScale(d.level_1);
        });

    vis.begincamps
        .append("circle")
        .attr("class","beginbubbles")
        .attr("r",function(d){
            return vis.radius(d.refugee);
        })
        //.attr("fill","red")
        .attr("opacity",0.7)
        .attr("transform",function(d){
            return "translate(" + vis.projection([d.longti, d.lati])+")";
            //return "translate(" + vis.projection([d.longti+vis.nordist()*vis.jitter, d.lati+vis.nordist()*vis.jitter]) + ")";
        })
        .style("stroke-width", 1)
        .style("stroke","white")
        .on("click",function(d){

            if (d.level_3=="Turkey") {
                vis.filter = "TUR";
                refugeestacked.selectValue = "level_1";
                d3.selectAll('.cp_button').classed('selected', false);
                d3.selectAll('.cp_button_fix').classed('selected', false);
                d3.select("#level_1").classed('selected',true);
            }
            else if (d.level_3=="Egypt") {
                vis.filter="EGY";
                refugeestacked.selectValue = "level_1";
                d3.selectAll('.cp_button').classed('selected', false);
                d3.selectAll('.cp_button_fix').classed('selected', false);
                d3.select("#level_1").classed('selected',true);
            }
            else {
                vis.filter = d.level_3;
                refugeestacked.selectValue = "level_3";
                d3.selectAll('.cp_button').classed('selected', false);
                d3.selectAll('.cp_button_fix').classed('selected', false);
                d3.select("#level_3").classed('selected',true);
            }

            // This is to update the text
            d3.select("#category1").text(function(){
                if (d.level_3 == "TUR" || d.level_3=="JOR" || d.level_3=="EGY"|| d.level_3=="LBN" || d.level_3=="IRQ") {
                    return refugeestacked.countryname[d.key];
                }
                else if (d.level_3 == "Turkey" || d.level_3=="Egypt") {
                    return d.level_3;
                }
                else{
                    return refugeestacked.countryname[refugeestacked.campById[d.level_3]["level_1"]] + ": " + d.level_3;
                }
            });

            d3.select("#category2").text(function(){
                if (d.level_3 == "TUR" || d.level_3=="JOR" || d.level_3=="EGY"|| d.level_3=="LBN" || d.level_3=="IRQ") {
                    return d3.format(",")(refugeestacked.countryById[d.key]["sum_1"])  + " | Apr-16";
                }
                else if (d.level_3 == "Turkey" || d.level_3=="Egypt") {
                    return d3.format(",")(refugeestacked.campById[d.level_3]["sum_1"])  + " | Apr-16";
                }
                else{
                    return d3.format(",")(refugeestacked.campById[d.level_3]["sum_3"])  + " | Apr-16";
                }
            });

            d3.select("#category3").text(function(){
                if (d.level_3 == "Aqaba" || d.level_3 == "Maan" || d.level_3 == "Tafilah"|| d.level_3=="Dispersed2" ||
                    d.level_3 == "Karak" || d.level_3 == "Azraq Camp" || d.level_3 == "Amman" || d.level_3 == "Madaba" ||
                    d.level_3 == "Balqa" || d.level_3 == "Ajlun" || d.level_3 == "Jarash") {
                    return "Only the last data point";
                }
                else {
                    return "";
                }
            });

            refugeestacked.filter = (refugeestacked.filter == vis.filter) ? "":vis.filter;
            refugeestacked.wrangleData();
        })
        .call(vis.force.drag);

    vis.force.on("tick", function() {
        vis.begincamps.attr(
            "transform",
            function(d) { return "translate(" + d.x + "," + d.y + ")"; }
        )});

    vis.begincamps.on("mouseover",function(d){
        vis.tooltip.show(function () {
                return "<span>" + d.level_3 + "</span>";
            })
        });

    vis.begincamps.on("mousemove",function(d,i){
        vis.tooltip.move();
        vis.begincamps.attr("opacity",0.4);
        refugeestacked.legend.attr("opacity",0.2);
        refugeestacked.categories.attr("opacity",0.2);

        d3.select(this).attr("opacity",1);
        d3.select("#legend"+properstring(d.level_1)).attr("opacity",1);
        d3.select("#area"+properstring(d.level_3)).attr("opacity",1);
        d3.select("#area"+properstring(d.level_1)).attr("opacity",1)})

        .on("mouseout",function(d,i){
            vis.tooltip.hide();
            vis.begincamps.attr("opacity",1);
            d3.select("#area"+properstring(d.level_3)).attr("opacity",1);
            d3.select("#area"+properstring(d.level_1)).attr("opacity",1);
            refugeestacked.legend.attr("opacity",1);
            refugeestacked.categories.attr("opacity",1);

        });

    // -------------------------------------------------------------------------
    // Initialize play button / slider
    // -------------------------------------------------------------------------
    vis.startvalue = d3.min(vis.campdata, function(d){return d.date});
    vis.currentTime = vis.startvalue;
    vis.endvalue = d3.max(vis.campdata,function(d){return d.date});

    vis.running = false;
    $("#playcamp").on("click", function(){
        refugeemap.clickevent = true;
        brushed_refugeemap();
        refugeemap.begincamps.transition().duration(100).remove();});
};

RefugeeMap.prototype.wrangleData = function() {
    var vis = this;
    var properstring = function(d){return d.replace(" ",'').replace(" ",'');};

    // -------------------------------------------------------------------------
    // Filter data (-1 period)
    // -------------------------------------------------------------------------

    vis.displayData = vis.campdata.filter(function(d){
        return (d.date >= (d3.time.day.offset(vis.currentTime,-1)))
            && (d.date <= vis.currentTime);
    });

    vis.updateVis();
};

RefugeeMap.prototype.updateVis = function() {
    var vis = this;
    var properstring = function(d){return d.replace(" ",'').replace(" ",'');};


    if (timeslide.currentTime >= vis.endvalue) {

        vis.mapg.selectAll(".bubbles").remove();

        vis.begincamps = vis.mapg.selectAll(".beginbubbles")
            .data(vis.vals, function(d, index){return d.level_3;})
            .enter().append("g")
            .attr("id", function(d){
                return properstring(d.level_3);
            })
            .attr("class",function(d){
                return "bubble"+properstring(d.level_1);
            });

        vis.begincamps
            .append("circle")
            .attr("class","beginbubbles")
            .attr("r",function(d){
                return vis.radius(d.refugee);
            })
            //.attr("fill","red")
            .attr("fill", function(d){
                return vis.colorScale(d.level_1);
            })
            .attr("opacity",0.7)
            .attr("transform",function(d){
                return "translate(" + vis.projection([d.longti, d.lati])+")";
                //return "translate(" + vis.projection([d.longti+vis.nordist()*vis.jitter, d.lati+vis.nordist()*vis.jitter]) + ")";
            })
            .style("stroke-width", 1)
            .style("stroke","white")
            .on("click",function(d){

                d3.selectAll('.cp_button').classed('selected', false);
                d3.selectAll('.cp_button_fix').classed('selected', false);
                d3.select("#level_3").classed('selected',true);

                if (d.level_3=="Turkey") {
                    vis.filter = "TUR";
                    refugeestacked.selectValue = "level_1";
                    d3.selectAll('.cp_button').classed('selected', false);
                    d3.selectAll('.cp_button_fix').classed('selected', false);
                    d3.select("#level_1").classed('selected',true);
                }
                else if (d.level_3=="Egypt") {
                    vis.filter="EGY";
                    refugeestacked.selectValue = "level_1";
                    d3.selectAll('.cp_button').classed('selected', false);
                    d3.selectAll('.cp_button_fix').classed('selected', false);
                    d3.select("#level_1").classed('selected',true);
                }
                else {
                    vis.filter = d.level_3;
                    refugeestacked.selectValue = "level_3";
                    d3.selectAll('.cp_button').classed('selected', false);
                    d3.selectAll('.cp_button_fix').classed('selected', false);
                    d3.select("#level_3").classed('selected',true);
                }

                // This is to update the text
                d3.select("#category1").text(function(){
                    if (d.level_3 == "TUR" || d.level_3=="JOR" || d.level_3=="EGY"|| d.level_3=="LBN" || d.level_3=="IRQ") {
                        return refugeestacked.countryname[d.key];
                    }
                    else if (d.level_3 == "Turkey" || d.level_3=="Egypt") {
                        return d.level_3;
                    }
                    else{
                        return refugeestacked.countryname[refugeestacked.campById[d.level_3]["level_1"]] + ": " + d.level_3;
                    }
                });

                d3.select("#category2").text(function(){
                    if (d.level_3 == "TUR" || d.level_3=="JOR" || d.level_3=="EGY"|| d.level_3=="LBN" || d.level_3=="IRQ") {
                        return d3.format(",")(refugeestacked.countryById[d.key]["sum_1"])  + " | Apr-16";
                    }
                    else if (d.level_3 == "Turkey" || d.level_3=="Egypt") {
                        return d3.format(",")(refugeestacked.campById[d.level_3]["sum_1"])  + " | Apr-16";
                    }
                    else{
                        return d3.format(",")(refugeestacked.campById[d.level_3]["sum_3"])  + " | Apr-16";
                    }
                });

                d3.select("#category3").text(function(){
                    if (d.level_3 == "Aqaba" || d.level_3 == "Maan" || d.level_3 == "Tafilah"|| d.level_3=="Dispersed2" ||
                        d.level_3 == "Karak" || d.level_3 == "Azraq Camp" || d.level_3 == "Amman" || d.level_3 == "Madaba" ||
                        d.level_3 == "Balqa" || d.level_3 == "Ajlun" || d.level_3 == "Jarash") {
                        return "Only the last data point";
                    }
                    else {
                        return "";
                    }
                });

                //refugeestacked.filter = vis.filter;
                refugeestacked.filter = (refugeestacked.filter == vis.filter) ? "":vis.filter;
                refugeestacked.wrangleData();
            })
            .call(vis.force.drag);

        vis.force.on("tick", function() {
            vis.begincamps.attr(
                "transform",
                function(d) { return "translate(" + d.x + "," + d.y + ")"; }
            )});

        vis.begincamps.on("mouseover",function(d){
            vis.tooltip.show(function () {
                return "<span>" + d.level_3 + "</span>";
            });
        });

        vis.begincamps.on("mousemove",function(d,i){
                vis.tooltip.move();
                vis.begincamps.attr("opacity",0.4);
                refugeestacked.legend.attr("opacity",0.2);
                refugeestacked.categories.attr("opacity",0.2);

                d3.select(this).attr("opacity",1);
                d3.select("#legend"+properstring(d.level_1)).attr("opacity",1);
                d3.select("#area"+properstring(d.level_3)).attr("opacity",1);
                d3.select("#area"+properstring(d.level_1)).attr("opacity",1);})

    .on("mouseout",function(d,i){
                vis.tooltip.hide();
                vis.begincamps.attr("opacity",1);

                d3.select("#area"+properstring(d.level_1)).attr("opacity",1);
                d3.select("#area"+properstring(d.level_3)).attr("opacity",1);
                refugeestacked.legend.attr("opacity",1);
                refugeestacked.categories.attr("opacity",1);
    });

    } else {

        // -------------------------------------------------------------------------
        // Enter, update, exit sequence for camp circles
        // -------------------------------------------------------------------------

        vis.mapg.selectAll(".beginbubbles").remove();

        vis.camps = vis.mapg.selectAll(".bubbles")
            .data(vis.displayData, function (d, index) {
                return d.level_3;
            });

        vis.camps
            .enter().append("circle")
            .attr("class",function(d){
                return "bubbles bubble"+properstring(d.level_1);
            })
            .attr("transform", function (d) {
                return "translate(" + vis.projection([d.longti, d.lati]) + ")";
            });

        vis.camps
            .transition()
            .duration(50)
            //.attr("fill", "red")
            .attr("fill", function (d) {
                return refugeestacked.colorScale(d.level_1);
            })
            .attr("r", function (d) {
                return vis.radius(d.refugee);
            })
            .style("stroke-width", 1)
            .style("stroke", "white")
            .attr("opacity", 0.7);
        //.style("stroke-width", 0);

        vis.camps
            .on("click", function (d) {
                if (d.level_3 == "Turkey") {
                    vis.filter = "TUR";
                    refugeestacked.selectValue = "level_1";
                    d3.selectAll('.cp_button').classed('selected', false);
                    d3.selectAll('.cp_button_fix').classed('selected', false);
                    d3.select("#level_1").classed('selected',true);
                }
                else if (d.level_3 == "Egypt") {
                    vis.filter = "EGY";
                    refugeestacked.selectValue = "level_1";
                    d3.selectAll('.cp_button').classed('selected', false);
                    d3.selectAll('.cp_button_fix').classed('selected', false);
                    d3.select("#level_1").classed('selected',true);
                }
                else {
                    vis.filter = d.level_3;
                    refugeestacked.selectValue = "level_3";
                    d3.selectAll('.cp_button').classed('selected', false);
                    d3.selectAll('.cp_button_fix').classed('selected', false);
                    d3.select("#level_3").classed('selected',true);
                }

                // This is to update the text
                d3.select("#category1").text(function () {
                    if (d.level_3 == "TUR" || d.level_3 == "JOR" || d.level_3 == "EGY" || d.level_3 == "LBN" || d.level_3 == "IRQ") {
                        return refugeestacked.countryname[d.key];
                    }
                    else if (d.level_3 == "Turkey" || d.level_3 == "Egypt") {
                        return d.level_3;
                    }
                    else {
                        return refugeestacked.countryname[refugeestacked.campById[d.level_3]["level_1"]] + ": " + d.level_3;
                    }
                });

                d3.select("#category2").text(function () {
                    if (d.level_3 == "TUR" || d.level_3 == "JOR" || d.level_3 == "EGY" || d.level_3 == "LBN" || d.level_3 == "IRQ") {
                        return d3.format(",")(refugeestacked.countryById[d.key]["sum_1"]) + " | Apr-16";
                    }
                    else if (d.level_3 == "Turkey" || d.level_3 == "Egypt") {
                        return d3.format(",")(refugeestacked.campById[d.level_3]["sum_1"]) + " | Apr-16";
                    }
                    else {
                        return d3.format(",")(refugeestacked.campById[d.level_3]["sum_3"]) + " | Apr-16";
                    }
                });

                d3.select("#category3").text(function(){
                    if (d.level_3 == "Aqaba" || d.level_3 == "Maan" || d.level_3 == "Tafilah"|| d.level_3=="Dispersed2" ||
                        d.level_3 == "Karak" || d.level_3 == "Azraq Camp" || d.level_3 == "Amman" || d.level_3 == "Madaba" ||
                        d.level_3 == "Balqa" || d.level_3 == "Ajlun" || d.level_3 == "Jarash") {
                        return "Only the last data point";
                    }
                    else {
                        return "";
                    }
                });

                refugeestacked.filter = (refugeestacked.filter == vis.filter) ? "":vis.filter;
                refugeestacked.wrangleData();
            });

        vis.camps.on("mouseover",function(d){
            vis.tooltip.show(function () {
                return "<span>" + d.level_3 + "</span>";
            });
        });

        vis.camps.on("mousemove",function(d,i){
                vis.tooltip.move();
                refugeestacked.legend.attr("opacity",0.2);
                refugeestacked.categories.attr("opacity",0.2);
                d3.select("#legend"+properstring(d.level_1)).attr("opacity",1);

                d3.select("#area"+properstring(d.level_1)).attr("opacity",1);
                d3.select("#area"+properstring(d.level_3)).attr("opacity",1);})

    .on("mouseout",function(d,i){
                vis.tooltip.hide();
                refugeestacked.legend.attr("opacity",1);
                refugeestacked.categories.attr("opacity",1);
    });

        vis.camps.exit().remove();
    }

};




