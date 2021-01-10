# include("Desktop/GitHub/Master_lokal/8. Mehrere Zustandsraumvariablen/reihe/temp.jl")

using ACME
using Plots


circ = @circuit begin
    j_in = voltagesource(), [-] ⟷ gnd
    c2 = capacitor(47e-9), [1] ⟷ j_in[+]    # neue Kapazität 
    r1 = resistor(1e3), [1] ⟷ c2[2]
    c1 = capacitor(47e-9), [1] ⟷ r1[2], [2] ⟷ gnd     
    d1 = diode(is=1e-15), [+] ⟷ r1[2], [-] ⟷ gnd
    d2 = diode(is=1.8e-15), [+] ⟷ gnd, [-] ⟷ r1[2]
    j_out = voltageprobe(), [+] ⟷ r1[2], [-] ⟷ gnd
end

fs = 44100
model = DiscreteModel(circ, 1/fs)  # sonst falsche ergebnise für 



print("\n        size(model.x) =   ", size(model.x), "\n")

print("\n        model.x[1] =   ", model.x[1], "\n")
print("\n        model.x[2] =   ", model.x[2], "\n")

