# include("Desktop/GitHub/Master_lokal/8. Mehrere Zustandsraumvariablen/reihe/test_max_1.jl")

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

x_in=3.1e-8
x_out=zeros(size(x_in))

n = 1:size(x_in, 1)


u=fill(1.0, 1, 1)
y=fill(1.0, 1, 1)

model = DiscreteModel(circ, 1/fs)   
model.x[1]=x_in
ACME.step!(ModelRunner(model,false),y,u,1)
x_out=model.x[1]

print("\n        Maximum:   ", findmax(x_out), "\n")

