# include("Desktop/GitHub/Master_lokal/6. Test/error/1/test_1.jl")

using ACME

circ = @circuit begin
    j_in = voltagesource(), [-] ⟷ gnd
    r1 = resistor(1e3), [1] ⟷ j_in[+]
    c1 = capacitor(47e-9), [1] ⟷ r1[2], [2] ⟷ gnd
    d1 = diode(is=1e-15), [+] ⟷ r1[2], [-] ⟷ gnd
    d2 = diode(is=1.8e-15), [+] ⟷ gnd, [-] ⟷ r1[2]
    j_out = voltageprobe(), [+] ⟷ r1[2], [-] ⟷ gnd
end

fs = 44100
model = DiscreteModel(circ, 1/fs)

x_in=3.0e-8

x_out=zeros(size(x_in))

u=fill(1.0, 1, 1)
y=fill(1.0, 1, 1)

model.x[1]=x_in
ACME.step!(ModelRunner(model,false),y,u,1)
x_out=model.x[1]

print("\n x_out=", x_out, "\n")
