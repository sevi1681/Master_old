# include("Desktop/GitHub/Master_lokal/6. Test/Wertebereich_berechnung/test_max_proof.jl")

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

#x_in = 2.614334051120927e-8  # Accuraracy_test = 1.0e-20 
x_in = 2.614334051120931e-8  # Accuraracy_test = 1.0e-22 

x_out=zeros(size(x_in))



u=fill(1.0, 1, 1)
y=fill(1.0, 1, 1)


model = DiscreteModel(circ, 1/fs)   
model.x[1]=x_in
ACME.step!(ModelRunner(model,false),y,u,1)
x_out=model.x[1]



print("\n        Maximum:   ", x_out, "\n")


