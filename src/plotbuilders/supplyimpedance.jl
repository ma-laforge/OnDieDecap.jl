#supplyimpedance.jl: Template for plotting impedance profiles
#-------------------------------------------------------------------------------


#==Constants
===============================================================================#

#glyph=set(shape=:circle)
line_Zconst = [#Constituents
	cons(:a, line = set(style=:dash, color=colorant"grey20", width=2)),
	cons(:a, line = set(style=:dashdot, color=colorant"grey20", width=2)),
	cons(:a, line = set(style=:dot, color=colorant"grey20", width=2)),
]
line_Ztot = cons(:a, line = set(style=:solid, color=:blue, width=4))


#==
===============================================================================#
function fnbuild_zsupply(data)
	_title = "Supply Impedance"
	plot = cons(:plot, nstrips=2, title=_title, legend=false,
		ystrip1 = set(scale=:lin, axislabel=LBLAX_MAGZVA, min=0, max=.5),
		ystrip2 = set(scale=:log, axislabel=LBLAX_MAGZVA, min=1e-3, max=1e3),
		xaxis = set(scale=:log, label=LBLAX_FREQ, min=1e3, max=10e9),
	)

	for (i, elem) in enumerate(data[:constituents])
		magZ = abs(elem.Z)
		line = line_Zconst[i]
		idy = value(magZ, x=elem.id𝑓)
		push!(plot,
			cons(:wfrm, magZ, line_Zconst[i], label="", strip=2),
			cons(:atext, elem.id, x=elem.id𝑓, y=idy, align=elem.align, strip=2),
		)
	end

	Z = data[:Z]
	magZ = abs(Z)
	push!(plot,
		cons(:wfrm, magZ, line_Ztot, label="", strip=1),
		cons(:wfrm, magZ, line_Ztot, label="", strip=2),
	)

	pcoll = push!(cons(:plotcoll, title=""), plot)
	return pcoll
end


#==Register plot builder
===============================================================================#
push!(plot_builders, :Zsupply => EasyPlot.EasyPlotBuilder(fnbuild_zsupply))

#Last line
