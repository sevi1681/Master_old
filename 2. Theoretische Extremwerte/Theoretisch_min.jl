# include("Desktop/GitHub/Master/2. Theoretische Extremwerte/Theoretisch_min.jl")

using ACME
using Plots

u=[-1.0 for c in 1:1, n in 1:100]         # <-------------------- mit u= -1.0  

x=[0.0 for c in 1:1, n in 1:size(u,2)]
x_next=[0.0 for c in 1:1, n in 1:size(u,2)]
p=[0.0 for c in 1:1, n in 1:size(u,2)]

n = 1:size(u, 2)

circ = @circuit begin
    j_in = voltagesource(), [-] ⟷ gnd
    r1 = resistor(1e3), [1] ⟷ j_in[+]
    c1 = capacitor(47e-9), [1] ⟷ r1[2], [2] ⟷ gnd
    d1 = diode(is=1e-15), [+] ⟷ r1[2], [-] ⟷ gnd
    d2 = diode(is=1.8e-15), [+] ⟷ gnd, [-] ⟷ r1[2]
    j_out = voltageprobe(), [+] ⟷ r1[2], [-] ⟷ gnd
end

fs=44100 
model = DiscreteModel(circ, 1/fs)
y = run!(model, u;showprogress=false)

#----berechne x_next --------------
for n in 1:(size(u,2))
 ACME.step!(ModelRunner(model, false), y, u, n)
 x_next[n]=model.x[1]
end

#----berechne x --------------
for n in 2:(size(u,2))   #fängt mit index 2 an weil x[1]=x0=0
 x[n]= x_next[n-1]
end

#----berechne p --------------
for n in 1:(size(u,2))
  p[n]= (model.dqs[1]*x[n] .+ (model.eqs*u[n])[1])[1]
end
 
#-------------------Max/Min Werte für x(n) aus Gleichstromfall ----------------

x_max = 3.2054470094728434e-8    #  x(4) bei u=const= +1
x_min = -3.114186317932901e-8    #  x(4) bei u=const=


#-------------------Berechnung über linear Solver --------------------------------------------------------

#--- p(n)=  model.dqs * model.x + model.eqs * u[:,n] + model.fqprevs * z -----Formel in ACME------------
#--- p(n)= 88200 * x(n) + 0.001*u(n) -----------------------------------------Werte bei diode clipper---
p_min=(model.dqs[1]*x_min .+ (model.eqs*-1.0)[1])[1]
p_max=(model.dqs[1]*x_max .+ (model.eqs*+1.0)[1])[1]

#-------- verwende den nicht liniaren Löser um z aus p zu berechnen---------------------------------------
z_min=[ACME.solve(model.solvers[1], [p])[1] for p in p_min]
z_max=[ACME.solve(model.solvers[1], [p])[1] for p in p_max]

#--- model.x = model.a * model.x + model.b * u[:,n] + model.c * z + model.x0 -----Formel in ACME------------
#--- x(n+1)= -1*x(n) * 0.94e-8 * z -----------------------------------------------Werte bei diode clipper---
x_theoretisch_min= (model.a*x_max .+ model.c[1]*z_min)[1]
x_theoretisch_max= (model.a*x_min .+ model.c[1]*z_max)[1]    


print("\n x_theoretisch_max = ", x_theoretisch_max, "\t theoretisches Maximum bei u=", u[1], "\n" )
print("\n x_theoretisch_min = ", x_theoretisch_min, "\t theoretisches Minimum bei u=", u[1], "\n" )