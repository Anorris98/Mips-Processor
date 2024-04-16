.data
.text

lui   $t0, 0xFFFF     
ori   $t0, $t0, 0xFFFF 
lui   $t1, 0xFFFF     
ori   $t1, $t1, 0xFFFF 
nor   $t2, $t0, $t1    
#trying the max value a register can take and noring them together. Should be 0x00000000
#this tests the highest value, an edge case. 

halt
