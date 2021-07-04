#transientplot.jl: Template for transient plots
#-------------------------------------------------------------------------------

#==
===============================================================================#
function fnbuild_transient(data)
	_title = "Transient Response"
	plot = cons(:plot, nstrips=data.nstrips, title=_title, legend=false,
		xaxis = set(scale=:lin, label=LBLAX_TIME),
	)
	set(plot, data.plotattr)

	for (i, sig) in enumerate(data[:siglist])
		(x,y) = sig.idpos
		push!(plot,
			cons(:wfrm, sig.wfrm, sig.line, label="", strip=sig.strip),
			cons(:atext, sig.id, x=x, y=y, align=sig.posalign, strip=sig.strip),
		)
	end

	pcoll = push!(cons(:plotcoll, title=""), plot)
	return pcoll
end


#==Register plot builder
===============================================================================#
push!(plot_builders, :tran => EasyPlot.EasyPlotBuilder(fnbuild_transient))

#Last line

