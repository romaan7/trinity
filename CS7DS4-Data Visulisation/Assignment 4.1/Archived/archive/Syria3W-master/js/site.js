//configuration object

var config = {
    title:"Syria Crisis 3W",
    description:"<p>Click the graphs or map to interact.<br />Last Updated: 20 June, 2016 - Contact: <a href='mailto:rydelafosse@redcross.org.uk' target='_blank'>Ryan Delafosse</a></p>",
    data:"data/data.json",
    whoFieldName:"organisation",
    whatFieldName:"sector",
    whereFieldName:"adm_code",
    statusFieldName:"status",
    geo:"data/syria_adm2.geojson",
    joinAttribute:"PCODE",
    colors:['#ee8b7a','#ec7763','#e9634d','#e64f36','#e64f36','#0288d1','#e33b1f','#b92e17']
};

//function to generate the 3W component
//data is the whole 3W Excel data set
//geom is geojson file

function generate3WComponent(config,data,geom){

    $('#title').html(config.title);


    var whoChart = dc.rowChart('#hdx-3W-who');
    var whatChart = dc.rowChart('#hdx-3W-what');
    var whereChart = dc.leafletChoroplethChart('#hdx-3W-where');
    var statusChart = dc.rowChart('#hdx-3W-status');

    var cf = crossfilter(data);

    var whoDimension = cf.dimension(function(d){ return d[config.whoFieldName]; });
    var whatDimension = cf.dimension(function(d){ return d[config.whatFieldName]; });
    var whereDimension = cf.dimension(function(d){ return d[config.whereFieldName]; });
    var statusDimension = cf.dimension(function(d){ return d[config.statusFieldName]; });

    var whoGroup = whoDimension.group();
    var whatGroup = whatDimension.group();
    var whereGroup = whereDimension.group();
    var statusGroup = statusDimension.group();
    var all = cf.groupAll();

    whoChart.width($('#hdx-3W-who').width()).height(500)
            .dimension(whoDimension)
            .group(whoGroup)
            .elasticX(true)
            .data(function(group) {
                return group.top(20);
            })
            .labelOffsetY(16)
            .colors(config.colors)
            .colorDomain([0,7])
            .colorAccessor(function(d, i){return 3;})
            .xAxis().ticks(5);

    whatChart.width($('#hdx-3W-what').width()).height(300)
            .dimension(whatDimension)
            .group(whatGroup)
            .elasticX(true)
            .data(function(group) {
                return group.top(15);
            })
            .labelOffsetY(23)
            .colors(config.colors)
            .colorDomain([0,7])
            .colorAccessor(function(d, i){return 3;})
            .xAxis().ticks(5);

    statusChart.width($('#hdx-3W-status').width()).height(160)
            .dimension(statusDimension)
            .group(statusGroup)
            .elasticX(true)
            .data(function(group) {
                return group.top(15);
            })
            .labelOffsetY(29)
            .colors(config.colors)
            .colorDomain([0,7])
            .colorAccessor(function(d, i){return 3;})
            .xAxis().ticks(5);

    dc.dataCount('#count-info')
            .dimension(cf)
            .group(all);

    whereChart.width($('#hxd-3W-where').width()).height(250)
            .dimension(whereDimension)
            .group(whereGroup)
            .center([34.6401861, 39.0494106])
            .zoom(7)
            .geojson(geom)
            .colors(['#CCCCCC', config.colors[3]])
            .colorDomain([0, 4])
            .colorAccessor(function (d) {
                if(d>0){
                    return 4;
                } else {
                    return 0;
                }
            })
            .featureKeyAccessor(function(feature){
                return feature.properties[(config.joinAttribute)];
            });


        dc.dataTable("#data-table")
                .dimension(whatDimension)
                .group(function (d) {
                    return d[config.whatFieldName];
                })
                .size(650)
                .columns([
                    function(d){
                       return d.municipality;
                    },
                    function(d){
                       return d.sector;
                    },
                    function(d){
                       return d.activity;
                    },
                    function(d){
                       return d.organisation;
                    },
                    function(d){
                       return d.status;
                    },
                    function(d){
                       return d.enddate;
                    },
                    function(d){
                       return d.moreinfo;
                    },
                    function(d){
                       return d.quantity;
                    }
                ])
                .renderlet(function (table) {
                    table.selectAll(".dc-table-group").classed("info", true);
                });

    dc.renderAll();

    var g = d3.selectAll('#hdx-3W-who').select('svg').append('g');

    g.append('text')
        .attr('class', 'x-axis-label')
        .attr('text-anchor', 'middle')
        .attr('x', $('#hdx-3W-who').width()/2)
        .attr('y', 500)
        .text('Activities');

    var g = d3.selectAll('#hdx-3W-what').select('svg').append('g');

    g.append('text')
        .attr('class', 'x-axis-label')
        .attr('text-anchor', 'middle')
        .attr('x', $('#hdx-3W-what').width()/2)
        .attr('y', 300)
        .text('Activities');

    var g = d3.selectAll('#hdx-3W-status').select('svg').append('g');

    g.append('text')
        .attr('class', 'x-axis-label')
        .attr('text-anchor', 'middle')
        .attr('x', $('#hdx-3W-status').width()/2)
        .attr('y', 160)
        .text('Activities');

}

//load 3W data

var dataCall = $.ajax({
    type: 'GET',
    url: config.data,
    dataType: 'json',
});

//load geometry

var geomCall = $.ajax({
    type: 'GET',
    url: config.geo,
    dataType: 'json'
});

//when both ready construct 3W

$.when(dataCall, geomCall).then(function(dataArgs, geomArgs){
    var geom = geomArgs[0];
    geom.features.forEach(function(e){
        e.properties[config.joinAttribute] = String(e.properties[config.joinAttribute]);
    });
    generate3WComponent(config,dataArgs[0],geom);
});
