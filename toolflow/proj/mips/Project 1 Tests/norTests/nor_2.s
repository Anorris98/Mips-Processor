.data
.text


lui   $t0, 0xFFFF     
ori   $t0, $t0, 0xFFFF     
addi   $t1, $t1, 1
nor   $t2, $t0, $t1    
#Trying to test noring the highets value with the lowest value (except for all 0s)
#This is making sure noring high and low valuesS work!
#t2 should be all 0s

halt
