'****************************************
'Author:  
'Date:  
'Description:  SA Fan Speed Control Program
'Flow Type:  Looping
'Triggers:  N/A
'****************************************

Numeric LastError 'Stores last error for later calculation
Numeric PIDMin, PIDMax 'max and min PID limits
Numeric RampFraction
Datetime LastTime 'last time PID was calculated

Initialize: 'initialize PID parameters
  PIDMin = SAF_SPD_L
  PIDMax = 1
  LastError = 0
  LastTime = Date
  Goto PID_Off

PID_Off: 'turn off PID (maintin last position)
  SAF_FBK_HZ = SAF_FBK * 60
  If SAF_RI then SAF_PM = 1 Else SAF_PM = 3
  SAF_R_SP = R_SP + (-1 * (not HC_M) + (HC_M)) * SAF_R_OFS
  SAF_SPD = RMP.fct(SAF_SPD, SAF_PID, SAF_RMP, RampFraction)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_On: 'allow PID to modulate
  SAF_FBK_HZ = SAF_FBK * 60
  If SAF_RI then SAF_PM = 1 Else SAF_PM = 3
  SAF_R_SP = R_SP + (-1 * (not HC_M) + (HC_M)) * SAF_R_OFS
  If Date >= LastTime + SAF_CI then
    SAF_PID = PI.fct(R_T, SAF_R_SP, SAF_PB, SAF_IT, SAF_ST, SAF_CI, SAF_DZ, PIDMax, PIDMin, HC_M, LastError, LastTime, SAF_PID, SAF_PID)
  Endif
  SAF_SPD = RMP.fct(SAF_SPD, SAF_PID, SAF_RMP, RampFraction)
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_Max: 'send PID to maximum position
  SAF_FBK_HZ = SAF_FBK * 60
  If SAF_RI then SAF_PM = 1 Else SAF_PM = 3
  SAF_R_SP = R_SP + (-1 * (not HC_M) + (HC_M)) * SAF_R_OFS
  SAF_PID = PIDMax
  SAF_SPD = RMP.fct(SAF_SPD, SAF_PID, SAF_RMP, RampFraction)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_Min: 'send PID to minimum position
  SAF_FBK_HZ = SAF_FBK * 60
  If SAF_RI then SAF_PM = 1 Else SAF_PM = 3
  SAF_R_SP = R_SP + (-1 * (not HC_M) + (HC_M)) * SAF_R_OFS
  SAF_PID = 0
  SAF_SPD = RMP.fct(SAF_SPD, SAF_PID, SAF_RMP, RampFraction)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

E:
  If TS > 10 then goto Initialize
