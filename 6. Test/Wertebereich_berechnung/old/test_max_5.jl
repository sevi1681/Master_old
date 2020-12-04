# include("Desktop/GitHub/Master_lokal/6. Test/Wertebereich_berechnung/test_max_5.jl")

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


x_in = 0.0
x_out = 0.0
x_in_prev = 0.0

x_in_result = 0.0
x_out_result = 0.0


u_pos=fill(1.0, 1, 1)
u_neg=fill(-1.0, 1, 1)

y=fill(1.0, 1, 1)


L_test=10
print("\n length: L_test = ",L_test,   "\n \n") 

while x_out >= x_in     # bei minimum umgekehrtes Vorzeichen!    # oder nur < ?

 
  global x_in_prev = x_in
 
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


 global x_in_range=range(0.0, stop=x_in, length=L_test)
 x_out_range_pos=zeros(size(x_in_range))
 x_out_range_neg=zeros(size(x_in_range))
 
 print("\n  x_in in Range : von ",x_in , "\t", " bis ", x_out ,   "\n")

 for n in eachindex(x_in_range)
     model = DiscreteModel(circ, 1/fs) 
     model.x[1]=x_in_range[n]
     ACME.step!(ModelRunner(model,false),y,u_pos,1)
     x_out_range_pos[n]=model.x[1]
          
     model = DiscreteModel(circ, 1/fs)  
     model.x[1]=x_in_range[n]
     ACME.step!(ModelRunner(model,false),y,u_neg,1)
     x_out_range_neg[n]=model.x[1]
     
     print("\n  x_in[",n,"] = ",x_in_range[n] , "\t", " x_out[",n,"] = ", x_out_range_pos[n] ,   "\n")
     
     if n%100==0
      #print("\n", n ,"\n")
     end # if
     
    
    end # end for
   
   
   

  global x_out=max(findmax(x_out_range_pos)[1], findmax(x_out_range_neg)[1]) 

  
 if x_out > x_out_result  # bei minimum umgekehrtes Vorzeichen!
  global x_out_result=x_out
  global x_in_result=x_in
 end
 

 
 

end # while


print("\n Result  Maximum:    x_in = ",x_in_result , "\t", "x_out = ", x_out_result ,   "\n", "\n") 



