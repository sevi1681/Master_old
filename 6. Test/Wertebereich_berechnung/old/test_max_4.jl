# include("Desktop/GitHub/Master_lokal/6. Test/Wertebereich_berechnung/test_max_4.jl")

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

x_prev=0.0


u_pos=fill(1.0, 1, 1)
u_neg=fill(-1.0, 1, 1)

y=fill(1.0, 1, 1)


L_test=10000
print("\n length: L_test = ",L_test,   "\n \n") 

while x_out >= x_in     # bei minimum umgekehrtes Vorzeichen!    # oder nur < ?

 
  x_in_prev = x_in
 
 
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

 global x_out=max(x_out_pos, x_out_neg)    # oder minimal für min
 
 
  
 #--------------------------------------------------------------------------


 global x_in_range=range(x_in, stop=x_out, length=L_test)
 x_out_range_pos=zeros(size(x_in_range))
 #x_out_range_neg=zeros(size(x_in_range))
 
 #print("\n  x_in_range : von ",x_in , "\t", " bis ", x_out ,   "\n")

 for n in eachindex(x_in_range)
     model = DiscreteModel(circ, 1/fs) 
     model.x[1]=x_in_range[n]
     ACME.step!(ModelRunner(model,false),y,u_pos,1)
     x_out_range_pos[n]=model.x[1]
     

     if n%100==0
      print("\n", n ,"\n")
     end # if
     
     #model = DiscreteModel(circ, 1/fs)  
     #model.x[1]=x_in_range[n]
     #ACME.step!(ModelRunner(model,false),y,u_neg,1)
     #x_out_range_neg[n]=model.x[1]
     #global x_out=max(x_out_range_pos, x_out_range_neg) 
    end # end for

  global x_out=findmax(x_out_range_pos)[1]

 print("\n after Range: x_in = ",x_in , "\t", "x_out = ", x_out ,   "\n", "\n") 

end # while





#print("\n x_in = ",x_in , "\n") 
#print("\n x_out_pos = ",x_out_pos , "\n") 
#print("\n x_out_neg = ",x_out_neg , "\n") 

#print("\n x_out = ",x_out , "\n")


#plot(x_in, xlabel = "x_in", x_out, ylabel = "x_out",legend=false)  # plot x_in over x_out

