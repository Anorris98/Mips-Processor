.data
.text

nor $t2, $t0, $t1
#nor two values that have all 0s, t2 should have all 1s or 0xFFFFFFFF. Agian this is testing an edge case of the lowest values

halt
