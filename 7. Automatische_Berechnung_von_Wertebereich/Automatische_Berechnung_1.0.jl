# include("Desktop/GitHub/Master_lokal/7. Automatische_Berechnung_von_Wertebereich/Automatische_Berechnung_1.0.jl")

using ACME

#-----Schaltung-------------------------------------------------
circ = @circuit begin
    j_in = voltagesource(), [-] ⟷ gnd
    r1 = resistor(1e3), [1] ⟷ j_in[+]
    c1 = capacitor(47e-9), [1] ⟷ r1[2], [2] ⟷ gnd
    d1 = diode(is=1e-15), [+] ⟷ r1[2], [-] ⟷ gnd
    d2 = diode(is=1.8e-15), [+] ⟷ gnd, [-] ⟷ r1[2]
    j_out = voltageprobe(), [+] ⟷ r1[2], [-] ⟷ gnd
end
#------------------------------------------------------

global Length_test = 1000                               # exacte Werte bei: 1000                  
global Accuraracy_test = 1.0e-30                      # exacte Werte bei: 1.0e-30 

print("\n", "Length_test = ", Length_test, "\n")
print("\n", "Accuraracy_test = ", Accuraracy_test, "\n\n")

# -------------------------------------- calculation_1 ---------------------------------------------------------
include("funktion_calculation_1.jl")
global x_in_max_temp,   x_out_max_temp,  x_in_min_temp,  x_out_min_temp = calculation_1()

# -------------------------------------- calculation_2 ---------------------------------------------------------
include("funktion_calculation_2.jl")

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


schleife=1

while schleife==1

    

    global x_in_max_new,   x_out_max_new,   x_in_min_new,   x_out_min_new = calculation_2(x_out_min_old, x_out_max_old )

    


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
    
    

end

print("\n ----------------------------------- Endergebnis --------------------------------- \n")


# max
print("\n", "x_in_max = ", x_in_max_final, "\n")
print("\n", "x_out_max = ",x_out_max_final, "\n \n")
# min
print("\n", "x_in_min = ", x_in_min_final, "\n")
print("\n", "x_out_min = ",x_out_min_final, "\n \n")





