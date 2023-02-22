---
title: "Candidate and party performance across forms of voting"
title-block-banner: true
description: |
  Over half of the Australian electorate did not vote at a polling place on Election Day in 2022.  How does support for political parties or candidates vary across different forms of voting?  
author:
  - name: "Professor Simon Jackman"
    orcid: 0000-0001-7421-4034
    affiliation: "University of Sydney"
    email: "simonjackman@icloud.com"
    url: https://simonjackman.netlify.app
website:
  google-analytics: 'G-DD0XG6JZDH'
date: 2022-06-22
date-format: "D MMMM YYYY"
format:
  html:
    theme: cosmo
    css: custom.css
    mainfont: Avenir Next
    fontsize: 16px
    toc: true
    fig-width: 8
    fig-height: 6
    echo: false
    code-tools: true
    smooth-scroll: true
    self-contained: true
tbl-cap-location: bottom    
crossref:
  tbl-title: Table
knitr: 
  opts_knit: 
    echo: FALSE
    warnings: FALSE
    message: FALSE
execute:
  keep-md: true
  warning: false
  error: false
  echo: false
---
```{=html}
<script src="https://cdn.jsdelivr.net/npm/d3@7"></script>
```
```{=html}
<script src="https://cdn.jsdelivr.net/npm/@observablehq/plot"></script>
```
```{=html}
<script>
</script>
```


::: {.cell}

:::


# Summary {.highlights}

- 2022 saw less than half of the electorate turn out to vote in-person and on Election Day.

- Pre-polling and postal voting continued to become more prevalent methods of voting in 2022, accounting for 33% and 14% of 2022 turnout, respectively (<a href="#tbl-national">Table 1</a>; @fig-vote-type-ojs).

- Coalition voters are more likely to use pre-polling or postal votes. In 2022, Coalition House candidates did 3 percentage points better in pre-polls than in other forms of voting, and 6 percentage points better in postal votes than in other forms of voting (<a href="#tab-breakdown">Table 2</a>; <a href="#tbl-vote-shares-by-type-2022-perf">Table 3</a>).

-   The **six C200-supported candidates successfully elected to the House of Representatives typically *under-performed* in postal votes relative to other forms of voting** (@fig-postal-perf).  In part, this is due to the demographic and political dispositions of electors availing themselves of postal voting.

-   But **incumbent independents (e.g., Wilkie, Steggall, Haines, Sharkie) did just as well *or better* among postal votes** relative to other forms of voting.

-   Why? Does incumbency confer advantages on candidates with respect to shifting their voters to postal voting? If so, what are those advantages?   Or alternatively, are incumbents doing a better job attracting the votes of electors committed to voting by mail?

# Recommendations {.highlights}

