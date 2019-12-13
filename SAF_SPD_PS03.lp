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
Numeric PB 'Proportional Band
Numeric IT 'Integration Time
Numeric ST 'Stroke Time
Numeric CI 'Control Interval
Numeric DZ 'Dead Zone

Initialize: 'initialize PID parameters
  PIDMin = 0
  PIDMax = 1
  LastError = 0
  LastTime = Date

  PB = 10 'psi
  IT = 2 'minutes 
  ST = 60 'seconds
  CI = 2 'seconds
  DZ = 0.1 'psi

  SAF_SPD_PS[1] = 2 'inches w.c.
  SAF_SPD_PS[2] = 1 '100%
  SAF_SPD_PS[3] = 3 'inches w.c.
  SAF_SPD_PS[4] = 0 '0%

  Goto PID_Off

PID_Off: 'turn off PID (maintin last position)
  If SAF_RI is On then SAF_PM = 1 Else SAF_PM = 3
  SAF_SPD_PS = CURVE2.fct(SA_PS, SAF_SPD_PS[1], SAF_SPD_PS[2], SAF_SPD_PS[3], SAF_SPD_PS[4])
  SAF_SPD = RMP.fct(SAF_SPD, minimum(SAF_PID, SAF_SPD_PS), SAF_RMP, RampFraction)
  SAF_SPD = minimum(maximum(SAF_SPD, SAF_SPD_L), SAF_SPD_H)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_On: 'allow PID to modulate
  If SAF_RI is On then SAF_PM = 1 Else SAF_PM = 3
  If Date >= LastTime + CI then
    SAF_PID = PI.fct(SA_PS_FILT, SA_PS_SP, PB, IT, ST, CI, DZ, PIDMax, PIDMin, 0, LastError, LastTime, SAF_PID, SAF_PID, 10)
  Endif
  SAF_SPD_PS = CURVE2.fct(SA_PS, SAF_SPD_PS[1], SAF_SPD_PS[2], SAF_SPD_PS[3], SAF_SPD_PS[4])
  SAF_SPD = RMP.fct(SAF_SPD, minimum(SAF_PID, SAF_SPD_PS), SAF_RMP, RampFraction)
  SAF_SPD = minimum(maximum(SAF_SPD, SAF_SPD_L), SAF_SPD_H)
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_Max: 'send PID to maximum position
  If SAF_RI is On then SAF_PM = 1 Else SAF_PM = 3
  SAF_PID = PIDMax
  SAF_SPD_PS = CURVE2.fct(SA_PS, SAF_SPD_PS[1], SAF_SPD_PS[2], SAF_SPD_PS[3], SAF_SPD_PS[4])
  SAF_SPD = RMP.fct(SAF_SPD, minimum(SAF_PID, SAF_SPD_PS), SAF_RMP, RampFraction)
  SAF_SPD = minimum(maximum(SAF_SPD, SAF_SPD_L), SAF_SPD_H)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

PID_Min: 'send PID to minimum position
  If SAF_RI is On then SAF_PM = 1 Else SAF_PM = 3
  SAF_PID = PIDMin
  SAF_SPD_PS = CURVE2.fct(SA_PS, SAF_SPD_PS[1], SAF_SPD_PS[2], SAF_SPD_PS[3], SAF_SPD_PS[4])
  SAF_SPD = RMP.fct(SAF_SPD, minimum(SAF_PID, SAF_SPD_PS), SAF_RMP, RampFraction)
  SAF_SPD = minimum(maximum(SAF_SPD, SAF_SPD_L), SAF_SPD_H)
  LastError = 0
  LastTime = Date
  Basedon SAF_PM Goto PID_On, PID_Max, PID_Min, PID_Off

E:
  If TS > 10 then goto Initialize
