# include("Desktop/GitHub/Master_lokal/6. Test/error/2/test_3.jl")

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

x_in=[0.0 for c in 1:1, n in 1:4]

x_in[1] = 0.0
x_in[2] = 1.8268744897958157e-8
x_in[3] = 2.9424584083759872e-8
x_in[4] = 3.2054470094728434e-8


x_out=zeros(size(x_in))

u=fill(1.0, 1, 1)
y=fill(1.0, 1, 1)

for n in eachindex(x_in)
 model = DiscreteModel(circ, 1/fs)  # sonst falsche ergebnise
  
 p=(model.dqs[1]*x_in[n] .+ (model.eqs*u)[1])[1]      # p(n)
 z=[ACME.solve(model.solvers[1], [p])[1] for p in p]  # berechnen z aus p mit nicht liniaren Löser 
 x_new= (model.a*x_in[n] .+ model.c[1]*z)[1]          # x(n+1)=
 
 print("\n z[",n,"] = ", z[1])

end



