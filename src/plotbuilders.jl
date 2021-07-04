#plotbuilders.jl: Defines/loads template for building plots
#-------------------------------------------------------------------------------


#==Constants
===============================================================================#
LBLAX_AMPV = "Amplitude [V]"
LBLAX_FREQ = "Frequency [Hz]"
LBLAX_ZVA = "Impedance [V/A]"
LBLAX_MAGZVA = "|Impedance| [V/A]"
LBLAX_POTENTIAL = "Potential [V]"
LBLAX_VOLT = "Voltage [V]"
LBLAX_CURmA = "Current [mA]"
LBLAX_TIME = "Time [s]"

wtrace = 3
line_p1 = cons(:a, line = set(style=:solid, color=:black, width=wtrace))
line_p2 = cons(:a, line = set(style=:dash, color=colorant"red", width=wtrace))
line_Z = cons(:a, line = set(style=:solid, color=:blue, width=wtrace))
line_gnd = cons(:a, line = set(style=:solid, color=colorant"green", width=wtrace))

#Show options
#optleg = EasyPlot.ShowOptions(dim=set(w=350, h=160))
#optnoleg = EasyPlot.ShowOptions(dim=set(w=270, h=160))
optnoleg = EasyPlot.ShowOptions(dim=set(w=480, h=300))

#Plot builder objects:
const plot_builders = Dict{Symbol, EasyPlot.EasyPlotBuilder}()
include("plotbuilders/supplyimpedance.jl")
include("plotbuilders/transientplot.jl")


#==Postproc functions
===============================================================================#
function adjust_inspectdr(gtkplot, tgtmajor)
	DFLTGRID = InspectDR.GridRect(vmajor=true, vminor=true, hmajor=false, hminor=false)
	mplot = gtkplot.src
	mplot.layout[:valloc_title] = 0 #Assume not Multiplot title
	for sp in mplot.subplots
#		sp.layout[:valloc_data] = 300; sp.layout[:halloc_data] = 480
#		sp.layout[:valloc_data] = 150; sp.layout[:halloc_data] = 240
#		sp.layout[:valloc_data] = 100; sp.layout[:halloc_data] = 150
#		sp.layout[:valloc_data] = 150; sp.layout[:halloc_data] = 200
#		sp.layout[:halloc_legend] = WIDTH_LEGEND
		for stripi in sp.strips
			stripi.grid = DFLTGRID
			scale = isa(stripi.yscale, InspectDR.LogScale) ? :log : :lin
			stripi.yscale = InspectDR.AxisScale(scale, tgtmajor=tgtmajor, tgtminor=1)
		end
	end
end

const plotdisplay = Dict{Symbol, EasyPlot.GUIDisplay}(
	:dflt => EasyPlot.GUIDisplay(:InspectDR, postproc=(gtkplot)->adjust_inspectdr(gtkplot, 4)),
	:finey => EasyPlot.GUIDisplay(:InspectDR, postproc=(gtkplot)->adjust_inspectdr(gtkplot, 6)),
)

#Last line
