// !preview r2d3 data=data_for_d3 %>% select(Division,y0,y1) %>% mutate(indx=1:n()) %>% as.data.frame() %>% jsonlite::toJSON(dataframe="rows"), width = 800, height = 900, d3_version="6", viewer="browser", dependencies=here("js/labeler.js"), script=here("js/parallel_coord.js")
//
// r2d3: https://rstudio.github.io/r2d3
//

var margin = {top: 40, right: 200, bottom: 20, left: 200};

var panel = {
  width: width - margin.left - margin.right,
  height: height - margin.top - margin.bottom };

var fmt = d3.format("3.1f");

var config = {
     xOffset: 0,
     yOffset: 0,
     width: panel.width,
     height: panel.height,
     labelPositioning: {
         alpha: 0.5,
         spacing: 18
     },
     leftTitle: "2019",
     rightTitle: "2022",
     labelGroupOffset: 5,
     labelKeyOffset: 50,
     radius: 3,
     // Reduce this to turn on detail-on-hover version
     focusOpacity: 0.85,
     unfocusOpacity: 0.30
 };


data.forEach(function(d) {
               d.indx = +d.indx;
           });

var svg_here = svg.append("svg")
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var yMin = d3.min(data, function(d) {
    var y0 = d.y0;
    var y1 = d.y1;
    return Math.min(y0, y1);
});

var yMax = d3.max(data, function(d) {
      var y0 = d.y0;
    var y1 = d.y1;
    return Math.max(y0, y1);
});

// Calculate y domain for ratios
var yScale = d3.scaleLinear()
    .range([panel.height, 0])
    .domain([yMin, yMax]);

var borderLines = svg_here.append("g")
    .attr("class", "border-lines");

borderLines.append("line")
    .attr("x1", 0).attr("y1", 0)
    .attr("x2", 0).attr("y2", config.height);
borderLines.append("line")
    .attr("x1", panel.width).attr("y1", 0)
    .attr("x2", panel.width).attr("y2", config.height);

var slopeGroups = svg_here.append("g")
    .selectAll("g")
    .data(data)
    .enter()
    .append("g")
    .attr("class", "slope-group")
    .attr("id", function(d) { return 'slope' + d.indx; })
    .on("mouseover",
    function(d){
	    var node = d3.select(this);
	    var id = node.attr("id");
	    node.selectAll("circle")
	      .style("stroke-width",1)
	      .style("fill","orange")
	      .attr("r",4);
	    node.selectAll("line")
	    .style("opacity",1)
	    .style("stroke-width","3px");
	    node.selectAll("text").style("fill","#333");
    }
    )
    .on("mouseout",
    function(d){
      var node = d3.select(this);
      var id = node.attr("id");

      node.selectAll("circle")
        .style("fill",function(d) { return d.c200 ? "blue" : "transparent";})
        .style("stroke", function(d) { return d.c200 ? "blue" : "#333";})
        .attr("r",config.radius);

	    node.selectAll("line")
	      .style("opacity",0.2)
	      .style("stroke-width", function(d) { return d.c200 ? 3 : 1;});

	    node.selectAll("text").style("fill","transparent");
	}
	);

var slopeLines = slopeGroups.append("line")
    .attr("class", "slope-line")
    .attr("x1",2)
    .attr("y1", d => yScale(d.y0))
    .attr("x2", panel.width-2)
    .attr("y2", d => yScale(d.y1))
    .attr("id", function(d) { return 'slope' + d.indx; })
    .style("opacity",0.2)
    .style("stroke", function(d) { return d.c200 ? "blue" : "black";})
    .style("stroke-width", function(d) { return d.c200 ? 3 : 1;});

var leftSlopeCircle = slopeGroups.append("circle")
    .attr("r", config.radius)
    .attr("cy", d => yScale(d.y0))
    .style("fill",function(d) { return d.c200 ? "blue" : "transparent";})
    .style("stroke", function(d) { return d.c200 ? "blue" : "#333";})
    .style("stroke-width",1)
    .attr("id", function(d) { return 'slope' + d.indx; });

var leftSlopeLabels = slopeGroups.append("g")
    .attr("class", "slope-label-left")
    .each(function(d) {
        d.xLeftPosition = -config.labelGroupOffset;
        d.yLeftPosition = yScale(d.y0);
    })
    .attr("id", function(d) { return 'slope' + d.indx; });

leftSlopeLabels.append("text")
    .attr("class", "label-figure")
    .attr("x", d => d.xLeftPosition)
    .attr("y", d => d.yLeftPosition)
    .attr("dx", -10)
    .attr("dy", 3)
    .attr("text-anchor", "end")
    .text(d => d.Division + " " + fmt(d.y0))
    .style("fill","transparent");

var rightSlopeCircle = slopeGroups.append("circle")
    .attr("r", config.radius)
    .attr("cx", config.width)
    .attr("cy", d => yScale(d.y1))
    .style("fill",function(d) { return d.c200 ? "blue" : "transparent";})
    .style("stroke", function(d) { return d.c200 ? "blue" : "#333";})
    .style("stroke-width",1)
    .attr("id", function(d) { return 'slope' + d.indx; });

var rightSlopeLabels = slopeGroups.append("g")
    .attr("class", "slope-label-right")
    .each(function(d) {
        d.xRightPosition = panel.width + config.labelGroupOffset;
        d.yRightPosition = yScale(d.y1);
    })
    .attr("id", function(d) { return 'slope' + d.indx; });


rightSlopeLabels.append("text")
    .attr("class", "label-figure")
    .attr("x", d => d.xRightPosition)
    .attr("y", d => d.yRightPosition)
    .attr("dx", 10)
    .attr("dy", 3)
    .attr("text-anchor", "start")
    .text(d => fmt(d.y1) + " " + d.Division)
        .style("fill","transparent");

var titles = svg_here.append("g")
    .attr("class", "axistitle");

titles.append("text")
    .attr("text-anchor", "middle")
    .attr("dx", 0)
    .attr("y",yScale(yMax))
    .attr("dy", -14)
    .text(config.leftTitle)
    .style("fill","black");

titles.append("text")
    .attr("text-anchor", "middle")
    .attr("x", config.width)
    .attr("y",yScale(yMax))
    .attr("dx", 0)
    .attr("dy", -14)
    .text(config.rightTitle)
    .style("fill","black");





