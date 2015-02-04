

div_width = d3.select("#crossfilter_div").style("width").replace("px","");


d3.json("data/real_data.json", (hmmer_data) -> 
#d3.json("data/real_data_6000.json", (hmmer_data) -> 
	console.log hmmer_data
	# Set the divs
	example_data = [
				{"evalue":0.10, "x":7,"y":2,"sp":"Homo_sapiens", "da":"SH2", "bubble":4},
				{"evalue":10, "x":5,"y":5,"sp":"Homo_sapiens", "da":"SH2", "bubble":1},
				{"evalue":1, "x":9,"y":5,"sp":"Mus_musculus", "da":"SH2-SH3", "bubble":2},
				{"evalue":0.710, "x":3,"y":4,"sp":"Homo_sapiens", "da":"SH2", "bubble":2},
				{"evalue":2.1e-30, "x":1,"y":5,"sp":"Yeast", "da":"SH2-SH3", "bubble":4},
				{"evalue":2.1e-70, "x":2,"y":5,"sp":"Pan_troglodytes", "da":"SH2", "bubble":2}
				{"evalue":2.1e-80, "x":2,"y":5,"sp":"Fugu", "da":"SH2-BRAC2", "bubble":2}
				{"evalue":0.410, "x":2,"y":5,"sp":"Sheep", "da":"SH2-BRAC2", "bubble":2}
				{"evalue":0.410, "x":2,"y":5,"sp":"Saccharomyces", "da":"SH2-BRAC2", "bubble":2}
				{"evalue":0.410, "x":2,"y":5,"sp":"Escherichia coli", "da":"SH2-BRAC2", "bubble":2}
				{"evalue":0.410, "x":2,"y":5,"sp":"Nomascus_leucogenys", "da":"SH2-BRAC2", "bubble":2}
				{"evalue":0.410, "x":2,"y":5,"sp":"Gorilla_gorilla_gorilla", "da":"SH2-BRAC2", "bubble":2}
		]

	# build crossfilter object
	#data = crossfilter(example_data)
	data = crossfilter(hmmer_data.results.hits)
	
	jQuery(".total_hits").text(data.size);




	#totalEvalueByBin

	# set some values
	hmmer_data.results.hits.forEach (entry,i) ->
	#example_data.forEach (entry,i) ->
		# switch entry.sp
		# 	when "Homo_sapiens" then entry.eukaryota = 1
		# 	when "Nomascus_leucogenys" then entry.eukaryota = 1
		# 	when "Gorilla_gorilla_gorilla" then entry.eukaryota = 1
		# 	when "Sheep" then entry.eukaryota = 1
		# 	when "Mus_musculus" then entry.other = 1
		# 	when "Yeast" then entry.bacteria = 1
		# 	when "Pan_troglodytes" then entry.archaea = 1
		
		emtpy_line = Math.floor(Math.random() * 30) + 1	
		entry.evalue_bin =  emtpy_line
		# switch entry.evalue
		# 	when entry.evalue > 0 					&& entry.evalue <= Math.pow(1, -100) 	then entry.evalue_bin = 1
		# 	when entry.evalue > Math.pow(1, -100) 	&& entry.evalue <= Math.pow(1, -90) 	then entry.evalue_bin = 2
		# 	when entry.evalue > Math.pow(1, -90)	&& entry.evalue <= Math.pow(1, -80)		then entry.evalue_bin = 3
		# 	when entry.evalue > Math.pow(1, -80)	&& entry.evalue <= Math.pow(1, -70)		then entry.evalue_bin = 4
		# 	when entry.evalue > Math.pow(1, -70) 	&& entry.evalue <= Math.pow(1, -60) 	then entry.evalue_bin = 5
		# 	when entry.evalue > Math.pow(1, -60)	&& entry.evalue <= Math.pow(1, -50)		then entry.evalue_bin = 6
		# 	when entry.evalue > Math.pow(1, -50)	&& entry.evalue <= Math.pow(1, -40) 	then entry.evalue_bin = 7
		# 	when entry.evalue > Math.pow(1, -40) 	&& entry.evalue <= Math.pow(1, -30) 	then entry.evalue_bin = 8
		# 	when entry.evalue > Math.pow(1, -30)	&& entry.evalue <= Math.pow(1, -20)		then entry.evalue_bin = 9
		# 	when entry.evalue > Math.pow(1, -20)	&& entry.evalue <= Math.pow(1, -10) 	then entry.evalue_bin = 10
		# 	when entry.evalue > Math.pow(1, -10) 	&& entry.evalue <= Math.pow(1, -1) 		then entry.evalue_bin = 11
		# 	when entry.evalue > Math.pow(1, -1)		&& entry.evalue <= 10					then entry.evalue_bin = 12
		# 	else entry.evalue_bin = 13


	#console.log example_data
	#dc.units.fp.precision(0.001)
	
	# Build e-value distribution
	build_distribution_histogram data, "#distribution-chart"

	# Build e-value distribution
	build_domain_architecture data, "#domain_architecture-chart"

	# Build e-value distribution
	build_species_list data, "#modelOrganism_chart"
	#build_species_bubble_list data, "#modelOrganism_chart"


	build_hits_table data, "#hits_table"

	dc.renderAll(); 
	jQuery("#tree_spinner").hide();   
	return 0
)