-   [Section 90B of the *Commonwealth Electoral Act*](https://www.legislation.gov.au/Details/C2022C00074/Html/Volume_1#_Toc96088289) entitles successful House of Representatives candidates to a version of the electoral roll with postal voting information appended for each voter; in particular see section 90B(10). Analysis of that information will be vital in helping answer the questions posed above, and to ensure that postal voting etc are not points of vulnerability for Independent candidates in future elections.

- Pooling this information from the AEC across multiple divisions would strengthen the analytical power and practical utility of this proposed analysis.   

- Given restrictions on access to the electoral roll, legal advice can inform if and how this combined analysis can be undertaken. 

# Vote types in Australian federal elections

The AEC classifies votes as follows:

-   **ordinary votes**: cast in person at polling places, typically in the elector's division of enrolment or at designated voting centres in capital cities and provincial centres adjoining that division. In 2019 83.2% of electors turned out to vote this way. The AEC includes **pre-poll** votes in this group, votes cast in person at pre-polling voting centres (PPVCs) or AEC divisional offices.

There are four types of **declaration votes**, where the voter signs a declaration instead of being marked off against the roll:

-   **postal votes**: electors may request a mail ballot from the AEC and return it through the post. This is the most prevalent form of declaration voting, and form the vast bulk of the ballots counted after election night, as many postal votes have been returned to the AEC before Election Day.

-   **absent votes**: votes cast on Election Day, in person at a polling place, by electors outside of their division of enrolment (but still within their state or territory).

-   **declaration pre-poll votes**: pre-poll ballots cast away from the elector's division of enrolment.

-   **provisional votes**: ballots cast subject to AEC verification of the voter's claim to be enrolled and entitled to vote in a particular division (typically used in cases of errors in names or addresses on the roll) or when the voter is registered as a silent elector.

# Change in prevalence of voting types, 2019 to 2022


::: {.cell}

:::


<a href="#tbl-national">Table 1</a> shows the change in rates of the three most prevalent voting types between the 2019 and 2022 federal elections at the divisional level. Postal voting and pre-polling continued to surge in popularity in 2022. Postals and PPVCs have become more prevalent while in-person, Election Day voting has become less popular, accounting for less than 46% of 2022 turnout.


::: {.cell tbl-cap='this caption 3:06PM Tuesday 28 June 2022. {#tbl-eek}'}
::: {.cell-output-display}

```{=html}
<div class="datatables html-widget html-fill-item-overflow-hidden html-fill-item" id="tbl-national" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="tbl-national">{"x":{"filter":"none","vertical":false,"extensions":["Buttons","RowGroup"],"caption":"<caption>Table 1: Percentage of votes cast by indicated method, including informal ballots. 2019 data from AEC website. 2022 AEC data last updated 3:06PM Tuesday 28 June 2022.<\/caption>","data":[["Ordinary Votes","Ordinary Votes","Declaration Votes","Declaration Votes","Declaration Votes","Declaration Votes"],["Polling Place on Election Day","Pre-poll voting center (PPVC)","Absent","Postal","Declaration pre-poll","Provisional"],[54.9140027156898,28.2902222443728,4.08706802532452,8.26563549632385,4.11157656871909,0.331494949569927],[45.2851844586437,33.3060524549589,3.20355642274858,14.2963185884002,3.58779769902801,0.321090376220646]],"container":"<table class=\"display row_grouped\">\n  <thead>\n    <tr>\n      <th>decvote<\/th>\n      <th>Vote Type<\/th>\n      <th>2019<\/th>\n      <th>2022<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"Bt","searching":false,"paging":false,"ordering":false,"rowGroup":{"dataSrc":0},"columnDefs":[{"targets":3,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"targets":2,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"targets":0,"visible":false},{"className":"dt-right","targets":[2,3]}],"buttons":["copy","csv","excel"],"order":[],"autoWidth":false,"orderClasses":false}},"evals":["options.columnDefs.0.render","options.columnDefs.1.render"],"jsHooks":[]}</script>
```

:::
:::


<br>


::: {.cell}

:::


@fig-vote-type-ojs displays the rates at which voters use different methods of voting by division, comparing 2019 rates (horizontal axis) to 2022 rates (vertical axis). 
<!-- Divisions where Independent candidates were supported by C200 are shown in the lower row of @fig-vote-type-ojs. -->




:::{.cell}

```{.js .cell-code .hidden startFrom="295" source-offset="-0"}
vtype_data = transpose(vtype)
xdomain = d3.extent(vtype_data.flatMap(d => [d.per_historic, d.per]))
yhat_data = transpose(yhat)
```

:::{.cell-output .cell-output-display}

:::{}

:::{#ojs-cell-1-1 nodetype="declaration"}
:::
:::
:::

:::{.cell-output .cell-output-display}

:::{}

:::{#ojs-cell-1-2 nodetype="declaration"}
:::
:::
:::

:::{.cell-output .cell-output-display}

:::{}

:::{#ojs-cell-1-3 nodetype="declaration"}
:::
:::
:::
:::

:::{.cell}

```{.js .cell-code .hidden startFrom="304" source-offset="-0"}
addTooltips = (chart, hover_styles = { fill: "blue", opacity: 0.5 }) => {
  let styles = hover_styles;
  const line_styles = {
    stroke: "blue",
    "stroke-width": 3
  };
  // Workaround if it's in a figure
  const type = d3.select(chart).node().tagName;
  let wrapper =
    type === "FIGURE" ? d3.select(chart).select("svg") : d3.select(chart);

  // Workaround if there's a legend....
  const numSvgs = d3.select(chart).selectAll("svg").size();
  if (numSvgs === 2)
    wrapper = d3
      .select(chart)
      .selectAll("svg")
      .filter((d, i) => i === 1);
  wrapper.style("overflow", "visible"); // to avoid clipping at the edges

  // Set pointer events to visibleStroke if the fill is none (e.g., if its a line)
  wrapper.selectAll("path").each(function (data, index, nodes) {
    // For line charts, set the pointer events to be visible stroke
    if (
      d3.select(this).attr("fill") === null ||
      d3.select(this).attr("fill") === "none"
    ) {
      d3.select(this).style("pointer-events", "visibleStroke");
      styles = _.isEqual(hover_styles, { fill: "blue", opacity: 0.5 })
        ? line_styles
        : hover_styles;
    }
  });

  const tip = wrapper
    .selectAll(".hover-tip")
    .data([""])
    .join("g")
    .attr("class", "hover")
    .style("pointer-events", "none")
    .style("text-anchor", "middle");

  // Add a unique id to the chart for styling
  const id = id_generator();

  // Add the event listeners
  d3.select(chart)
    .classed(id, true) // using a class selector so that it doesn't overwrite the ID
    .selectAll("title")
    .each(function () {
      // Get the text out of the title, set it as an attribute on the parent, and remove it
      const title = d3.select(this); // title element that we want to remove
      const parent = d3.select(this.parentNode); // visual mark on the screen
      const t = title.text();
      if (t) {
        parent.attr("__title", t).classed("has-title", true);
        title.remove();
      }
      // Mouse events
      parent
        .on("mousemove", function (event) {
          const text = d3.select(this).attr("__title");
          const pointer = d3.pointer(event, wrapper.node());
          if (text) tip.call(hover, pointer, text.split("\n"));
          else tip.selectAll("*").remove();

          // Raise it
          d3.select(this).raise();
          // Keep within the parent horizontally
          const tipSize = tip.node().getBBox();
          if (pointer[0] + tipSize.x < 0)
            tip.attr(
              "transform",
              `translate(${tipSize.width / 2}, ${pointer[1] + 7})`
            );
          else if (pointer[0] + tipSize.width / 2 > wrapper.attr("width"))
            tip.attr(
              "transform",
              `translate(${wrapper.attr("width") - tipSize.width / 2}, ${
                pointer[1] + 7
              })`
            );
        })
        .on("mouseout", function (event) {
          tip.selectAll("*").remove();
          // Lower it!
          d3.select(this).lower();
        });
    });

  // Remove the tip if you tap on the wrapper (for mobile)
  wrapper.on("touchstart", () => tip.selectAll("*").remove());
  // Add styles
  const style_string = Object.keys(styles)
    .map((d) => {
      return `${d}:${styles[d]};`;
    })
    .join("");

  // Define the styles
  const style = html`<style>
      .${id} .has-title {
       cursor: pointer; 
       pointer-events: all;
      }
      .${id} .has-title:hover {
        ${style_string}
    }
    </style>`;
  chart.appendChild(style);
  return chart;
}

// Function to position the tooltip
hover = (tip, pos, text) => {
  const side_padding = 10;
  const vertical_padding = 2;
  const vertical_offset = 24;

  // Empty it out
  tip.selectAll("*").remove();

  // Append the text
  tip
    .style("text-anchor", "middle")
    .style("pointer-events", "none")
    .attr("transform", `translate(${pos[0]}, ${pos[1] - 6})`)
    .selectAll("text")
    .data(text)
    .join("text")
    .style("dominant-baseline", "ideographic")
    .text((d) => d)
    .attr("y", (d, i) => (i - (text.length - 1)) * 18 - vertical_offset)
    .style("font-weight", (d, i) => (i === 0 ? "bold" : "normal"));

  const bbox = tip.node().getBBox();

  // Add a rectangle (as background)
  tip
    .append("rect")
    .attr("y", bbox.y - vertical_padding)
    .attr("x", bbox.x - side_padding)
    .attr("width", bbox.width + side_padding * 2)
    .attr("height", bbox.height + vertical_padding * 2)
    .style("fill", "white")
    .style("stroke", "#eee")
    .lower();
    
  tip
    .append("line")
    .attr("x1",bbox.x + bbox.width/2)
    .attr("x2",bbox.x + bbox.width/2)
    .attr("y1",bbox.y + vertical_padding)
    .attr("y2",this.y)
    .style("stroke","#eee")
    .lower();
}

// To generate a unique ID for each chart so that they styles only apply to that chart
id_generator = () => {
  var S4 = function () {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
  };
  return "a" + S4() + S4();
}

Plot = tooltipPlugin(await require("@observablehq/plot"))

tooltipPlugin = (Plot) => {
  const { plot } = Plot;
  Plot.plot = ({ tooltip, ...options }) => addTooltips(plot(options), tooltip);
  return Plot;
}
```

:::{.cell-output .cell-output-display}

:::{}

:::{#ojs-cell-2-1 nodetype="declaration"}
:::
:::
:::

:::{.cell-output .cell-output-display}

:::{}

:::{#ojs-cell-2-2 nodetype="declaration"}
:::
:::
:::

:::{.cell-output .cell-output-display}

:::{}

:::{#ojs-cell-2-3 nodetype="declaration"}
:::
:::
:::

:::{.cell-output .cell-output-display}

:::{}

:::{#ojs-cell-2-4 nodetype="declaration"}
:::
:::
:::

:::{.cell-output .cell-output-display}

:::{}

:::{#ojs-cell-2-5 nodetype="declaration"}
:::
:::
:::
:::

:::{.cell}

```{.js .cell-code .hidden startFrom="482" source-offset="0"}
Plot.plot({
  grid: false,
  width: 1020,
  height: 480,
  insetTop: 18,
  
  style: {
    fontSize: "16px"
  },
  
  x: {
    label: "2019 Percentage →",
    labelOffset: 0
  },
  
  y: {
    label: "↑ 2022 Percentage"
  },

  facet: {
    data: vtype_data,
    x: "Type"
    //y: "c200",
    //marginRight: 60 
    },
    
  fx: {
    padding: 0.1,
    labelOffset: 48
  },
  
  /* fy: {
    axis: 'right',
    padding: 0.1,
    label: 'C200\nsupported'
  }, */
  
  marks: [
    Plot.link([1],
      {x1: 0, x2: xdomain[1], y1: 0, y2: xdomain[1]}
      ),
      
   Plot.link([0.7, 0.8, 0.9], {
      x1: 0,
      y1: 0,
      x2: xdomain[1],
      y2: k => xdomain[1]*k,
      strokeOpacity: 0.2
    }),
    
    Plot.text([0.7, 0.8, 0.9, 1.0], {
      x: xdomain[1],
      y: k => xdomain[1]*k,
      text: d => d === 1 ? "Equal" : d3.format("+.0%")(d - 1),
      textAnchor: "start",
      fontSize: "11px",
      dx: 6      
    }),
    
    Plot.link([0.1, 0.25, 0.5], {
      x1: 0,
      y1: 0,
      x2: k => xdomain[1]/(1+k),
      y2: k => xdomain[1],
      strokeOpacity: 0.2
    }),
    
    Plot.text([0.1, 0.25, 0.5], {
      x: k => xdomain[1]/(1+k),
      y: k => xdomain[1],
      text: d => d === 1 ? "Equal" : d3.format("+.0%")(d),
      textAnchor: "middle",
      fontSize: "11px",
      dy: -6      
    }),
    
    Plot.dot(vtype_data,
    { x: "per_historic", 
      y: "per" ,
      title: (d) => `${d.Division} (${d.State}) \n 2022: ${d3.format(".1f")(d.per)} \n 2019: ${d3.format(".1f")(d.per_historic)}`,
      stroke: "#3333337f"
    }
    ),
  
    Plot.line(yhat_data,
      { x: "per_historic",
        y: "per",
        facet: "include",
        stroke: "orange",
        strokeWidth: 3
      }
    )
    
  ],
  
  tooltip: {
    fill: "red"
  }  
  
})
```

:::{#fig-vote-type-ojs .cell-output .cell-output-display}

:::{#ojs-cell-3 nodetype="expression"}
:::
Postal and PPVC voting surged in 2022, and in-person, Election Day voting fell to less than 50% of 2022 turnout.  Each column of plots corresponds to a form of voting.   Each data point is a House of Representatives division; percentages are of method of voting (including informal ballots).  Orange lines indicate trends.  Roll over each data point to display division name.
:::
:::


::: {.cell}

:::

::: {.cell}

:::


# Differences in vote support across voting type

Conventionally, (a) major parties outperform minor parties and independents on postals; (b) the Coalition generally outperforms Labor on postals, but this out-performance is less pronounced and even reversed in other forms of voting.

The reasons for this are straightforward:

-   major parties have the organisational resources to make use of the AEC's data on who votes by post etc, to send out applications for postal ballots, to track changes of addresses given their access to to the roll

-   older, wealthier voters make use of postal voting, both for convenience and because they have more time and resources to apply for the ballot, complete it and mail it back. This segment of the electorate skews towards the Coalition.

These patterns are evident in differences in party performance across voting types in the 2022 election, using figures available at this stage of the count, as shown in the following two tables. <a href="#tab-breakdown">Table 2</a> shows first-preference, House of Representatives percentages for each party in 2022 by vote type; <a href="#tbl-vote-shares-by-type-2022-perf">Table 3</a> presents the same data but with each party's vote share by vote type expressed *relative* to that party's performance in other vote types.


::: {.cell tbl-cap='Vote shares by vote type, 2022 House of Representatives election. AEC data last updated 3:06PM Tuesday 28 June 2022. {#tbl-vote-shares-by-type-2022}'}
::: {.cell-output-display}

```{=html}
<div class="datatables html-widget html-fill-item-overflow-hidden html-fill-item" id="tbl-breakdown" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="tbl-breakdown">{"x":{"filter":"none","vertical":false,"class":"display","caption":"<caption>Table 2: Percentage of House of Representatives first preferences won by party by type. 2022 AEC data last updated 3:06PM Tuesday 28 June 2022.<\/caption>","data":[["Coalition","GRN","IND","Labor","OTH","PHON","UAP","Informal","Prevalence of vote type:"],[37.6848959248498,10.3751149997451,5.85920273208315,32.9206309288729,4.75081746561993,4.59724748148273,3.81209046734637,4.83839928537792,33.3060524549589],[33.301056190215,13.2677362548459,6.12535562972424,32.5192191704749,5.22016859046205,5.08582084415646,4.48064332012144,6.06819987220272,45.2851844586437],[26.7520689410505,19.6500484849267,4.17722907031497,29.904556723064,6.91539111532532,6.63071686737921,5.96998879793934,6.39069358023395,3.20355642274858],[40.3742728953263,10.5158117466674,4.63595745404261,32.1242751076713,4.67517418142068,4.63698211912849,3.03752649574322,3.12526013297093,14.2963185884002],[32.5217038585263,15.7557900429852,4.56292757493301,30.162870486696,6.29923625703979,5.98844338781129,4.7090283920084,4.32738501918976,3.58779769902801],[26.7312600025953,15.3683117781911,4.65850599074354,35.2653661490549,6.53574981616852,5.76798304424932,5.67282321899736,7.1749420888307,0.321090376220646],[35.7003820577088,12.2517214972165,5.29481394486761,32.5807784710624,5.08576208458916,4.9625616735391,4.12398027101635,5.18929779808127,null]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th rowspan=\"2\" style=\"vertical-align: bottom;\">Party<\/th>\n      <th colspan=\"2\" style=\"border-bottom:hidden;text-align:center;padding-left:3px;padding-right:3px;padding-bottom:0;\">\n        <div style=\"border-bottom:1px solid #ddd;padding-bottom:5px;\">Ordinary Votes<\/div>\n      <\/th>\n      <th colspan=\"4\" style=\"border-bottom:hidden;text-align:center;padding-left:3px;padding-right:3px;padding-bottom:0;\">\n        <div style=\"border-bottom:1px solid #ddd;padding-bottom:5px;\">Declaration Votes<\/div>\n      <\/th>\n      <th rowspan=\"2\" style=\"vertical-align: bottom;\">Total<\/th>\n    <\/tr>\n    <tr>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Polling Place<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">PPVC<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Absent<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Postal<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Pre-poll<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Provisional<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"Bt","searching":false,"paging":false,"ordering":false,"buttons":["copy","csv","excel"],"columnDefs":[{"targets":1,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"targets":2,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"targets":3,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"targets":4,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"targets":5,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"targets":6,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"targets":7,"render":"function(data, type, row, meta) {\n    return type !== 'display' ? data : DTWidget.formatRound(data, 1, 3, \",\", \".\", null);\n  }"},{"className":"dt-right","targets":[1,2,3,4,5,6,7]}],"order":[],"autoWidth":false,"orderClasses":false,"rowCallback":"function(row, data, displayNum, displayIndex, dataIndex) {\nvar value=data[7]; $(this.api().cell(row, 7).node()).css({'border-left':'1px solid'});\nvar value=data[0]; $(this.api().cell(row, 0).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 1).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 2).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 3).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 4).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 5).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 6).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 7).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\n}"}},"evals":["options.columnDefs.0.render","options.columnDefs.1.render","options.columnDefs.2.render","options.columnDefs.3.render","options.columnDefs.4.render","options.columnDefs.5.render","options.columnDefs.6.render","options.rowCallback"],"jsHooks":[]}</script>
```

:::
:::

::: {.cell tbl-cap='Over and under-performance, by party and form of voting, 2022 House of Representatives election. Positive/negative quantities (in blue/red) mean that candidates of the respective party fare better/worse in that type of vote than in others. {#tbl-vote-shares-by-type-2022-perf}'}
::: {.cell-output-display}

```{=html}
<div class="datatables html-widget html-fill-item-overflow-hidden html-fill-item" id="tbl-vote-shares-by-type-2022-perf" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="tbl-vote-shares-by-type-2022-perf">{"x":{"filter":"none","vertical":false,"class":"display","caption":"<caption>Table 3: Over and under performance across types of voting, 2022 House of Representatives first preferences. Positive/negative quantities (in blue/red) mean that candidates of the respective party fare better/worse in that type of vote than in others. 2022 AEC data last updated 3:06PM Tuesday 28 June 2022.<\/caption>","data":[["Coalition","GRN","IND","Labor","OTH","PHON","UAP","Informal","Prevalence of vote type:"],["<span style='color: red;'> -4.1<\/span>","<span style='color: blue;'>+1.9<\/span>","<span style='color: blue;'>+0.8<\/span>","<span style='color: blue;'>+0.1<\/span>","<span style='color: blue;'>+0.3<\/span>","<span style='color: blue;'>+0.3<\/span>","<span style='color: blue;'>+0.7<\/span>","<span style='color: blue;'>+1.6<\/span>","45.3"],["<span style='color: blue;'>+3.2<\/span>","<span style='color: red;'> -2.7<\/span>","<span style='color: blue;'>+0.2<\/span>","<span style='color: blue;'>+0.7<\/span>","<span style='color: red;'> -0.5<\/span>","<span style='color: red;'> -0.5<\/span>","<span style='color: red;'> -0.4<\/span>","<span style='color: red;'> -0.5<\/span>","33.3"],["<span style='color: red;'> -9.1<\/span>","<span style='color: blue;'>+7.7<\/span>","<span style='color: red;'> -1.6<\/span>","<span style='color: red;'> -2.6<\/span>","<span style='color: blue;'>+1.9<\/span>","<span style='color: blue;'>+1.7<\/span>","<span style='color: blue;'>+1.9<\/span>","<span style='color: blue;'>+1.2<\/span>","3.2"],["<span style='color: blue;'>+5.7<\/span>","<span style='color: red;'> -2.0<\/span>","<span style='color: red;'> -1.2<\/span>","<span style='color: red;'> -0.4<\/span>","<span style='color: red;'> -0.5<\/span>","<span style='color: red;'> -0.4<\/span>","<span style='color: red;'> -1.3<\/span>","<span style='color: red;'> -2.4<\/span>","14.3"],["<span style='color: red;'> -3.1<\/span>","<span style='color: blue;'>+3.7<\/span>","<span style='color: red;'> -1.2<\/span>","<span style='color: red;'> -2.4<\/span>","<span style='color: blue;'>+1.3<\/span>","<span style='color: blue;'>+1.1<\/span>","<span style='color: blue;'>+0.6<\/span>","<span style='color: red;'> -0.9<\/span>","3.6"],["<span style='color: red;'> -8.8<\/span>","<span style='color: blue;'>+3.2<\/span>","<span style='color: red;'> -1.0<\/span>","<span style='color: blue;'>+2.8<\/span>","<span style='color: blue;'>+1.5<\/span>","<span style='color: blue;'>+0.8<\/span>","<span style='color: blue;'>+1.6<\/span>","<span style='color: blue;'>+2.0<\/span>","0.3"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th rowspan=\"2\" style=\"vertical-align: bottom;\">Party<\/th>\n      <th colspan=\"2\" style=\"border-bottom:hidden;text-align:center;padding-left:3px;padding-right:3px;padding-bottom:0;\">\n        <div style=\"border-bottom:1px solid #ddd;padding-bottom:5px;\">Ordinary Votes<\/div>\n      <\/th>\n      <th colspan=\"4\" style=\"border-bottom:hidden;text-align:center;padding-left:3px;padding-right:3px;padding-bottom:0;\">\n        <div style=\"border-bottom:1px solid #ddd;padding-bottom:5px;\">Declaration Votes<\/div>\n      <\/th>\n    <\/tr>\n    <tr>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Polling Place<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">PPVC<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Absent<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Postal<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Pre-poll<\/th>\n      <th style=\"text-align:right;vertical-align:bottom;padding-left:8px;padding-right:8px;\">Provisional<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"Bt","searching":false,"paging":false,"ordering":false,"columnDefs":[{"targets":[1,2,3,4,5,6],"className":"dt-body-right"}],"buttons":["copy","csv","excel"],"order":[],"autoWidth":false,"orderClasses":false,"rowCallback":"function(row, data, displayNum, displayIndex, dataIndex) {\nvar value=data[0]; $(this.api().cell(row, 0).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 2).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 1).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 3).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 4).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 5).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\nvar value=data[0]; $(this.api().cell(row, 6).node()).css({'border-bottom':value == \"UAP\" ? \"1px solid black\" : value == \"Informal\" ? \"1px solid black\" : value == \"Prevalence of vote type:\" ? \"1px solid black\" : null});\n}"}},"evals":["options.rowCallback"],"jsHooks":[]}</script>
```

:::
:::


These 2022 data are consistent with the patterns observed in previous elections:

-   the Coalition over-performs with postal votes and early voting at PPVCs, and under-performs with in Election Day, in-person voting at polling places.

-   while the Coalition is huge over-performer with respect to postal votes, Labor under-performance is close to zero.

-   Relatively few Coalition voters cast a provisional ballot, with Green and Labor voters more likely to vote this way.

-   The Greens have a disproportionate share of absentee votes, and their voters do better in Election Day, in-person voting at polling places.

-   Votes for Independent candidates are disproportionately cast in-person on Election Day, but are less likely to be cast as postal votes.


# Even successful C200-supported candidates lagged in postal votes

@fig-postal-perf disaggregates the data shown in summary form above for postal voting.   The preference for postal voting among Coalition voters --- and in seats held by the Coalition --- is clearly apparent (filled circles in @fig-postal-perf denote seats held by the indicated party going into the 2022 election), with almost all Coalition candidates faring better in postal votes than in other vote types.   

A strong performance is postal votes is hardly a guarantee of electoral success, and indeed, could well be a sign of electoral weakness (e.g., that a party's support is overly concentrated in an older segment of an electorate).   @fig-postal-perf highlights that losing Coalition incumbents in Wentworth, Goldstein, Curtin, Kooyong, Mackellar and North Sydney had strong over-performance among postal votes.

The picture is mixed for Labor candidates, with many Labor incumbents in particular recording small to moderate over-performances among postal votes.   Among postal votes, Green candidates almost always under-perform relative to their performance among other forms of voting, including their sole incumbent going into the 2022 election, Adam Bandt (Melbourne).


::: {.cell}

:::

::: {.cell}

:::



:::{.cell}

```{.js .cell-code .hidden startFrom="1379" source-offset="0"}
pd = transpose(pd_raw)
```

:::{.cell-output .cell-output-display}

:::{#ojs-cell-4 nodetype="declaration"}
:::
:::
:::

:::{.cell}

```{.js .cell-code .hidden startFrom="1386" source-offset="0"}
Plot.plot({
  grid: true,
  width: 1000,
  height: 1000,
  insetBottom: 2,
  insetTop: 2,
  
  style: {
    fontSize: "16px"
  },
  
  y: {
    domain: [-16, 17],
    ticks: 17,
    tickFormat: "+",
    label: "Share of postal vote minus vote share among other vote types (percentage points) ↑"
  },
  
  x: {
    label: ""
  },

  facet: {
    data: pd,
    x: "party_group",
    frame: false,
    marginTop: 50,
    marginLeft: 0,
    marginRight: 0,
    marginBottom: 30
    },
    
  fx: {
    padding: 0.1,
    label: ""
  },
  
  marks: [
  
    Plot.ruleY([0], {stroke: "#333"}),
  
    Plot.dot(pd,
      Plot.dodgeX(
        {
          filter: (d) => !d.highlight,
          y: "perf",
          anchor: "middle",
          padding: 2,
          r: 4,
          title: (d) => `${d.Division} (${d.State}) \n ${d3.format("+.1f")(d.perf)} \n ${d.name}`,
          stroke: (d) => d.color,
          fill: (d) => d.incumbent_2022 ? d.color : "transparent"
        }
      )
    ),
    
     Plot.text(pd,
      Plot.dodgeX(
      {
        filter: "highlight",
        y: "perf",
        anchor: "middle",
        padding: 50,
        text: (d) => (d.incumbent_2022 ? '●' : '○') + d.Division,
        fill: "color",
        stroke: "#fff",
        fontSize: "13px",
        textAnchor: "start",
        fontWeight: 700,
        title: (d) => `${d.Division} (${d.State}) \n ${d3.format("+.1f")(d.perf)} \n ${d.name}`,
      })
    )
    
  ],
  
  tooltip: {
  }  
  
})
```

:::{#fig-postal-perf .cell-output .cell-output-display}

:::{#ojs-cell-5 nodetype="expression"}
:::
Postal voting performance of House of Representatives candidates, relative to performance among other type of votes.  Each point shows the difference between a candidate's share of the postal vote and their share of all other vote types.   Incumbents (or candidates of incumbent parties) are denoted with filled circles, challengers are shown with open circles; data for C200-supported independents are coloured teal; Sharkie (XEN; Mayo, SA) and Katter (KAP; Kennedy, QLD) are denoted as IND for inclusion in the graph.   Data are randomly jittered in the horizontal dimension to show the density of the data and to avoid overplotting.   Roll over each data point to display details.
:::
:::



Most independent candidacies are quixotic, generating low vote shares that vary little across vote types; as show in @fig-postal-perf, postal vote shares for most independents are identical to their vote shares in other forms of voting.

But like Labor and Coalition candidates, incumbent independents tend to do better among postal votes than among other forms of voting.   For non-incumbent independents, including the successful, C200-supported candidates, their performance among postal vote lags their performance across over types of voting, and by substantial margins.


# Postal vote performance and incumbency

We look closer at relative performance in postal votes (RPV), comparing established, incumbent independents and independents challenging incumbents (or candidates of incumbent parties).   

We also include data from 2019 --- when at least two of 2022's incumbent independents were challengers (Haines and Steggall) --- to start to assess the role of incumbency as a predictor of postal vote performance. Further, in 2019, Kerryn Phelps was the independent incumbent in Wentworth, challenged successfully by Dave Sharma, who in turn was challenged successfully by independent Allegra Spender in 2022.  

These _within-division_ comparisons have the benefit of holding constant any time-invariant, divisional-level factors that might influence the postal vote performance of independents, while at the same time capturing some variation in the incumbency status of independent candidates.

<a href="#tab-postal-independents">Table 4</a> presents data from this relatively small set of independent candidacies, showing (a) the level of postal vote performance relative to other vote types for both 2019 and 2022 (RPV), (b) the change (∆) in RPV as well as (c) the prevalence of postal voting in the division in 2019 and 2022 and (d) change in prevalance.   We also note the incumbency status of the independent candidate in each case.



::: {.cell}

:::

::: {.cell}

:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="datatables html-widget html-fill-item-overflow-hidden html-fill-item" id="tab-postal-independents" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="tab-postal-independents">{"x":{"filter":"none","vertical":false,"class":["display","row_grouped"],"extensions":["Buttons","RowGroup"],"caption":"<caption>Table 4: Performance in postal votes relative to other vote types (RPV) and change, for six seats with repeated IND candidacies, 2019-2022.<\/caption>","data":[["Clark","Clark","Indi","Indi","Mayo","Mayo","Wannon","Wannon","Warringah","Warringah","Wentworth","Wentworth"],["Wilkie, Andrew","Wilkie, Andrew","Haines, Helen","Haines, Helen","Sharkie, Rebekha","Sharkie, Rebekha","Dyson, Alex","Dyson, Alex","Steggall, Zali","Steggall, Zali","Phelps, Kerryn","Spender, Allegra"],[2019,2022,2019,2022,2019,2022,2019,2022,2019,2022,2019,2022],["✓","✓","✘","✓","✓","✓","✘","✘","✘","✓","✓","✘"],[4.29414403021289,3.04617567811228,-4.00388857090865,1.46291215879432,-1.55401279400299,3.90762434145759,-2.64628703958728,-6.636884484656,-6.82917589382335,1.59797981790398,-5.48355516329157,-6.68796101481086],[null,-1.24796835210061,null,5.46680072970296,null,5.46163713546058,null,-3.99059744506872,null,8.42715571172733,null,-1.20440585151929],[9.57525272246084,14.8841872765846,8.1482042877308,13.0830944492014,9.04772967810217,12.9316120598088,7.98729894724905,11.3304093567251,7.2594027973902,12.0940486465688,10.0891650905161,14.6820175438596],[null,5.30893455412377,null,4.93489016147064,null,3.88388238170664,null,3.3431104094761,null,4.83464584917864,null,4.59285245334357]],"container":"<table id=\"tab-postal-independents\" class=\"display\">\n  <thead style=\"font-size:13px;padding-bottom:0px;\">\n    <tr style=\"vertical-align:bottom;\">\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\">RPV: share of<\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n    <\/tr>\n    <tr style=\"vertical-align:bottom;\">\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\">postal votes<\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\">Prevalence,<\/th>\n      <th class=\"my_th\"><\/th>\n    <\/tr>\n    <tr style=\"vertical-align:bottom;\">\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\">relative to<\/th>\n      <th class=\"my_th\"><\/th>\n      <th class=\"my_th\">postal votes<\/th>\n      <th class=\"my_th\">∆<\/th>\n    <\/tr>\n    <tr style=\"vertical-align:bottom;\">\n      <th><\/th>\n      <th><\/th>\n      <th class=\"my_th_2\">Election<\/th>\n      <th class=\"my_th_2\">Incumbent?<\/th>\n      <th class=\"my_th_2\">other vote types<\/th>\n      <th class=\"my_th_2\">∆ RPV<\/th>\n      <th class=\"my_th_2\">in division<\/th>\n      <th class=\"my_th_2\">prevalence<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"Bt","searching":false,"paging":false,"ordering":false,"rowGroup":{"dataSrc":0},"columnDefs":[{"targets":0,"visible":false},{"targets":[2,3,4,5,6,7],"class":"dt-center"},{"targets":[4,5,7],"render":"function(data,type,row,meta){\nif(!data) { return ''};\nvar prefix = data < 0.0 ? '':'+';\nreturn prefix + data.toFixed(1);\n}"},{"targets":6,"render":"function(data,type,row,meta){\nreturn data.toFixed(1) + '%';\n}"},{"className":"dt-right","targets":[2,4,5,6,7]}],"buttons":["copy","csv","excel"],"order":[],"autoWidth":false,"orderClasses":false,"rowCallback":"function(row, data, displayNum, displayIndex, dataIndex) {\nvar value=data[3]; $(this.api().cell(row, 3).node()).css({'color':value == \"✓\" ? \"green\" : value == \"✘\" ? \"red\" : null});\nvar value=data[4]; $(this.api().cell(row, 4).node()).css({'color':isNaN(parseFloat(value)) ? '' : value <= 0 ? \"red\" : \"blue\"});\n}"}},"evals":["options.columnDefs.2.render","options.columnDefs.3.render","options.rowCallback"],"jsHooks":[]}</script>
```

:::
:::


This small number of cases highlights again that (a) incumbent independents typically do better in postal votes than in other forms of voting; (b) that _becoming_ an incumbent boosts postal vote performance, as evidenced by the experience of Haines (Indi, VIC) and Steggall (Warringah, NSW), both transitioning relative under-performance among postals to over-performance as they transitioned from challenger to incumbent between the 2019 and 2022 elections:

- Haines' relative performance among postal votes (RPV) goes from -4.0 to +1.5 between 2019 and 2022, a gain of 5.5 percentage points;

- Steggall's RPV rises from -6.8 as a challenger in 2019 to +1.6 in 2022, a gain of 8.4 percentage points.  

These two data points can be distinguished from the changes in RPVs for independent candidates who did _not_ transition from challenger to incumbent:

- Sharkie (Mayo, SA) also sees a 5.5 improvement in RPV as an incumbent in both elections, the same as Haines, while Wilkie's RPV falls -1.2 percentage points.  

- Changes in RPV for the other cases --- -4.0 for Dyson (Wannon, VIC), a challenger in both elections, and -1.2 Spender relative to Phelps (Wentworth NSW) --- further suggest that incumbency is positively associated with RPV. 

Moreover, changes in the prevalence of postal voting are almost constant over this set of divisions, with little prospect of any confounding of the effect of incumbency on RPV with the increase in the use of postal voting between 2019 and 2022.



::: {.cell}

:::


Statistical tests confirm that incumbency promotes postal vote performance.   We estimate regressions of 2019-to-2022 change in RPV, with two predictors:

- change in incumbency between 2019 and 2022 (+1 for 2019 challenger to 2022 incumbent, 0 for no change and -1 for 2019 incumbent to 2022 challenger)

- change in the prevalence of postal voting in each division, 2019 to 2022, so that estimates of the incumbency changes are net of any effects on RPV due to the increase in the prevalence of postal voting.

We estimate this regression separately for Coalition, Independent candidates and Labor candidates.   Green candidates are omitted from this "differences-in-differences" analysis, since there is no variation in the incumbency status of Greens candidates between 2019 and 2022, with Adam Bandt remaining the sole Greens House of Representatives incumbent in both elections.   We also fit this model to differences in relative performance in votes cast at pre-poll voting centres (PPVC), the other vote type to surge in popularity in 2022.

@fig-regression-analysis presents these regression-based estimates of the effects of a transition to incumbency in graphical form: points correspond to the magnitude of the estimated effects and vertical lines cover 95% confidence intervals.   

As foreshadowed in the tables and charts above, the effects of transitioning to incumbency are large for independents, and are also positive and distinguishable from zero for Coalition (1.4, $t$ = 1.8) and Labor candidates (1.9, $t$ = 2.2).  No such effects are found in the case of "pre-poll" votes, the other voting type to surge in popularity in 2022.


::: {.cell}

:::



:::{.cell}

```{.js .cell-code .hidden startFrom="1773" source-offset="0"}
regdata = transpose(regression_tmp)
```

:::{.cell-output .cell-output-display}

:::{#ojs-cell-6 nodetype="declaration"}
:::
:::
:::

:::{.cell}

```{.js .cell-code .hidden startFrom="1779" source-offset="0"}
Plot.plot({
  grid: true,
  width: 1000,
  height: 1000,
  marginTop: 52,
  insetTop: -6,
  insetBottom: 2,
  
  style: {
    fontSize: "16px"
  },
  
  y: {
    ticks: 12,
    tickFormat: "+",
    label: "Effect of change in incumbency on change in RPV ↑"
  },
  
  x: {
    label: ""
  },

  facet: {
    data: regdata,
    x: "Type",
    marginLeft: 0,
    marginTop: 22
  },
    
  fx: {
    padding: 0.1,
    label: ""
  },
  
  marks: [
  
    Plot.ruleY([0], {stroke: "#333"}),
  
    Plot.link(regdata,
    {
      x: "party_group",
      y1: "lo",
      y2: "up",
      stroke: (d) => d.color,
      strokeWidth: 4
    }
    ),
  
    Plot.dot(regdata,
        {
          y: "estimate",
          x: "party_group",
          r: 8,
          title: (d) => `${d3.format(".1f")(d.estimate)} \n (t = ${d3.format(".1f")(d.statistic)}) \n n = ${d.n}`,
          stroke: (d) => d.color,
          fill: (d) => d.color
        }
    )

    
  ],
  
  tooltip: {
  }  
  
})
```

:::{#fig-regression-analysis .cell-output .cell-output-display}

:::{#ojs-cell-7 nodetype="expression"}
:::
Effect of change in incumbency status on change in relative postal voting performance.   Points denote the estimated effect; lines extend to over 95% confidence intervals. Roll over each data point to display details.
:::
:::



# Further research and recommendations

Incumbents appear to enjoy an advantage with respect to postal votes that they did not have as challengers.   As postal votes continue to grow in popularity, understanding the mechanisms by which this advantage arises will be vital as a general proposition, but in particular for C200-supported independents, holding seats traditionally considered Coalition-strongholds, seats in which the use of postal voting is higher than average.

In addition to quantitative data analysis, qualitative work with established, incumbent independents (Steggall, Haines, Sharkie, Wilkie) will help shed light on these mechanisms.

[Section 90B of the *Commonwealth Electoral Act*](https://www.legislation.gov.au/Details/C2022C00074/Html/Volume_1#_Toc96088289) entitles successful House of Representatives candidates to a version of the electoral roll with postal voting information appended for each voter; in particular see section 90B(10). Analysis of that information will be vital in helping answer the questions posed above, and to ensure that postal voting etc are not points of vulnerability for Independent candidates in future elections.

Pooling this information from the AEC across multiple divisions would strengthen the analytical power and practical utility of this proposed analysis.   

Given restrictions on access to the electoral roll, legal advice can inform if and how this combined analysis can be undertaken.




::: {.cell}

:::

::: {.cell}

:::

::: {.cell}

:::



<!-- The following table shows the performance of 0 Independent candidates across a variety of vote types, spanning not just C200 candidates, but established, incumbent independents as well (e.g., Wilkie in Clark, Steggal in Warrigah, Haines in Indi) and Dai Le in Fowler. -->

<!-- We provide some summary analysis of this detailed information, below, to draw out comparisons between novice C200-based candidates and established independents with respect to postal vote performance. -->
