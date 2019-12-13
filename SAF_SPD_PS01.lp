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
  SA_PS_FILT = FILT.fct(SA_PS, SA_PS_TC)
  SAF_SPD_PS = CURVE2.fct(SA_PS, SAF_SPD_PS[1], SAF_SPD_PS[2], SAF_SPD_PS[3], SAF_SPD_PS[4])
  SAF_SPD = minimum(RMP.fct(SAF_SPD, SAF_PID, SAF_RMP, RampFraction), SAF_SPD_PS)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_On: 'allow PID to modulate
  SAF_FBK_HZ = SAF_FBK * 60
  If SAF_RI then SAF_PM = 1 Else SAF_PM = 3
  SA_PS_FILT = FILT.fct(SA_PS, SA_PS_TC)
  If Date >= LastTime + SAF_CI then
    SAF_PID = PI.fct(SA_PS_FILT, SA_PS_SP, SAF_PB, SAF_IT, SAF_ST, SAF_CI, SAF_DZ, PIDMax, PIDMin, 0, LastError, LastTime, SAF_PID, SAF_PID)
  Endif
  SAF_SPD_PS = CURVE2.fct(SA_PS, SAF_SPD_PS[1], SAF_SPD_PS[2], SAF_SPD_PS[3], SAF_SPD_PS[4])
  SAF_SPD = minimum(RMP.fct(SAF_SPD, SAF_PID, SAF_RMP, RampFraction), SAF_SPD_PS)
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_Max: 'send PID to maximum position
  SAF_FBK_HZ = SAF_FBK * 60
  If SAF_RI then SAF_PM = 1 Else SAF_PM = 3
  SAF_PID = PIDMax
  SA_PS_FILT = FILT.fct(SA_PS, SA_PS_TC)
  SAF_SPD_PS = CURVE2.fct(SA_PS, SAF_SPD_PS[1], SAF_SPD_PS[2], SAF_SPD_PS[3], SAF_SPD_PS[4])
  SAF_SPD = minimum(RMP.fct(SAF_SPD, SAF_PID, SAF_RMP, RampFraction), SAF_SPD_PS)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_Min: 'send PID to minimum position
  SAF_FBK_HZ = SAF_FBK * 60
  If SAF_RI then SAF_PM = 1 Else SAF_PM = 3
  SAF_PID = 0
  SA_PS_FILT = FILT.fct(SA_PS, SA_PS_TC)
  SAF_SPD_PS = CURVE2.fct(SA_PS, SAF_SPD_PS[1], SAF_SPD_PS[2], SAF_SPD_PS[3], SAF_SPD_PS[4])
  SAF_SPD = minimum(RMP.fct(SAF_SPD, SAF_PID, SAF_RMP, RampFraction), SAF_SPD_PS)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

E:
  If TS > 10 then goto Initialize