build_species_list  = (data, div) ->
	rootChart = dc.rowChart(div)
	allowed_species =
			"Arabidopsis thaliana" : 1
			"Caenorhabditis elegans" : 1
			"Danio rerio" : 1
			"Dictyostelium discoideum" : 1
			"Drosophila melanogaster" : 1
			"Escherichia coli" : 1
			"Gallus gallus" : 1
			"Homo sapiens" : 1
			"Mus musculus" : 1
			"Rattus norvegicus" : 1
			"Saccharomyces cerevisiae" : 1
			"Schizosaccharomyces pombe" : 1


	species = data.dimension((d) -> 
		if d.species is "Homo sapiens" || d.species is "Arabidopsis thaliana" || d.species is "Caenorhabditis elegans"|| d.species is "Danio rerio"|| d.species is "Dictyostelium discoideum"|| d.species is "Drosophila melanogaster" || d.species is "Escherichia coli"|| d.species is "Gallus gallus"|| d.species is "Homo sapiens"|| d.species is "Mus musculus"|| d.species is "Rattus norvegicus"|| d.species is "Saccharomyces cerevisiae"|| d.species is "Schizosaccharomyces pombe"
			d.species 
		else
			"other"
	)
	no_of_top_entries = 10
	rootChartHight = no_of_top_entries * 20
	speciesGroup = species.group()
	rootChart.width(Math.floor(div_width/4)) # (optional) define chart width, :default = 200
                .height(rootChartHight) # (optional) define chart height, :default = 200
                .transitionDuration(750)
                .dimension(species) # set dimension
                .group(speciesGroup) # set group
                .title((d) ->  d.value )
                # dynamically adjust when the number of events are filtered by selections on any of the other charts
                .elasticX(true)
                #.centerBar(true)
                #.order(d3.ascending)
                #.renderHorizontalGridLines(false)
       			#.renderLabel(true)
                #.labelOffsetX(1)
                #.x(d3.scale.linear().domain([0,max_root_taxa+10]))
                #.x(d3.scale.linear().domain([0,200]))
                #.xAxisLabel('Number of families')
                .margins({top: 20, left: 10, right: 10, bottom: 20});
	#rootChart.labelOffsetX(10)
	#rootChart.labelOffsetY(13)


