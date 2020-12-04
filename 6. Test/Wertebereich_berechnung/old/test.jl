# include("Desktop/GitHub/Master_lokal/6. Test/Wertebereich_berechnung/test.jl")


x_in=10.0
x_out=1.0

while x_out <= x_in     # bei minimum umgekehrtes Vorzeichen!

    print("\n x_out = ",x_out , "\n")   
    global x_out=x_out+1   
    #+= 1

end

