# OnDieDecap.jl: Generate plots to explain on-die decoupling

# Example plots:
```julia
using OnDieDecap

#Impedance profile for 1st-order supply model:
OnDieDecap.plot_1stordersupply("Zsupply_1storder")
OnDieDecap.plot_1stordersupply("Zsupply_1storder_nodamp", Cdamp=0)

#Impedance profile for 1st-order PCB model:
capsPCB = [
	OnDieDecap.PCBCap(1e-6, 800e-12, .1),
	OnDieDecap.PCBCap(100e-9, 700e-12, .01),
	OnDieDecap.PCBCap(10e-9, 550e-12, .01),
]
OnDieDecap.plot_PCBsupply("Zsupply_PCB", caps=capsPCB)

#Supply bounce:
OnDieDecap.plot_supplybounce("supplybounce")
```
