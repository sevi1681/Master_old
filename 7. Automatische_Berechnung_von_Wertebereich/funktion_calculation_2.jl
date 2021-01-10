
function calculation_2(x_out_min_temp, x_out_max_temp )

#-------------------------------------------------------------------------------------------------------   
#--------------------------------------------MAX Calculation--------------------------------------------   
#-------------------------------------------------------------------------------------------------------
   
fs = 44100

#global Length_test = 100                               # Length von x_in_range vector
#global Accuraracy_test = 1.0e-30                                   #  Genauigkeit bei step_3

global x_in_max = 0.0
global x_in_min = 0.0

global x_out_max = 0.0
global x_out_min = 0.0

global x_in_result_max = 0.0
#global x_in_result_min = 0.0

global x_out_result_max = 0.0
#global x_out_result_min = 0.0

global index = 0

global u_pos=fill(1.0, 1, 1)
global u_neg=fill(-1.0, 1, 1)
global y=fill(1.0, 1, 1)

#---------------------------------step 2---------------------------------
# setze x_in als range von x_in_min bis x_in_max Wert für x_in bei step 1   





global x_in_range=range(x_out_min_temp, stop=x_out_max_temp, length=Length_test)
global x_out_range_pos=zeros(size(x_in_range))
global x_out_range_neg=zeros(size(x_in_range))



for n in eachindex(x_in_range)
    model = DiscreteModel(circ, 1/fs) 
    model.x[1]=x_in_range[n]
    ACME.step!(ModelRunner(model,false),y,u_pos,1)
    global x_out_range_pos[n]=model.x[1]
         
    model = DiscreteModel(circ, 1/fs)  
    model.x[1]=x_in_range[n]
    ACME.step!(ModelRunner(model,false),y,u_neg,1)
    global x_out_range_neg[n]=model.x[1]

end # end for


if maximum(x_out_range_pos) > maximum(x_out_range_neg)              # Für Max/Min Berechnung: >/< und maximum/minimum 

    global x_out_result_max = findmax(x_out_range_pos)[1]               # Für Max/Min Berechnung:  findemax/findemin  
    global index=findmax(x_out_range_pos)[2]                        # Für Max/Min Berechnung:  findemax/findemin
    global x_in_result_max = x_in_range[ index  ] 
    
else  
    global x_out_result_max = findmax(x_out_range_neg)[1]               # Für Max/Min Berechnung: findemax/findemin
    global index=findmax(x_out_range_neg)[2]                        # Für Max/Min Berechnung: findemax/findemin
    global x_in_result_max=  x_in_range[ index   ] 
end



#-------------step 3----------------------------------------------


while ( abs( x_in_range[1] - x_in_range[2] ) > Accuraracy_test)

    
    
    if index==1
        global x_in_range=range(x_in_range[index], stop=x_in_range[index+1], length=Length_test)
        
    elseif index==Length_test
        global x_in_range=range(x_in_range[index-1], stop=x_in_range[Length_test], length=Length_test)
        
    else
        global x_in_range=range(x_in_range[index-1], stop=x_in_range[index+1], length=Length_test)
        
    end

    
    
    global x_out_range_pos=zeros(size(x_in_range))
    global x_out_range_neg=zeros(size(x_in_range))
    
    
 
    for n in eachindex(x_in_range)
        
       
        
        model = DiscreteModel(circ, 1/fs) 
        model.x[1]=x_in_range[n]
        ACME.step!(ModelRunner(model,false),y,u_pos,1)
        global x_out_range_pos[n]=model.x[1]
            
        model = DiscreteModel(circ, 1/fs)  
        model.x[1]=x_in_range[n]
        ACME.step!(ModelRunner(model,false),y,u_neg,1)
        global x_out_range_neg[n]=model.x[1]
        
    end # end for

    if maximum(x_out_range_pos) > maximum(x_out_range_neg)              # Für Max/Min Berechnung: >/<  und maximum/minimum

        global x_out_result_max = findmax(x_out_range_pos)[1]               # Für Max/Min Berechnung: findmax/findmin
        global index=findmax(x_out_range_pos)[2]                        # Für Max/Min Berechnung: findmax/findmin
        global x_in_result_max=  x_in_range[ index  ] 
        
    else  
        global x_out_result_max = findmax(x_out_range_neg)[1]               # Für Max/Min Berechnung: findmax/findmin
        global index=findmax(x_out_range_neg)[2]                        # Für Max/Min Berechnung: findmax/findmin
        global x_in_result_max=  x_in_range[ index   ] 
    end # end if 
    
    

