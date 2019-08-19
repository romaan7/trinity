// Variable declarations
var svg, grossScale;
var countries = [];
var zero_countries = [];

// Dimensions of screen and circle sizes
var width = 1020,         // width of visualization 
    height = 1080,        // height of visualization
    padding = 3,          // separation between same-color circles
    clusterPadding = 6,   // separation between different-color circles
    maxRadius  = 17,      // maximum size of a circle
    medRadius = 13,       // medium radius of a circle
    minRadius = 8,        // minimum size of a circle
    margin = 50;

// Parsing of data set csv files yearwise
d3v3.csv("data/2008data.csv", function(data) {
    for (var key in data) {
        if ((parseInt(data[key].Refugee) || 0)==0) {
            zero_countries.push(data[key]);
        } else {
            countries.push(data[key]);
        }
    }
    countries.forEach(function(d) {
        d.Refugee = +d.Refugee; // cast the dollar amount from string to integer
        d.Year = +d.Year; // create a new category in the rdata called Decade 
        d.Continent = d.Continent; //continent of country for color classification

    });
    initialize("Refugee");
    addScale();
});

d3v3.csv("data/2010data.csv", function(data2) {
    for (var key in data2) {
        if ((parseInt(data2[key].Refugee) || 0)==0) {
            zero_countries.push(data2[key]);
        } else {
            countries.push(data2[key]);
        }
    }
    countries.forEach(function(d) {
        d.Refugee = +d.Refugee; // cast the dollar amount from string to integer
        d.Year = +d.Year; // create a new category in the rdata called Decade 
        d.Continent = d.Continent; //continent of country for color classification
    });
    initialize("Refugee");
    addScale();
});

d3v3.csv("data/2012data.csv", function(data3) {
    for (var key in data3) {
        if ((parseInt(data3[key].Refugee) || 0)==0) {
            zero_countries.push(data3[key]);
        } else {
            countries.push(data3[key]);
        }
    }
    countries.forEach(function(d) {
        d.Refugee = +d.Refugee; // cast the dollar amount from string to integer
        d.Year = +d.Year; // create a new category in the rdata called Decade 
        d.Continent = d.Continent; //continent of country for color classification
        
    });
    initialize("Refugee");
    addScale();
});

d3v3.csv("data/2014data.csv", function(data4) {
    for (var key in data4) {
        if ((parseInt(data4[key].Refugee) || 0)==0) {
            zero_countries.push(data4[key]);
        } else {
            countries.push(data4[key]);
        }
    }
    countries.forEach(function(d) {
        d.Refugee = +d.Refugee; // cast the dollar amount from string to integer
        d.Year = +d.Year; // create a new category in the rdata called Decade 
        d.Continent = d.Continent; //continent of country for color classification
        
    });
    initialize("Refugee");
    addScale();
});

