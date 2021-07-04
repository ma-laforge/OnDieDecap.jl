#supplybounce.jl: Generate plots of supply bounce
#-------------------------------------------------------------------------------

c2rgba(c::Colorant) = convert(Colors.RGBA{Colors.FixedPointNumbers.N0f8}, c)

#Perform color mix:
function cmix(c1::T, c2::T, w1::Float64) where T <: Colors.RGBA{Colors.FixedPointNumbers.N0f8}
	w2 = 1-w1
	return T(c1.r*w1+c2.r*w2, c1.g*w1+c2.g*w2, c1.b*w1+c2.b*w2, c1.alpha*w1+c2.alpha*w2)
end

cmix(c1::Colorant, c2::Colorant, w1::Float64) =
	cmix(c2rgba(c1), c2rgba(c2), w1)



#==Constants
===============================================================================#
line_sup = cons(:a, line = set(style=:solid, color=:red, width=3))
line_gnd = cons(:a, line = set(style=:solid, color=:blue, width=3))
line_sig = cons(:a, line = set(style=:solid, color=:green, width=3))

line_idealsup = cons(:a, line = set(style=:dash, color=cmix(colorant"red", colorant"white", .5), width=2))
line_idealgnd = cons(:a, line = set(style=:dash, color=cmix(colorant"blue", colorant"white", .5), width=2))


#==
===============================================================================#
function plot_supplybounce(plotname::String="supplybounce";
		datapath=joinpath(@__DIR__, "..", "..", "data", "SupplyTransients.csv")
	)
	data = readdlm(datapath, ',', comments=true)
	#Time, VDD, VSS, VSIG

	t = data[:, 1]
	VDD = DataF1(t, data[:, 2])
	VSS = DataF1(t, data[:, 3])
	Vload = DataF1(t, data[:, 4])
	VDD_diff = VDD-VSS
	simgnd = 0*VDD
	VDD_ideal = simgnd+1

	#NOTE: Using 1.25 to avoid bug displaying 1000e-3V
	plotattr = cons(:a,
		ystrip1 = set(scale=:lin, axislabel=LBLAX_VOLT, min=-0.25, max=1.25),
		ystrip2 = set(scale=:lin, axislabel=LBLAX_VOLT, min=-0.25, max=1.25),
		ystrip3 = set(scale=:lin, axislabel=LBLAX_VOLT, min=-0.25, max=1.25),
#		xaxis = set(max = 10e-9),
	)

	tmid = 10e-9
	midpos = (tmid,0.5)
	siglist=[
		(id="(single Lpkg)", wfrm=VDD_ideal, line=line_idealsup, idpos=midpos, posalign=:cc, strip=2),
		(id="(LVDD=LVSS=Lpkg/2)", wfrm=VDD_ideal, line=line_idealsup, idpos=midpos, posalign=:cc, strip=3),
		(id="", wfrm=simgnd, line=line_idealgnd, idpos=(0,0), posalign=:bl, strip=2),
		(id="", wfrm=simgnd, line=line_idealgnd, idpos=(0,0), posalign=:bl, strip=3),

		(id="Vload", wfrm=Vload, line=line_sig, idpos=midpos, posalign=:cl, strip=1),
		(id="VDD", wfrm=VDD_diff, line=line_sup, idpos=(tmid, 0.9), posalign=:tc, strip=2),
		(id="VDD", wfrm=VDD, line=line_sup, idpos=(tmid,0.95), posalign=:tc, strip=3),
		(id="VSS", wfrm=VSS, line=line_gnd, idpos=(tmid,0.05), posalign=:bc, strip=3),
	]

	data = (
		nstrips = 3,
		plotattr,
		siglist=siglist,
	)

	plot = EasyPlot.build(plot_builders[:tran], data)
	plotgui = display(plotdisplay[:dflt], plot)
	EasyPlot._write(:png, "$plotname.png", optnoleg, plotgui)
	EasyPlot._write(:eps, "$plotname.eps", optnoleg, plotgui)
	return plotgui
end


#last line
