'****************************************
'Author:  
'Date:  
'Description:  Supply Air Setpoint Program
'Flow Type:  Looping
'Triggers:  N/A
'****************************************

SetpointCalc:
  SA_SP = (HC_M) * SA_SPC + (not HC_M) * SA_SPH

E:
  If TS > 10 then goto SetpointCalc