/* This function will create the visualization based on the category selected by the user */
function initialize(category){
    
    // removes pre-existing data visualization
    d3v3.selectAll(".force-layout").remove(); 
        // the code below will count number of distinct elements in the category 
        // recall that 'category' is a parameter passed to this function, and will
        // depend on which button was clicked in the menu. It could be "Studio" for example
        var categories = d3v3.map(countries, function(d) { return d.category; });
        var m = 50;
        var n = countries.length; // total number of circles
    
        var minGross = d3v3.min(countries, function(d){ return d.Refugee; });
        var maxGross = d3v3.max(countries, function(d){ return d.Refugee; });

        var clusters = new Array(m);
        
        var nodes = countries.map(function(currentValue, index) {
                
              if(currentValue.Population < 10000000) {r = minRadius} 
              else if(currentValue.Population > 10000000 && currentValue.Population <= 50000000) {r = medRadius}
              else{r = maxRadius}
                 
             
              var i = currentValue[category], 
              d = {cluster: i, 
                   radius: r, 
                   Country: currentValue.Country,
                   Continent: currentValue.Continent,
                   Refugee: currentValue.Refugee,
                   Year: currentValue.Year,
                   Population: currentValue.Population};
            
          // if this is the largest node for a category, add it to 'clusters' array
          if (!clusters[i] || (r > clusters[i].radius)) clusters[i] = d;
          return d;
        });
        
        var force = d3v3.layout.force()
            .nodes(nodes)
            .size([width, height])
            .gravity(0)
            .charge(0) //attractive force between nodes. Negative values makes nodes repel
            .on("tick", tick) 
            .start();
    
        // Create an SVG element of size width x height that contains the graph
        svg = d3v3.select("#refugeeForce").append("svg")
            .attr("width", width)
            .attr("height", height)
            .attr("class","force-layout")
            .attr("style","display:block; margin-left: auto; margin-right: auto ");
         
        var circle = svg.selectAll("g")
            .data(nodes)
            .enter()
            .append("g").append("circle") 
            .attr("id", "circle-hover")
            // size depends on population
            .attr("r", function(d) { if(d.Population < 10000000) {return radius = 8} 
                                     if(d.Population > 10000000 && d.Population <= 50000000) {return radius = 13}
                                     if(d.Population > 50000000) {return radius = 17}
                                     else {return d.radius}
                                   ;})

            // color coding continents of circles
            .attr("fill", function(d) { 
                                         if(d.Refugee <= 1000 && category == "Split") return d3v3.rgb("#808080");
                                         if(d.Continent == "Asia") return d3v3.rgb("#8a00e6"); 
                                         if(d.Continent == "Europe") return d3v3.rgb("#0099ff");
                                         if(d.Continent == "Africa") return d3v3.rgb("#339966");
                                         if(d.Continent == "North America") return d3v3.rgb("#ff66cc");
                                         if(d.Continent == "South America") return d3v3.rgb("#ffcc66");
                                         if(d.Continent == "Oceania") return d3v3.rgb("#cc0099");
                                        })  
  
        // a simple tooltip from http://bl.ocks.org/biovisualize/1016860 with formatting
        var tooltip = d3v3.select("body")
        .append("div")
        .style("position", "absolute")
        .style("z-index", "7")
        .style("visibility", "hidden")               
        .style("width", "1000px")
        .style("height", "30px")
        .style("background", "aliceblue")
        .style("border", "0px")
        .style("border-radius", "8px")          
        .style("font-family", "sans-serif");
    

        var div = d3v3.select("#refugeeForce").append("div")	
         .attr("class", "v1-tooltip")				
         .style("opacity", 0);
        var parse = d3v3.format(",");

        svg.selectAll("circle")
            .on("mouseover", function(d) {
            div.transition()
                .duration(200)
                .style("opacity", 0.8)
            
            div.html("<b style=\"text-transform: uppercase\"><underline><center>"+d.Country+"</b></underline></center>" + "<br />" + "Refugees: " +parse(d.Refugee) +  "<br />"+"Population: " + parse(d.Population) + "<br />")
                .style("left", (d3v3.event.pageX) + "px")
                .style("top", (d3v3.event.pageY) + "px");
            })


        .on("mousemove", function(){return tooltip.style("top", (d3v3.event.pageY-10)+"px")
                .style("left",(d3v3.event.pageX+10)+"px");})
        .on("mouseout", function(d) {
            div.transition()
                .duration(500)
                .style("opacity", 0);
            });
     
        // movement of circles and cluster spatial orientation
        function tick(e) {
          circle
              .each(clusterGross(10*e.alpha*e.alpha))
              .each(collide(.1))
              .attr("cx", function(d) { return d.x + 100; })
              .attr("cy", function(d) {return d.y;})
        }
        
        // Placement of circles hardcoded on the canvas
        function clusterGross(alpha) {
          return function(d) {
            var yTemp;
            if(category == "Refugee" && d.Year == 2008){ yTemp = 130}
            if(category == "Refugee" && d.Year == 2010){yTemp = 336}
            if(category == "Refugee" && d.Year == 2012){yTemp = 510}
            if(category == "Refugee" && d.Year == 2014){yTemp = 730}
            if(category == "Split" && d.Year == 2008) {yTemp = 130}
            if(category == "Split" && d.Year == 2010) {yTemp = 336}
            if(category == "Split" && d.Year == 2012) {yTemp = 510}
            if(category == "Split" && d.Year == 2014) {yTemp = 730}
            if(category == "Continent" && (d.Year == 2008 || d.Year == 2010 || d.Year == 2012)) {yTemp = 2250}
            if(category == "Continent" && d.Continent == "Oceania" && d.Year == 2014) {yTemp = 120}
            if(category == "Continent" && d.Continent == "South America" && d.Year == 2014) {yTemp = 260}
            if(category == "Continent" && d.Continent == "North America" && d.Year == 2014) {yTemp = 410}
            if(category == "Continent" && d.Continent == "Europe" && d.Year == 2014) {yTemp = 550}
            if(category == "Continent" && d.Continent == "Africa" && d.Year == 2014) {yTemp = 710}  
            if(category == "Continent" && d.Continent == "Asia" && d.Year == 2014) {yTemp = 860}  
            
            // math for clustering
            var cluster = {x: grossScale(d.Refugee), 
                           y : yTemp,
                           radius: -d.radius};
              
            var k = .1 * Math.sqrt(d.radius);
            var x = d.x - cluster.x,
                y = d.y - cluster.y,
                l = Math.sqrt(x * x + y * y),
                r = d.radius + cluster.radius;
            if (l != r) {
              l = (l - r) / l * alpha * k;
              d.x -= x *= l;
              d.y -= y *= l;
              cluster.x += x;
              cluster.y += y;
            }
          };
        }
    
        // Resolves collisions between d and all other circles.
        function collide(alpha) {
          var quadtree = d3v3.geom.quadtree(nodes);
          return function(d) {
            var r = d.radius + 17 + Math.min(padding, clusterPadding),
                nx1 = d.x - r,
                nx2 = d.x + r,
                ny1 = d.y - r,
                ny2 = d.y + r;
            quadtree.visit(function(quad, x1, y1, x2, y2) {
              if (quad.point && (quad.point !== d)) {
                var x = d.x - quad.point.x,
                    y = d.y - quad.point.y,
                    l = Math.sqrt(x * x + y * y),
                    r = d.radius + quad.point.radius + 
                        (d.cluster === quad.point.cluster ? padding : clusterPadding);
                if (l < r) {
                  l = (l - r) / l * alpha;
                  d.x -= x *= l;
                  d.y -= y *= l;
                  quad.point.x += x;
                  quad.point.y += y;
                }
              }
              return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
            });
          };
        }
};

