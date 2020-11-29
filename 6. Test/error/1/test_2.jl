# include("Desktop/GitHub/Master_lokal/6. Test/error/1/test_2.jl")

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

x_in=range(2.0e-8, stop=3.0e-8, length=2)

x_out=zeros(size(x_in))

u=fill(1.0, 1, 1)
y=fill(1.0, 1, 1)

for n in eachindex(x_in)

 #model = DiscreteModel(circ, 1/fs)  # sonst falsche ergebnise für 

 model.x[1]=x_in[n]
 ACME.step!(ModelRunner(model,false),y,u,1)
 x_out[n]=model.x[1]
end

print("\n x_in[2]=", x_in[2], "\n")
print("\n x_out[2]=", x_out[2], "\n")