build_domain_architecture  = (data, div) ->
	DaChart = dc.rowChart(div)
	
	da1 = data.dimension((d) -> d.arch )
	daGroup1 = da1.group()
	
	# get top 5 domains architectures
	valid_da = {}
	no_of_top_entries = 3
	for k,v of daGroup1.top(no_of_top_entries)
		valid_da[v.value] = 1

	da = da1.filter((d) -> 
		if d.value of valid_da
			d.arch 
	)
	daGroup = da.group()
	#filtered_da_group = remove_da_entries(daGroup, valid_da)	
	daChartHight = no_of_top_entries * 20

	DaChart.width(Math.floor(div_width/4)) # (optional) define chart width, :default = 200
                .height(daChartHight) # (optional) define chart height, :default = 200
                .transitionDuration(750)
                .dimension(da1) # set dimension
                .group(daGroup1) # set group
                #.group(filtered_da_group) # set group
				#.rowsCap(4)
                #.renderLabel(true)
                .elasticX(true)

                #.ordering( (d) ->  -d.value )
                #.xAxis().ticks(4)
                #.labelOffsetX(1)
                #.x(d3.scale.linear().domain([0,max_root_taxa+10]))
                #.x(d3.scale.linear().domain([0,10]))
                #.xAxisLabel('Number of families')
                #.margins({top: 20, left: 10, right: 10, bottom: 20});
	
	DaChart.xAxis().ticks(4)
	#DaChart.data((group) -> return group.top5)

build_species_bubble_list  = (data, div) ->
	#rootChart = dc.rowChart(div)
	modelOrgaChart =dc.bubbleChart(div)
	allowed_species =
		"Homo_sapiens" : 1
		"Yeast" : 1

	species = data.dimension((d) -> 
		#console.log "looking at #{d.sp} is #{allowed_species.hasOwnProperty(d.sp)}"
		if allowed_species.hasOwnProperty(d.sp)
			return d.sp 
	)
	speciesGroup = species.group()
	console.log "there are #{speciesGroup.size()} ref species"
	


	dateGroup = species.group().reduce(
    (p, v) -> 
        ++p.count
        p.label = v.sp
        p.bubble = v.bubble
        p.x = v.x
        p.y = v.y
        p
    ,
    (p, v) -> 
        --p.count
        p.bubble = 0
        p.label = ""
        p.x = 0
        p.y = 0
        p
    , -> { count: 0, x: 0, y:0, label: "" }
    )

	#modelOrgaChart.width(Math.floor(div_width/3)) # (optional) define chart width, :default = 200
    #            .height(300) # (optional) define chart height, :default = 200
    #            .transitionDuration(750)
    #            .dimension(species) # set dimension
    #            .group(speciesGroup) # set group
    #            .renderLabel(true)
    #            .elasticX(true)
    #            .labelOffsetX(1)
    #            #.x(d3.scale.linear().domain([0,max_root_taxa+10]))
    #            .x(d3.scale.linear().domain([0,10]))
    #            #.xAxisLabel('Number of families')
    #            .margins({top: 20, left: 10, right: 10, bottom: 20});

	modelOrgaChart.width(Math.floor(div_width/4))
       			  .height(100)
       			  .dimension(species)
       			  .group(dateGroup)
       			  .transitionDuration(1500)
       			  .colors(["#a60000","#ff0000", "#ff4040","#ff7373","#67e667","#39e639","#00cc00"])
       			  .colorDomain([-12000, 12000])
       			  .x(d3.scale.linear().domain([0, 5.5]))
       			  .y(d3.scale.linear().domain([0, 5.5]))
       			  .r(d3.scale.linear().domain([0, 2500]))
       			  .keyAccessor((p) -> 
       			  	console.log "using #{p.value.label}"
       			  	p.value.label)
       			  .valueAccessor((p) -> 
       			  	console.log "using #{p.value.count}"
       			  	p.value.count)
       			  .radiusValueAccessor((p) -> p.value.count)
       			  .transitionDuration(1500)
       			  #.elasticY(true)
       			  #.yAxisPadding(1)
       			  #.xAxisPadding(1)
       			  #.label((p) -> p.sp )
       			  .renderLabel(true)
       			  #.renderlet( (chart) -> rowChart.filter(chart.filter())
	
