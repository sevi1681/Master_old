# include("Desktop/GitHub/Master_lokal/6. Test/u=-1/test_min_range_1.jl")

using ACME
using Plots


circ = @circuit begin
    j_in = voltagesource(), [-] ⟷ gnd
    r1 = resistor(1e3), [1] ⟷ j_in[+]
    c1 = capacitor(47e-9), [1] ⟷ r1[2], [2] ⟷ gnd
    d1 = diode(is=1e-15), [+] ⟷ r1[2], [-] ⟷ gnd
    d2 = diode(is=1.8e-15), [+] ⟷ gnd, [-] ⟷ r1[2]
    j_out = voltageprobe(), [+] ⟷ r1[2], [-] ⟷ gnd
end

fs = 44100

x_in=range(-2.5290429042904288e-8, stop=-2.5277227722772276e-8, length=10000)


x_out=zeros(size(x_in))

n = 1:size(x_in, 1)


u=fill(-1.0, 1, 1)
y=fill(1.0, 1, 1)

for n in eachindex(x_in)
    model = DiscreteModel(circ, 1/fs)  # sonst falsche ergebnise für 
    model.x[1]=x_in[n]
    ACME.step!(ModelRunner(model,false),y,u,1)
    x_out[n]=model.x[1]
end
   

print("\n        Minimum:   ", findmin(x_out), "\n")

#plot(x_in, xlabel = "x_in", x_out, ylabel = "x_out",legend=false)  # plot x_in over x_out