function addScale(){

    svg.selectAll(".legend").remove();
    grossScale = d3v3.scale.log().domain([300, 1e7]).range([0, width]);
    
    
    var xAxis = d3v3.svg.axis()
        .scale(grossScale)
        .orient("bottom")
        .tickPadding(5)
        .ticks(12, " ")
        //.tickFormat(d3v3.format("2s"));
        
    grossScale.domain([d3v3.min(countries, function(d) { return d.Refugee; }), 
              d3v3.max(countries, function(d) { return d.Refugee; })]);
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+200+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2) + 150)
        .attr("y", 240)
        .style("text-anchor", "end")
        .text("Number of Refugees (2008)");
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+400+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2) + 150)
        .attr("y", 440)
        .style("text-anchor", "end")
        .text("Number of Refugees (2010)");
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+600+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2)+150)
        .attr("y", 640)
        .style("text-anchor", "end")
        .text("Number of Refugees (2012)");
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+850+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2) + 150)
        .attr("y", 890)
        .style("text-anchor", "end")
        .text("Number of Refugees (2014)");
     
    legend();
};
 
function addScale2(){
     svg.selectAll(".legend").remove();
    grossScale = d3v3.scale.log().domain([300, 1e7]).range([0, width]);

    
    var xAxis = d3v3.svg.axis()
        .scale(grossScale)
        .orient("bottom")
        .ticks(12, " ");
    grossScale.domain([d3v3.min(countries, function(d) { return d.Refugee; }), 
              d3v3.max(countries, function(d) { return d.Refugee; })]);
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+150+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2))
        .attr("y", 190)
        .style("text-anchor", "center")
        .text("Oceania (2014)");
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+300+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2))
        .attr("y", 340)
        .style("text-anchor", "center")
        .text("South America (2014)");
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+450+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2))
        .attr("y", 490)
        .style("text-anchor", "center")
        .text("North America (2014)");
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+600+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2))
        .attr("y", 640)
        .style("text-anchor", "center")
        .text("Europe (2014)");
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+750+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2))
        .attr("y", 790)
        .style("text-anchor", "center")
        .text("Africa (2014)");
    
    
    svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
        .attr("transform", "translate(100,"+900+")")
    
    svg.append("text")
        .attr("class", "label")
        .attr("x", (width/2))
        .attr("y", 950)
        .style("text-anchor", "center")
        .text("Asia (2014)");
    
    legend();
};

