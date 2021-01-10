# include("Desktop/GitHub/Master_lokal/8. Mehrere Zustandsraumvariablen/test_parallel_mit Zwischenwerten/Automatische_Berechnung_2.0.jl")

using ACME

#-----Schaltung-------------------------------------------------
circ = @circuit begin
  j_in = voltagesource(), [-] ⟷ gnd
  c2 = capacitor(47e-9), [1] ⟷ j_in[+]    # neue Kapazität 
  r1 = resistor(1e3), [1] ⟷ c2[2]
  c1 = capacitor(47e-9), [1] ⟷ r1[2], [2] ⟷ gnd     
  d1 = diode(is=1e-15), [+] ⟷ r1[2], [-] ⟷ gnd
  d2 = diode(is=1.8e-15), [+] ⟷ gnd, [-] ⟷ r1[2]
  j_out = voltageprobe(), [+] ⟷ r1[2], [-] ⟷ gnd
end
#------------------------------------------------------

global Length_test = 100                               # exacte Werte bei: 1000                  
global Accuraracy_test = 1.0e-20                      # exacte Werte bei: 1.0e-30 

print("\n", "Length_test = ", Length_test, "\n")
print("\n", "Accuraracy_test = ", Accuraracy_test, "\n\n")

# -------------------------------------- calculation_1 ---------------------------------------------------------
include("funktion_calculation_1.jl")
print("\n ----------------------------------- calculation_1 --------------------------------- \n")
global x_in_max_temp,   x_out_max_temp,  x_in_min_temp,  x_out_min_temp = calculation_1()


# max_temp
print("\n", "x_in_max_temp = ", x_in_max_temp, "\n")
print("\n", "x_out_max_temp = ",x_out_max_temp, "\n \n")
# min_temp
print("\n", "x_in_min_temp = ", x_in_min_temp, "\n")
print("\n", "x_out_min_temp = ",x_out_min_temp, "\n \n")

# -------------------------------------- calculation_2 ---------------------------------------------------------
include("funktion_calculation_2.jl")
print("\n ----------------------------------- calculation_2 --------------------------------- \n")


global x_in_max_old = x_in_max_temp
global x_in_min_old = x_in_min_temp

global x_out_max_old = x_out_max_temp 
global x_out_min_old = x_out_min_temp

global x_in_max_new = 0.0 
global x_in_min_new = 0.0

global x_out_max_new = 0.0 
global x_out_min_new = 0.0

global x_in_max_final = 0.0 
global x_in_min_final = 0.0
global x_out_max_final = 0.0 
global x_out_min_final = 0.0


n=1

schleife=1

while schleife==1

    print("\n ------------ schleife Nr.",n," ------------------- \n")

    global x_in_max_new,   x_out_max_new,   x_in_min_new,   x_out_min_new = calculation_2(x_out_min_old, x_out_max_old )

    print("\n", "x_out_max_new = ",x_out_max_new, "\n \n") 
    print("\n", "x_out_min_new = ",x_out_min_new, "\n \n")


    if ((max(x_out_max_old, x_out_max_new)==x_out_max_old) && (min(x_out_min_old, x_out_min_new)==x_out_min_old))
        global schleife=0  # Abbruchkriterium für while schleife
        global x_in_max_final  = x_in_max_old 
        global x_in_min_final  = x_in_min_old
        global x_out_max_final = x_out_max_old
        global x_out_min_final = x_out_min_old
    end 

    global x_in_max_old=x_in_max_new 
    global x_in_min_old=x_in_min_new 
        
    global x_out_max_old=x_out_max_new 
    global x_out_min_old=x_out_min_new      
    
    global n=n+1 

end

print("\n ----------------------------------- Endergebnis --------------------------------- \n")


# max
print("\n", "x_in_max = ", x_in_max_final, "\n")
print("\n", "x_out_max = ",x_out_max_final, "\n \n")
# min
print("\n", "x_in_min = ", x_in_min_final, "\n")
print("\n", "x_out_min = ",x_out_min_final, "\n \n")





