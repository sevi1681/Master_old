# include("Desktop/GitHub/Master_lokal/6. Test/Wertebereich_berechnung/test_max_2.jl")

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


x_in=0.0
x_out=0.0

u_pos=fill(1.0, 1, 1)
u_neg=fill(-1.0, 1, 1)

y=fill(1.0, 1, 1)

while x_out >= x_in     # bei minimum umgekehrtes Vorzeichen!    # oder nur < ?

 global x_in=x_out
 
 # Berechnung von x_out bei u=+1.0  -> x_out_pos
 model = DiscreteModel(circ, 1/fs) 
 model.x[1]=x_in
 ACME.step!(ModelRunner(model,false),y,u_pos,1)
 x_out_pos=model.x[1]
 


 # Berechnung von x_out bei u=-1.0  -> x_out_neg
 model = DiscreteModel(circ, 1/fs)  
 model.x[1]=x_in
 ACME.step!(ModelRunner(model,false),y,u_neg,1)
 x_out_neg=model.x[1]

 global x_out=max(x_out_pos, x_out_neg)
 
 print("\n x_in = ",x_in , "\t", "x_out = ", x_out ,   "\n") 
  
end

#print("\n x_in = ",x_in , "\n") 
#print("\n x_out_pos = ",x_out_pos , "\n") 
#print("\n x_out_neg = ",x_out_neg , "\n") 

#print("\n x_out = ",x_out , "\n")


#plot(x_in, xlabel = "x_in", x_out, ylabel = "x_out",legend=false)  # plot x_in over x_out