function genreClick(elem){
   var buttons = document.getElementsByClassName("navbar-item");
    for(i = 0; i < buttons.length; ++i){
        buttons[i].style.backgroundColor="black";
    }
    elem.style.backgroundColor="orange";
    initialize("Continent");
    addScale2();
};

// navigation button functions
function grossClick(elem){
    var buttons = document.getElementsByClassName("navbar-item");
    for(i = 0; i < buttons.length; ++i){
        buttons[i].style.backgroundColor="black";
    }
    elem.style.backgroundColor="orange";
    initialize("Refugee");
    addScale();
};

function splitClick(elem){
    var buttons = document.getElementsByClassName("navbar-item");
    for(i = 0; i < buttons.length; ++i){
        buttons[i].style.backgroundColor="black";
    }
    elem.style.backgroundColor="orange";
    initialize("Split");
    addScale();
};


// legend specifications placed below for color and continent
function legend(){
  var svgleagnd = d3v3.select("#refugeeForce")

    svg.append("circle")
        .attr("r", 5)
        .attr("cx", 10)
        .attr("cy", 960)
        .style("fill", "#339966");
    
     svg.append("text")
        .attr("class", "label")
        .attr("x", 50)
        .attr("y",965)
        .style("text-anchor", "start")
        .text("Africa");
    
    svg.append("circle")
        .attr("r", 5)
        .attr("cx", 10)
        .attr("cy", 980)
        .style("fill", "#8a00e6");
    
     svg.append("text")
        .attr("class", "label")
        .attr("x", 50)
        .attr("y", 985)
        .style("text-anchor", "start")
        .text("Asia");
    
    svg.append("circle")
        .attr("r", 5)
        .attr("cx", 10)
        .attr("cy", 1000)
        .style("fill", "#ff66cc");
    
     svg.append("text")
        .attr("class", "label")
        .attr("x", 50)
        .attr("y", 1005)
        .style("text-anchor", "start")
        .text("North America");
    
    svg.append("circle")
        .attr("r", 5)
        .attr("cx", 10)
        .attr("cy", 1020)
        .style("fill", "#ffcc66");
    

     svg.append("text")
        .attr("class", "label")
        .attr("x", 50)
        .attr("y", 1025)
        .style("text-anchor", "start")
        .text("South America");
    
    svg.append("circle")
        .attr("r", 5)
        .attr("cx", 10)
        .attr("cy", 1040)
        .style("fill", "#0099ff");
    
     svg.append("text")
        .attr("class", "label")
        .attr("x", 50)
        .attr("y", 1045)
        .style("text-anchor", "start")
        .text("Europe");
    
    svg.append("circle")
        .attr("r", 5)
        .attr("cx", 10)
        .attr("cy", 1060)
        .style("fill", "#cc0099");
    
     svg.append("text")
        .attr("class", "label")
        .attr("x", 50)
        .attr("y", 1065)
        .style("text-anchor", "start")
        .text("Oceania");
    
    // legend specifications placed below for color and continent
    svg.append("rect")
        .attr("x", width-220)
        .attr("y", 950)
        .attr("width", 220)
        .attr("height", 150)
        .style("stroke-size", "1px");

    svg.append("circle")
        .attr("r", 8)
        .attr("cx", width-170)
        .attr("cy", 970)
        .style("fill", "white");

    svg.append("circle")
        .attr("r", 13)
        .attr("cx", width-170)
        .attr("cy", 1000)
        .style("fill", "white");

    svg.append("circle")
        .attr("r", 17)
        .attr("cx", width-170)
        .attr("cy", 1040)
        .style("fill", "white");

    svg.append("text")
        .attr("class", "label")
        .attr("x", width-20)
        .attr("y", 975)
        .style("text-anchor", "end")
        .text("1 to 10 Million");

    svg.append("text")
        .attr("class", "label")
        .attr("x", width-20)
        .attr("y", 1005)
        .style("text-anchor", "end")
        .text("10 to 50 Million");

    svg.append("text")
        .attr("class", "label")
        .attr("x", width-20)
        .attr("y", 1045)
        .style("text-anchor", "end")
        .text("Above 50 Million");

    svg.append("text")
        .attr("class", "label")
        .attr("x", width -100)
        .attr("y", 1070)
        .style("text-anchor", "middle")
        .style("fill", "Green") 
        .attr("font-size", "18px")
        .text("Population"); 
}