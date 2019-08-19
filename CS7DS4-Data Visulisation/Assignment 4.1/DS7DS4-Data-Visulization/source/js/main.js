

var allData = [];


var parseDate = d3.time.format("%Y-%m-%-d").parse;
var formatDate = d3.time.format("%b-%y");


var syriaregion, eventdata, world, refugee_current, refugeecount,campdata,campdata_total;


var violencemap, timeline, actionmap, actorstacked, casualties, refugeemap, timeslide, refugeestacked;


var actors, actorcolors, eventtypes, eventcolors, casualtydata, dataSetSource, dataSetTarget;

loadData();

function loadData() {
    queue()
        .defer(d3.json, "data/world.json")
        .defer(d3.json, "data/syriaregion.json")
        .defer(d3.csv, "data/eventdata.csv")
        .defer(d3.csv, "data/refugee_current.csv")
        .defer(d3.csv, "data/refugees_syriaregion.csv")
        .defer(d3.csv, "data/2016_casualties.csv")
        .defer(d3.csv, "data/campdata5.csv")
        .defer(d3.csv, "data/campdata8.csv")
        .await(function(error, data1, data2, data3, data4, data5, data6, data7, data8){
            if (!error) {

                world = data1;
                eventdata = data3;
                refugee_current = data4;
                refugeecount = data5;
                casualtydata = data6;
                syriaregion = data2;                
                campdata = data7;
                campdata_total = data8;

                //console.log(eventdata);

                // Event data: Format time and convert all numbers to number values
                eventdata.forEach(function(d){
                    d.Event_ID = parseFloat(d.Event_ID);
                    d.Intensity = parseFloat(d.Intensity);
                    d.Latitude = parseFloat(d.Latitude);
                    d.Longitude = parseFloat(d.Longitude);
                    d.Date = d3.time.format("%m/%d/%y").parse(d.Event_Date);
                    d.Year = parseFloat(d3.time.format("%Y")(d.Date));
                    if (d.Source_Sector_General == "Rebels/Extremists")
                    {
                        d.Source_Sector_General = "Rebels";
                    }
                    if (d.Target_Sector_General == "Rebels/Extremists")
                    {
                        d.Target_Sector_General = "Rebels";
                    }
                });
                eventdata.sort(function(a,b){
                    return a.Date - b.Date;
                });
                eventdata = eventdata.filter(function(d){return d.Date >= parseDate("2011-03-15");});


                // Get data sets for Actor Stacked
                var NameSource = ["Government/Military","Civilians/Protesters","Foreign","Rebels","ISIS","Al Qaeda / Jabhat al-Nusra","Kurds","Unknown/Other"];
                var Years = [2011, 2012, 2013, 2014, 2015];
                dataSetSource = [];
                dataSetTarget = [];
                // Source DataSet
                for (i = 0, n = NameSource.length; i < n; i++){
                    dataSetSource[i] = {name: NameSource[i], violence: []};
                    dataSetTarget[i] = {name: NameSource[i], violence: []};
                    for (j = 0, m = Years.length; j < m; j++){
                        dataSetSource[i]["violence"][j] = {
                            year: Years[j],
                            events: eventdata.filter(function(d){return (d.Source_Sector_General == NameSource[i]) && (d.Year == Years[j]);}).length
                        }
                        dataSetTarget[i]["violence"][j] = {
                            year: Years[j],
                            events: eventdata.filter(function(d){return (d.Target_Sector_General == NameSource[i]) && (d.Year == Years[j]);}).length
                        }
                    }
                }


                // Refugee timeline (for violencemap)
                refugeecount.forEach(function(d){
                    d.Value = parseFloat(d.Value);
                    d.Date = d3.time.format("%y/%m/%d").parse(d.Date);
                });

                refugeecount = d3.nest()
                    .key(function(d) { return d.Code; })
                    //.key(function(d) { return d.Date; })
                    .rollup(function(d) { return d; })
                    .map(refugeecount);


                // Refugee current
                refugee_current.forEach(function(d){
                    d.refugee = +d.refugee;
                    d.month = +d.month;
                    d.year = +d.year;
                    d.gdppc = +d.gdppc;
                    d.population = +d.population;
                    d.per_gdppc = +d.per_gdppc;
                    d.per_1000pop = +d.per_1000pop;
                });


                // Get unique names of actors & assign colorscale to it (for use in ViolenceMap and ActorCord)
                actors = d3.map(eventdata, function(d){return d.Source_Sector_General;}).keys();
                //actors = ['Government/Military','Rebels/Extremists', 'ISIS', 'Al Qaeda / Jabhat al-Nusra', 'Kurds', 'Civilians/Protesters', 'Foreign', 'Unknown/Other'];
                actors = ['Government/Military','Rebels', 'ISIS', 'Al Qaeda / Jabhat al-Nusra', 'Kurds', 'Civilians/Protesters', 'Foreign', 'Unknown/Other'];

                // Changed
                var colors2 = ['#377eb8', '#4daf4a', '#e41a1c', '#ff7f00', '#ff08e8', '#a65628    ', '#ffff33', '#666666' ];
                actorcolors = d3.scale.ordinal().domain(actors).range(colors2);

                // Changed
                eventtypes = ["Military force/light weapons", "Bombings/Aerial weapons", "(Mass) killing", "Unconventional violence", "Occupy territory", "Property/Blockade", "Abduction", "Other"];
                var colors1 = ['#377eb8', '#e41a1c', '#ff7f00', '#4daf4a', '#a65628', '#666666','#984ea3', '#ffff33'];
                //eventcolors = d3.scale.ordinal().domain([eventtypes]).range(colorbrewer["Accent"]["8"]);
                eventcolors = d3.scale.ordinal().domain(eventtypes).range(colors1);

                // Refugee bubble map
                campdata.forEach(function(d){
                    d.lati = +d.lati;
                    d.longti = +d.longti;
                    d.refugee = +d.refugee;
                    //d.date = d3.time.format("%Y/%m/%d").parse(d.date);
                    d.date = d3.time.format("%m/%d/%Y").parse(d.date);
                    //d.date = d3.time.format("%Y/%m").parse(d.date);
                });

                campdata.sort(function(a,b){
                    return a.date - b.date;
                });

                // Refugee stacked area chart
                campdata_total.forEach(function(d) {
                    d.lati = +d.lati;
                    d.longti = +d.longti;
                    d.refugee = +d.refugee;
                    d.sum = +d.sum;
                    d.sum_1 = +d.sum_1;
                    d.sum_2 = +d.sum_2;
                    d.sum_3 = +d.sum_3;
                    d.date = d3.time.format("%Y/%m/%d").parse(d.date);
                    //d.date = d3.time.format("%m/%d/%Y").parse(d.date);
                    //d.date = d3.time.format("%Y/%m").parse(d.date);
                });

                campdata_total.sort(function(a,b){
                    return a.date - b.date;
                });

                createVis();
            };
        });
};

function enableNavigation(){
    $('body').removeClass('noscroll');
    $('#preloader').css("visibility", "hidden");
    $('#firstdownbutton').css("opacity", 100);
}

function createVis() {

   enableNavigation();

    refugeemap = new RefugeeMap("refugeemap", syriaregion, campdata);
    refugeestacked = new RefugeeStacked("refugeestacked",campdata_total);
    actorStacked(); // Initialize stacked area chart // Ensure that event data is already loaded

}
