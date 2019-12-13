'****************************************
'Author:  
'Date:  
'Description:  SA Cooling Setpoint Program
'Flow Type:  Looping
'Triggers:  N/A
'****************************************

CoolSetpoint:
  If SA_SPC_OP then
    SA_SPC_FBK = CURVE4.fct(SAF_FBK, SA_SPC_FBK[1], SA_SPC_FBK[2], SA_SPC_FBK[3], SA_SPC_FBK[4], SA_SPC_FBK[5], SA_SPC_FBK[6], SA_SPC_FBK[7], SA_SPC_FBK[8])
    SA_SPC = maximum(SA_SPC_FBK, SA_SPC_L)
    SA_SPC_OP.str = "Auto"
  Else
    SA_SPC = maximum(SA_SPC_MAN, SA_SPC_L)
    SA_SPC_OP.str = "Manual"
  Endif

E:
  If TS > 10 then Goto CoolSetpoint


