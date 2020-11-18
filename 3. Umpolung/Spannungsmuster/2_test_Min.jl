# include("Desktop/GitHub/Master/3. Umpolung/Spannungsmuster/2_test_Min.jl")

using ACME

# berechnung für mehrere Werte von c in einer for schleife

for c=10:1:17   # c ist der Faktor für den Muster: size_u=(5+4*c+1)

  #----------------------------definiere vector u nach dem gewünschtem muster--------------
  size_u=(5+4*c+1)

  u=ones(1,size_u)*1       # damit u[1]=1.0

  for n=2:size_u-4 
  u[n+4]=-1.0*u[n]
  end
  u[size_u]=u[size_u-1]

  #-----------------------------------------------------------------------------------
  

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
  #--- berechne x_next --------------
  for n in 1:(size(u,2))
    ACME.step!(ModelRunner(model, false), y, u, n)
    x_next[n]=model.x[1]
  end
  
  #--- berechne x --------------
  for n in 2:(size(u,2))   #fängt mit index 2 an weil x[1]=x0=0
   x[n]= x_next[n-1]
  end
  
  
  print(" \n bei u(1)=",u[1], "\t bei c= ", c, "\t", "x(", argmin(x)[2] , ")= ", minimum(x), " der Minimum \n ") 

end