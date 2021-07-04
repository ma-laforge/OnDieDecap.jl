#OnDieDecap.jl: Package to generate plots for on-die decoupling models
#-------------------------------------------------------------------------------

module OnDieDecap

using Colors
import DelimitedFiles: readdlm
using MDDatasets
import CMDimData
using CMDimData.EasyPlot #set, cons
import CMDimCircuits
import InspectDR
CMDimData.@includepkg EasyPlotInspect

const j = im
include("plotbuilders.jl")
include("plots/supplyimpedance.jl")
include("plots/supplybounce.jl")

run_app() = nothing

end # module

#Last line
