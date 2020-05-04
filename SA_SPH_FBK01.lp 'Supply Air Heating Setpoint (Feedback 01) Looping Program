'****************************************
'Author:  
'Date:  
'Description:  SA Heating Setpoint Program
'Flow Type:  Looping
'Triggers:  N/A
'****************************************

HeatSetpoint:
  If SA_SPH_OP then
    SA_SPH_FBK = CURVE4.fct(SAF_FBK, SA_SPH_FBK[1], SA_SPH_FBK[2], SA_SPH_FBK[3], SA_SPH_FBK[4], SA_SPH_FBK[5], SA_SPH_FBK[6], SA_SPH_FBK[7], SA_SPH_FBK[8])
    SA_SPH = minimum(SA_SPH_FBK, SA_SPH_H)
    SA_SPH_OP.str = "Auto"
  Else
    SA_SPH = minimum(SA_SPH_MAN, SA_SPH_H)
    SA_SPH_OP.str = "Manual"
  Endif

E:
  If TS > 10 then Goto HeatSetpoint


