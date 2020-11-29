# include("Desktop/GitHub/Master_lokal/6. Test/error/2/test_3_Gleichstrom.jl")

using ACME


u=[ 1.0 for c in 1:1, n in 1:4 ]

x=[0.0 for c in 1:1, n in 1:size(u,2)]
y=[0.0 for c in 1:1, n in 1:size(u,2)]
x_next=[0.0 for c in 1:1, n in 1:size(u,2)]

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


#----berechne x_next --------------
for n in 1:(size(u,2))
ACME.step!(ModelRunner(model, false), y, u, n)
x_next[n]=model.x[1]
end

#----berechne x --------------
for n in 2:(size(u,2))   #fängt mit index 2 an weil x[1]=x0=0
 x[n]= x_next[n-1]
end

for n in 1:(size(u,2))
 p=(model.dqs[1]*x[n] .+ (model.eqs*u[n])[1])[1]      # p(n)
 z=[ACME.solve(model.solvers[1], [p])[1] for p in p]  # berechnen z aus p mit nicht liniaren Löser 
 x_new=(model.a*x[n] .+ model.c[1]*z)[1]              # x_new = x(n+1)=

 print("\n z[",n,"] = ", z[1])

end