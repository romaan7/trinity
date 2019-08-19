
RefugeeStacked = function(_parentElement, _campdata_total){
    this.parentElement = _parentElement;
    this.campdata_total = _campdata_total;
    this.displayData = []; // see data wrangling

    campdata_total.sort(function(a,b){
        return a.date - b.date;
    });

    this.initVis();

};

RefugeeStacked.prototype.initVis = function() {
    var vis = this;
    var properstring = function(d){return d.replace(" ",'').replace(" ",'');};

    // -------------------------------------------------------------------------
    // SVG Drawing area
    // -------------------------------------------------------------------------
    vis.margin = {top: 10, right: 5, bottom: 30, left: 43};
    vis.width = $("#" + vis.parentElement).width() - vis.margin.left - vis.margin.right - 30;
    //vis.width =  100 - vis.margin.left - vis.margin.right;
    vis.height = 300  - vis.margin.top - vis.margin.bottom;

    // SVG drawing area
    vis.svg = d3.select("#" + vis.parentElement).append("svg")
        .attr("width", vis.width + vis.margin.left + vis.margin.right)
        .attr("height", refugeemap.height+80);

    vis.mapg = vis.svg.append("g")
        .attr("transform", "translate(" + vis.margin.left + "," + vis.margin.top + ")");
        //.attr("transform","(0,0)");

    // --------------------------------------------------------------------------
    // Overlay with path clipping
    // -------------------------------------------------------------------------
    vis.mapg.append("defs").append("clipPath")
        .attr("id", "clip")
        .append("rect")
        .attr("width", vis.width)
        .attr("height", vis.height);

    // -------------------------------------------------------------------------
    // Scales and axes
    // -------------------------------------------------------------------------

    vis.x = d3.time.scale()
        .range([0, vis.width])
        .domain(d3.extent(vis.campdata_total, function(d) { return d.date; }));

    vis.y = d3.scale.linear()
        .range([vis.height, 0]);

    vis.xAxis = d3.svg.axis()
        .scale(vis.x)
        .orient("bottom")
        .tickFormat(d3.time.format("%b-%y"))
        .ticks(d3.time.month, 6);

    vis.yAxis = d3.svg.axis()
        .scale(vis.y)
        .orient("left")
        .tickFormat(d3.format(".2s"));

    vis.mapg.append("g")
        .attr("class", "x-axis axis")
        .attr("transform", "translate(0," + vis.height + ")");

    vis.mapg.append("g")
        .attr("class", "y-axis axis");

    // ----------------------------------------------------------------------------------------
    // Tooltips initialize
    // ----------------------------------------------------------------------------------------

    vis.tooltip = {
        element: null,
        init: function() {
            this.element = d3.select("body").append("div").attr("class", "tooltip").style("opacity", 0);
        },
        show: function(t) {
            this.element.html(t).transition().duration(200).style("left", d3.event.pageX + 10 + "px").style("top", d3.event.pageY - 10 + "px").style("opacity", .9);
        },
        move: function() {
            this.element.transition().duration(30).ease("linear").style("left", d3.event.pageX + 10 + "px").style("top", d3.event.pageY - 10 + "px").style("opacity", .9);
        },
        hide: function() {
            this.element.transition().duration(500).style("opacity", 0)
        }};

    vis.tooltip.init();

    // -------------------------------------------------------------------------
    // Initialize stack layout: Get all categories
    // -------------------------------------------------------------------------
    vis.selectValue = "level_1";
    vis.domaindict = {
        "level_1" : ["JOR","IRQ","TUR","LBN","EGY"],
        "level_2" : ["Ajlun Governorate", "Amman Governorate", "Anbar",	"Aqaba Governorate",
            "Balqa  Governorate", "Beirut",	"Bekaa", "Dispersed", "Dispersed2",	"Duhok", "Egypt",
            "Erbil", "Irbid Governorate", "Jarash Governorate",	"Karak Govenorate",	"Maan Governorate",
            "Madaba Governorate", "Mafraq Governorate",	"North Lebanon", "South Lebanon", "Sulaymaniyah",
            "Tafilah Govenorate", "Turkey", "Zarqa Govenorate"],
        "level_3" : ["Ajlun","Akre Settlement", "Al-Obaidi Camp", "Amman", "Anbar Non-Camp", "Aqaba", "Arbat Permanent Camp",
            "Azraq Camp", "Balqa", "Basirma Camp", "Beirut", "Bekaa", "Darashakran Camp", "Dispersed",
            "Dispersed2", "Domiz 1 Camp", "Domiz 2 Camp", "Duhok Non-Camp",	"Egypt", "Erbil Non-Camp",
            "Gawilan Camp",	"Irbid", "Jarash",	"Karak", "Kawergosk Camp",	"Maan",	"Madaba", "Mafraq",	"North Lebanon", "Qushtapa Camp", "South Lebanon",
            "Sulaymaniyah Non-Camp", "Tafilah",	"Turkey", "Zaatari Refugee Camp", "Zarqa"]
    };

    vis.countryname = {TUR: "Turkey", IRQ: "Iraq", JOR: "Jordan", LBN: "Lebanon", EGY: "Egypt"};

    // Get the last data point for level_1
    vis.countryById ={};
    vis.campdata_total.forEach(function(d){
        vis.countryById[d.level_1] = d;
    });

    // Get the last data point for level_3
    vis.campById = {};
    vis.campdata_total.forEach(function(d){
        vis.campById[d.level_3] = d;
    });

    vis.colores_country = function(n){
        var colores_g = ['#377eb8', '#4daf4a', '#e41a1c', '#ff7f00', '#ff08e8', '#a65628', '#ffff33', '#666666', '#a6cee3',
            '#1f78b4', '#b2df8a', '#33a02c', '#fb9a99', '#e31a1c', '#fdbf6f', '#ff7f00' , '#cab2d6' , '#6a3d9a' , '#ffff99' ,'#b15928' ];
        return colores_g[n % colores_g.length];
    };

    var colores_g = ['#377eb8', '#4daf4a', '#e41a1c', '#ff7f00', '#ff08e8', '#a65628', '#ffff33', '#666666', '#a6cee3',
        '#1f78b4', '#b2df8a', '#33a02c', '#fb9a99', '#e31a1c', '#fdbf6f', '#ff7f00' , '#cab2d6' , '#6a3d9a' , '#ffff99' ,'#b15928' ];

    vis.colorScale = d3.scale.ordinal().range(colores_g);

    vis.colorScale
        .domain(vis.domaindict[vis.selectValue]);

    vis.dataCategories = vis.colorScale.domain();

    // Rearrange data into layers
    // -------------------------------------------------------------------------
    // Level 1
    // -------------------------------------------------------------------------

    vis.transposedData = d3.nest().key(function(d) {return d.level_1; })
        .key(function(d){return d.date})
        .rollup(function(v) { return d3.mean(v, function(d) { return d.sum_1; }); })
        .entries(vis.campdata_total);

    var iso = d3.time.format.iso;

    vis.transposedData.forEach(function(d){
        d.values.forEach(function(v){
            v.key = iso.parse(v.key);
            v.y = v.values;
            delete v.values;
            v.Date = v.key;
            delete v.key;
        })
    });

    // -------------------------------------------------------------------------
    // Level 3
    // -------------------------------------------------------------------------

    vis.transposedData3 = d3.nest()
        //.key(function(d) { return d.level_1})
        .key(function(d) {return d.level_3; })
        .key(function(d){return d.date})
        .rollup(function(v) { return {
            y: d3.mean(v, function(d) { return d.sum_3; }),
            level_1: v[0].level_1 }})
        .entries(vis.campdata_total);

    vis.transposedData3.forEach(function(d){
        d.values.forEach(function(v){
            v.key = iso.parse(v.key);
            v.y = v.values.y;
            v.level_1 = v.values.level_1;
            delete v.values;
            v.Date = v.key;
            delete v.key;
        });
    });

    vis.transposedData3.forEach(function(d){
        d.key2 = d.values[0].level_1;
        if (d.key2=="JOR") {
            d.key3 = 1;
        }
        else if (d.key2=="IRQ") {
            d.key3 = 2;
        }
        else if (d.key2=="TUR") {
            d.key3 = 3;
        }
        else if (d.key2 == "LBN") {
            d.key3 = 4;
        }
        else {
            d.key3 = 5;
        }
        d.values.forEach(function(v){
            delete v.level_1;
        })
    });

    vis.transposedData3.sort(function(a,b){
        return a.key3 - b.key3;
    });

    vis.transposedData3.splice(35,1); //Egypt is 35
    vis.transposedData3.splice(30,1); //Turkey is 30

    vis.stack = d3.layout.stack()
        .values(function(d) { return d.values;});

    vis.stackedData = vis.stack(vis.transposedData);

    // -------------------------------------------------------------------------
    // Stacked area layout
    // -------------------------------------------------------------------------

    vis.area = d3.svg.area()
        .interpolate("bundle")
        .x(function(d) { return vis.x(d.Date);})
        .y0(function(d) { return vis.y(d.y0);})
        .y1(function(d) {return vis.y(d.y0 + d.y);});

    vis.area2 = d3.svg.area()
        .interpolate("basis")
        .x(function(d) {return vis.x(d.Date);})
        .y0(vis.y(0))
        .y1(function(d) {return vis.y(d.y)});

    // -------------------------------------------------------------------------
    // Tooltip text information
    // -------------------------------------------------------------------------

    vis.box1 = vis.svg.append("g")
        .append("text")
        .attr("id","category1")
        .attr("transform", "rotate(0)")
        .attr("y", -8)
        .attr("x", 10)
        .attr("fill","white")
        .attr("dy", ".71em")
        .style("text-anchor", "start")
        .text("Total")
        .attr("z-index",2)
        .attr("transform", "translate(" + vis.margin.left + "," + vis.margin.top + ")");


    vis.box2 = vis.svg.append("g")
        .append("text")
        .attr("id","category2")
        .attr("transform", "rotate(0)")
        .attr("y", 14)
        .attr("x", 10)
        .attr("fill","white")
        .attr("dy", ".71em")
        .style("text-anchor", "start")
        .text("4,778,588|Apr-16")
        .attr("z-index",2)
        .attr("transform", "translate(" + vis.margin.left + "," + vis.margin.top + ")");

    vis.box3 = vis.svg.append("g")
        .append("text")
        .attr("id","category3")
        .attr("transform", "rotate(0)")
        .attr("y", 100)
        .attr("x",vis.width-5)
        .attr("fill","white")
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .attr("z-index",2)
        .attr("transform", "translate(" + vis.margin.left + "," + vis.margin.top + ")");


    // -------------------------------------------------------------------------
    // Initialize filter area
    // -------------------------------------------------------------------------

    vis.filter = "";
    d3.select("#level_1").attr('class', 'btn btn-default cp_button cp_button_fix selected');

    d3.select("#level_1").on("click", function(){
        vis.selectValue = d3.select("#level_1").property("id");
        d3.select("#category1").text("Total");
        d3.select("#category2").text("4,778,588 | Apr-16");
        d3.selectAll('.cp_button').classed('selected', false);
        d3.selectAll('.cp_button_fix').classed('selected', false);
        d3.select(this).classed('selected',true);
        vis.filter="";
        vis.wrangleData()});

    d3.select("#level_3").on("click", function(){
        vis.selectValue = d3.select("#level_3").property("id");
        d3.select("#category1").text("Except Turkey and Egypt");
        d3.select("#category2").text("");
        //$(".cp_button").removeClass('selected');
        //$(this).attr('class', 'btn btn-default cp_button selected');
        d3.selectAll('.cp_button').classed('selected', false);
        d3.selectAll('.cp_button_fix').classed('selected', false);
        d3.select(this).classed('selected',true);
        $(".area").removeClass();
        $(".area").removeAttr("id");
        vis.filter="";
        vis.wrangleData()});

    // -------------------------------------------------------------------------
    // Initialize Legend
    // -------------------------------------------------------------------------

    vis.legend = vis.mapg.append("g")
        .attr("id","legendstack")
        .attr("transform", "translate(" + 0 + "," + 300 + ")")
        .selectAll("g")
        .data(vis.domaindict[vis.selectValue])
        .enter().append("g")
        .attr("id",function(d,i){
            return "legend"+ properstring(d);
        });

    vis.legend.append("circle")
        .attr("class","legend-circle")
        .attr("cy", function(d,i){
            return 10+i*30;
        })
        .attr("cx", 0)
        .attr("r",10)
        .attr("fill", function(d,i) {
            return vis.colores_country(i); })
        .attr("opacity",1);

    vis.legend.append("text")
        .attr("class","legend-text")
        .attr("y", function(d,i) {return 10+i*30;})
        .attr("dy","0.3em")
        .attr("dx","2em")
        .attr("anchor","left")
        .text(function(d,i){ return vis.countryname[d];})
        .attr("fill", function(d,i){return vis.colores_country(i);})
        .attr("opacity",1);

    // ----------------------------------------------------------------------------------------
    // Timeline Begins
    // ----------------------------------------------------------------------------------------

    vis.handle = vis.svg.insert("g","first-child")
        .append("line")
        .attr("id","stackhandle")
        .attr("class","handle")
        .attr("x1",0)
        .attr("y1", 35)
        .attr("x2",0)
        .attr("y2",vis.height + 6)
        .style("stroke-linecap","round")
        .style("stroke-width",2)
        .attr("d","M5 40 l215 0")
        .attr("stroke","white")
        .style("stroke-dasharray","10,10")
        .attr("z-index",10)
        .attr("transform", "translate(" + vis.margin.left + "," + vis.margin.top + ")");

    // -------------------------------------------------------------------------
    // Initialize filter area
    // -------------------------------------------------------------------------
    vis.filter="";
    vis.wrangleData();
};