build_distribution_histogram  = (data, div) -> 
	evaluesChart = dc.barChart(div)
	# construct a new dimension
	evalues = data.dimension((d) -> 
		#console.log "adding #{d.evalue_bin}"
		d.evalue_bin
		)
	max_evalue_bin = 30
	#
	evaluesGroup = evalues.group().reduceCount( (d) -> d.evalue_bin)
	#evaluesGroup = evalues.group()
	#
	evaluesEuk = data.dimension((d) ->  d.kingdom is 'Eukaryota')
	evaluesArc = data.dimension((d) ->  d.kingdom is 'Archaea')
	evaluesBac = data.dimension((d) ->  d.kingdom is 'Bacteria')
	evaluesOth = data.dimension((d) ->  d.kingdom is 'Other')
	
	evaluesEukGroup = evaluesEuk.group().reduceCount( (d) -> d.evalue_bin)
	evaluesArcGroup = evaluesArc.group().reduceCount( (d) -> d.evalue_bin)
	evaluesBacGroup = evaluesBac.group().reduceCount( (d) -> d.evalue_bin)
	evaluesOthGroup = evaluesOth.group().reduceCount( (d) -> d.evalue_bin)
	#max_y_value = evaluesEukGroup.size() + evaluesArcGroup.size() + evaluesBacGroup.size() + evaluesOthGroup.size()
	#max_y_value = 30
	## set max y value
	values_array  = []
	for k,v of evaluesGroup.top(30)
		values_array.push v.value

	max_y_value = d3.max(values_array)
	

	console.log "max y value is ".max_y_value

	evaluesChart.width(div_width)
        .height(200)
        .margins({top: 10, right: 50, bottom: 30, left: 40})
        .dimension(evalues)
        .group(evaluesGroup)
        #.stack(evaluesArcGroup)
        #.stack(evaluesBacGroup)
        #	.elasticX(true)
        #.centerBar(false)
       	#.gap(5)
        #.round(dc.round.floor)
        #.alwaysUseRounding(true)
        .y(d3.scale.linear().domain([0,max_y_value]))

        .x(d3.scale.pow().exponent(-.5).domain([0,10]))

        .x(d3.scale.linear().domain([0,max_evalue_bin]))
        #.xAxisLabel('Evalue bins')
        .yAxisLabel('Number of hits')
        .renderlet(colorRenderlet)
        .renderlet( (chart)  -> 
                    chart.selectAll("g.x text")
                      #.attr('dx', '-30')
                      .attr('transform', "rotate(-45)")
                )
        #.renderHorizontalGridLines(false)
    
	#evaluesChart.xAxis().ticks(0)
	#evaluesChart.xAxis().tickValues([1,-70), Math.pow(1, -90),Math.pow(1, -100),0]);


remove_da_entries = (source_group, top_hash) ->
  { all: ->
    source_group.all().filter (d) ->
      d.value of top_hash
 }






build_hits_table  = (data, div) ->
	datatable   = dc.dataTable(div);
	sizeDim = data.dimension((d) ->  d.evalue)
	datatable
	    .dimension(sizeDim)
	    .group((d) ->  "")
   		.columns([
        	#(d) -> "<a href ='/family/"+d.modelName+"' >"+d.modelName+"</a>" ,
        	(d) -> d.species,
        	(d) -> d.evalue,
        	(d) -> d.arch
    	])
    	.size(10)
    	.order(d3.ascending);

colorRenderlet = (_chart) ->
  setStyle = (selection, keyName) ->
    selection.style "fill", (d) ->
      if d[keyName] is "eukaryota"
        "red"
      else if d[keyName] is "archaea"
        "green"
      else "yellow"  if d[keyName] is "bacteria"

    return
  
  # set the fill attribute for the bars
  setStyle _chart.selectAll("g.stack").selectAll("rect.bar"), "layer"
  
  # set the fill attribute for the legend
  setStyle _chart.selectAll("g.dc-legend-item").selectAll("rect"), "name"
  return


