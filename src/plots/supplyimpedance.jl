#supplyimpedance.jl: Generate plots for supply impedance profiles.
#-------------------------------------------------------------------------------


#==Constants
===============================================================================#
const SUBIDX = ['₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']

struct PCBCap
	C::Float64
	ESL::Float64
	ESR::Float64
end


function Ydecap(c::PCBCap, 𝜔)
	return 1/(c.ESR+j*𝜔*c.ESL+1/(j*𝜔*c.C))
end

𝜔SRF(c::PCBCap) = 1/sqrt(c.ESL*c.C)
𝑓SRF(c::PCBCap) = 𝜔SRF(c)/(2π)

function ZSRF(c::PCBCap)
	𝜔 = 𝜔SRF(c)
	return abs(𝜔*c.ESL)
end


#==
===============================================================================#
function plot_1stordersupply(plotname::String="Zsupply_1storder";
		Cdec=10e-9, Lpkg=250e-12, Cdamp=50e-9, Rdamp=0.159
	)
	𝑓min = 10 #Hz
	𝑓max = 10e9 #Hz
	ppdec = 100 #Points per decade
	Ndec = ceil(Int, log10(𝑓max/𝑓min))
	𝑓 = 10 .^ range(log10(𝑓min), stop=log10(𝑓max), length=Ndec*ppdec)
	𝑓 = DataF1(𝑓, 𝑓)
	𝜔 = 2π*𝑓
	YCdec = j*𝜔*Cdec
	ZLpkg = j*𝜔*Lpkg

	Z = 1/(YCdec+1/ZLpkg)
	Zdamp = Rdamp + 1/(j*𝜔*Cdamp)

	constituents=[
		(id="Lpkg", Z=ZLpkg, id𝑓=1e9, align=:br),
		(id="Zdamp", Z=Zdamp, id𝑓=1e5, align=:tr),
		(id="Cdec", Z=1/YCdec, id𝑓=1e6, align=:bl),
	]

	if Cdamp != 0
		Z = 1/(YCdec+1/Zdamp+1/ZLpkg)
	else
		constituents = [constituents[1],constituents[3]]
	end

	data = (
		Z=Z,
		constituents=constituents,
	)

	plot = EasyPlot.build(plot_builders[:Zsupply], data)
	plotgui = display(plotdisplay[:dflt], plot)
	EasyPlot._write(:png, "$plotname.png", optnoleg, plotgui)
	EasyPlot._write(:eps, "$plotname.eps", optnoleg, plotgui)
	return plotgui
end


#==
===============================================================================#
function plot_PCBsupply(plotname::String="Zsupply_PCB";
		LPCB=100e-9, caps::Vector{PCBCap} = [PCBCap(1e-6, 800e-12, .1)]
	)
	𝑓min = 10 #Hz
	𝑓max = 10e9 #Hz
	ppdec = 100 #Points per decade
	Ndec = ceil(Int, log10(𝑓max/𝑓min))
	𝑓 = 10 .^ range(log10(𝑓min), stop=log10(𝑓max), length=Ndec*ppdec)
	𝑓 = DataF1(𝑓, 𝑓)
	𝜔 = 2π*𝑓

	ZLPCB = j*𝜔*LPCB
	YdecA = [Ydecap(c, 𝜔) for c in caps]

	@show [ZSRF(c) for c in caps]
	@show [𝑓SRF(c) for c in caps]

#	Z = 1/YdecA[1]
	Z = 1/(sum(YdecA)+1/ZLPCB)

	constituents=[]
	for (i, Ydec) in enumerate(YdecA)
		id𝑓 = 10^(4+i)
		push!(constituents, (id="C$(SUBIDX[i])", Z=1/Ydec, id𝑓=id𝑓, align=:bl))
	end

	data = (
		Z=Z,
		constituents=constituents,
	)

	plot = EasyPlot.build(plot_builders[:Zsupply], data)
	set(plot.plotlist[1], ystrip1=set(min=0, max=1))
	plotgui = display(plotdisplay[:dflt], plot)
	EasyPlot._write(:png, "$plotname.png", optnoleg, plotgui)
	EasyPlot._write(:eps, "$plotname.eps", optnoleg, plotgui)
	return plotgui
end


#last line