RefugeeStacked.prototype.wrangleData = function() {

    var vis = this;
    var properstring = function(d){return d.replace(" ",'').replace(" ",'');};
    vis.stackedData = (vis.selectValue == "level_1") ? vis.stack(vis.transposedData) :vis.stack(vis.transposedData3);
    // In the first step no data wrangling/filtering needed
    if (vis.filter == "") {vis.displayData = vis.stackedData}
    else {vis.displayData = vis.stackedData.filter(function(d) {return d.key == vis.filter})};
    vis.updateVis();
};

RefugeeStacked.prototype.updateVis = function() {
    var properstring = function(d){return d.replace(" ",'').replace(" ",'');};
    var vis = this;
    // Update domain
    // Get the maximum of the multi-dimensional array or in other words, get the highest peak of the uppermost layer

    if (vis.filter == "") {
        vis.y.domain([0, d3.max(vis.displayData, function (d) {
            return d3.max(d.values, function (e) {
                return e.y0 + e.y;
            });
        })
        ]);
        if (vis.selectValue == "level_1") {
            d3.select("#category1").text("Total");
            d3.select("#category2").text("4,778,588 | Apr-16");
            d3.select("#category3").text("");
        }
        else {
            d3.select("#category1").text("Except Turkey and Egypt");
            d3.select("#category2").text("");
            d3.select("#category3").text("");
        }

    } else {
        vis.y.domain([0, d3.max(vis.displayData[0].values,
            function (d) {
                return d.y;
            })]);
    };

    // Draw the layer
    vis.categories = vis.mapg.selectAll(".area")
        .data(vis.displayData);

    vis.categories.enter().append("path");

    vis.categories
        .attr("class", function(d){
            if (d.key2) {
                return "area area"+properstring(d.key2);
            }
            else {
                return "area"
            }
        })
        .attr("id",function(d,i){
            return "area"+properstring(d.key);
        });

    vis.categories
        .style("fill", function(d) {
            if (vis.selectValue=="level_1") {
                return vis.colorScale(d.key);
            } else {
                return vis.colorScale(d.key2);
            }
        })
        .attr("opacity", 1)
        .attr("d", function (d) {
            if (vis.filter == "") {
                return vis.area(d.values)
            } else {
                return vis.area2(d.values)
            }
        })
        .on("click", function (d) {
            d3.select("#category1").text(function () {
                if (d.key == "TUR" || d.key == "JOR" || d.key == "EGY" || d.key == "LBN" || d.key == "IRQ") {
                    return vis.countryname[d.key];
                }
                else if (d.key == "Turkey" || d.key == "Egypt") {
                    return d.key;
                }
                else {
                    return vis.countryname[vis.campById[d.key]["level_1"]] + ": " + d.key;
                }
            });

            d3.select("#category2").text(function () {
                if (d.key == "TUR" || d.key == "JOR" || d.key == "EGY" || d.key == "LBN" || d.key == "IRQ") {
                    return d3.format(".")(vis.countryById[d.key]["sum_1"]) + " | Apr-16";
                }
                else if (d.key == "Turkey" || d.key == "Egypt") {
                    return d3.format(",")(vis.campById[d.key]["sum_1"]) + " | Apr-16";
                }
                else {
                    return d3.format(",")(vis.campById[d.key]["sum_3"]) + " | Apr-16";
                }
            });

            d3.select("#category3").text(function(){
                if (d.key == "Aqaba" || d.key == "Maan" || d.key == "Tafilah"|| d.key=="Dispersed2" ||
                    d.key == "Karak" || d.key == "Azraq Camp" || d.key == "Amman" || d.key == "Madaba" ||
                    d.key == "Balqa" || d.key == "Ajlun" || d.key == "Jarash") {
                    return "Only the last data point";
                }
                else {
                    return "";
                }
            });

            //vis.selectValue = "level_1";
            vis.filter = (vis.filter == d.key) ? "" : d.key;
            vis.wrangleData();
        });

    vis.categories.on("mouseover", function (d, i) {
        vis.tooltip.move();

        d3.select("#category1").text(function () {
            if (d.key == "TUR" || d.key == "JOR" || d.key == "EGY" || d.key == "LBN" || d.key == "IRQ") {
                return vis.countryname[d.key];
            }
            else if (d.key == "Turkey" || d.key == "Egypt") {
                return d.key;
            }
            else {
                return vis.countryname[vis.campById[d.key]["level_1"]] + ": " + d.key;
            }
        });

        d3.select("#category2").text(function () {
            if (d.key == "TUR" || d.key == "JOR" || d.key == "EGY" || d.key == "LBN" || d.key == "IRQ") {
                return d3.format(",")(vis.countryById[d.key]["sum_1"]) + " | Apr-16";
            }
            else if (d.key == "Turkey" || d.key == "Egypt") {
                return d3.format(",")(vis.campById[d.key]["sum_1"]) + " | Apr-16";
            }
            else {
                return d3.format(",")(vis.campById[d.key]["sum_3"]) + " | Apr-16";
            }
        });

        d3.select("#category3").text(function(){
            if (d.key == "Aqaba" || d.key == "Maan" || d.key == "Tafilah"|| d.key=="Dispersed2" ||
                d.key == "Karak" || d.key == "Azraq Camp" || d.key == "Amman" || d.key == "Madaba" ||
                d.key == "Balqa" || d.key == "Ajlun" || d.key == "Jarash") {
                return "Only the last data point";
            }
            else {
                return "";
            }
        });

        // mouseover on a country area, make the rest transparent
        vis.categories.attr("opacity", 0.2);
        d3.select(this).attr("opacity", 1);

        // make other country legend transparent
        vis.legend.attr("opacity",0.2);
        if (d.key2) {
            d3.select("#legend" + properstring(d.key2)).attr("opacity", 1);
        } else {
            d3.select("#legend" + properstring(d.key)).attr("opacity",1);
        }

        // make other bubbles transparent
        refugeemap.begincamps.attr("opacity",0.4);
        d3.selectAll(".beginbubbles").attr("opacity",1);
        d3.selectAll(".bubble"+properstring(d.key)).attr("opacity",1);
        d3.select("#"+properstring(d.key)).attr("opacity",1);
        })
        .on("mouseout",function(d,i){
            vis.tooltip.hide();
            vis.categories.attr("opacity",1);
            vis.legend.attr("opacity",1);
            refugeemap.begincamps.attr("opacity",1);
            d3.selectAll(".beginbubbles").attr("opacity",0.7);

            if (vis.filter == "") {

            if (vis.selectValue=="level_1"){
                d3.select("#category1").text("Total");
                d3.select("#category2").text("4,778,588 | Apr-16");
                d3.select("#cetegory3").text("");
            }
            else {
                d3.select("#category1").text("Except Turkey and Egypt");
                d3.select("#category2").text("");
                d3.select("#cetegory3").text("");
            }
        }
        });

    // Update tooltip text
    vis.categories.exit().remove();

    vis.svg.select(".x-axis").transition().duration(500).call(vis.xAxis).attr("dy", "4.5em");
    vis.svg.select(".y-axis").transition().duration(500).call(vis.yAxis);

    vis.legend.on("mouseover",function(d,i){
            vis.tooltip.move();
            vis.legend.attr("opacity", 0.2);
            d3.select(this).attr("opacity", 1);
            vis.categories.attr("opacity", 0.2);

            d3.selectAll(".area" + properstring(d)).attr("opacity",1);
            d3.select("#area" + properstring(d)).attr("opacity", 1);

            refugeemap.begincamps.attr("opacity",0.4);
            d3.selectAll(".beginbubbles").attr("opacity",1);
            d3.selectAll('.bubble' + properstring(d)).attr("opacity",1);
        })
        .on("mouseout",function(d,i){
            vis.tooltip.hide();
            vis.legend.attr("opacity",1);
            vis.categories.attr("opacity",1);
            refugeemap.begincamps.attr("opacity",1);
            d3.selectAll(".beginbubbles").attr("opacity",0.7);
        });

    vis.legend.on("click",function(d){

        d3.selectAll('.cp_button').classed('selected', false);
        d3.selectAll('.cp_button_fix').classed('selected', false);
        d3.select("#level_1").classed('selected',true);

        d3.select("#category1").text(function () {
            if (d == "TUR" || d == "JOR" || d == "EGY" || d == "LBN" || d == "IRQ") {
                return vis.countryname[d];
            }
            else if (d == "Turkey" || d == "Egypt") {
                return d;
            }
            else {
                return vis.countryname[vis.campById[d]["level_1"]] + ": " + d;
            }
        });

        d3.select("#category2").text(function () {
            if (d == "TUR" || d == "JOR" || d == "EGY" || d == "LBN" || d == "IRQ") {
                return d3.format(",")(vis.countryById[d]["sum_1"]) + " | Apr-16";
            }
            else if (d == "Turkey" || d == "Egypt") {
                return d3.format(",")(vis.campById[d]["sum_1"]) + " | Apr-16";
            }
            else {
                return d3.format(",")(vis.campById[d]["sum_3"]) + " | Apr-16";
            }
        });

        d3.select("#category3").text(function(){
            if (d.key == "Aqaba" || d.key == "Maan" || d.key == "Tafilah"|| d.key=="Dispersed2" ||
                d.key == "Karak" || d.key == "Azraq Camp" || d.key == "Amman" || d.key == "Madaba" ||
                d.key == "Balqa" || d.key == "Ajlun" || d.key == "Jarash") {
                return "Only the last data point";
            }
            else {
                return "";
            }
        });

        vis.selectValue = "level_1";
        vis.filter = (vis.filter == d) ? "" : d;

        vis.wrangleData();
    });

};