end  # end while

#-------------------------------------------------------------------------------------------------------   
#--------------------------------------------MIN Calculation--------------------------------------------   
#-------------------------------------------------------------------------------------------------------



   
fs = 44100

#global Length_test = 100                                          # Length von x_in_range vector
#global Accuraracy_test = 1.0e-30                                   #  Genauigkeit bei step_3

global x_in_max=0.0
global x_in_min=0.0

global x_out_max=0.0
global x_out_min=0.0




#global x_in_result_max = 0.0
global x_in_result_min = 0.0

#global x_out_result_max = 0.0
global x_out_result_min = 0.0

global index = 0

global u_pos=fill(1.0, 1, 1)
global u_neg=fill(-1.0, 1, 1)
global y=fill(1.0, 1, 1)

#---------------------------------step 2---------------------------------
# setze x_in als range von 0 bis maximalen Wert für x:in bei step 1   


global x_in_range=range(x_out_min_temp, stop=x_out_max_temp, length=Length_test)
global x_out_range_pos=zeros(size(x_in_range))
global x_out_range_neg=zeros(size(x_in_range))




for n in eachindex(x_in_range)
    model = DiscreteModel(circ, 1/fs) 
    model.x[1]=x_in_range[n]
    ACME.step!(ModelRunner(model,false),y,u_pos,1)
    global x_out_range_pos[n]=model.x[1]
         
    model = DiscreteModel(circ, 1/fs)  
    model.x[1]=x_in_range[n]
    ACME.step!(ModelRunner(model,false),y,u_neg,1)
    global x_out_range_neg[n]=model.x[1]

end # end for


if minimum(x_out_range_pos) < minimum(x_out_range_neg)              # Für Max/Min Berechnung: >/< und maximum/minimum 

    global x_out_result_min = findmin(x_out_range_pos)[1]               # Für Max/Min Berechnung:  findemax/findemin  
    global index=findmin(x_out_range_pos)[2]                        # Für Max/Min Berechnung:  findemax/findemin
    global x_in_result_min=  x_in_range[ index  ] 
    
else  
    global x_out_result_min = findmin(x_out_range_neg)[1]               # Für Max/Min Berechnung: findemax/findemin
    global index=findmin(x_out_range_neg)[2]                        # Für Max/Min Berechnung: findemax/findemin
    global x_in_result_min=  x_in_range[ index   ] 
end




#-------------step 3----------------------------------------------
 



while ( abs( x_in_range[1] - x_in_range[2] ) > Accuraracy_test)

    
    
    if index==1
        global x_in_range=range(x_in_range[index], stop=x_in_range[index+1], length=Length_test)
        
    elseif index==Length_test
        global x_in_range=range(x_in_range[index-1], stop=x_in_range[Length_test], length=Length_test)
        
    else
        global x_in_range=range(x_in_range[index-1], stop=x_in_range[index+1], length=Length_test)
        
    end

    global x_out_range_pos=zeros(size(x_in_range))
    global x_out_range_neg=zeros(size(x_in_range))
    
    
 
    for n in eachindex(x_in_range)
        
    
        model = DiscreteModel(circ, 1/fs) 
        model.x[1]=x_in_range[n]
        ACME.step!(ModelRunner(model,false),y,u_pos,1)
        global x_out_range_pos[n]=model.x[1]
            
        model = DiscreteModel(circ, 1/fs)  
        model.x[1]=x_in_range[n]
        ACME.step!(ModelRunner(model,false),y,u_neg,1)
        global x_out_range_neg[n]=model.x[1]
        
    end # end for

    if minimum(x_out_range_pos) < minimum(x_out_range_neg)              # Für Max/Min Berechnung: >/<  und maximum/minimum

        global x_out_result_min = findmin(x_out_range_pos)[1]               # Für Max/Min Berechnung: findmax/findmin
        global index=findmin(x_out_range_pos)[2]                        # Für Max/Min Berechnung: findmax/findmin
        global _min=  x_in_range[ index  ] 
        
    else  
        global x_out_result_min = findmin(x_out_range_neg)[1]               # Für Max/Min Berechnung: findmax/findmin
        global index=findmin(x_out_range_neg)[2]                        # Für Max/Min Berechnung: findmax/findmin
        global x_in_result_min=  x_in_range[ index   ] 
    end # end if 
    
   

end  # end while



return x_in_result_max, x_out_result_max, x_in_result_min, x_out_result_min

end