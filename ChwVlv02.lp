'Description: Chilled Water Valve Program
'Flow Type: Looping
'Triggers: none
'This program controls the Chilled Water Valve output based on the cooling load
'Version 1.0

Numeric Input ClgLoad, AH1ASaFanSts, AH1BSaFanSts, FzMd, ChwVlvFzPos, ChwReqSpt, ChwReqDif, UnitEna, ChwCPSts
Numeric Output ChwVlvPos, ChwReq

Numeric SaFanSts, ChwLlSpt, ChwLlDif, ChwHlSpt, ChwHlDif

Initialize:
 ChwLlSpt = 75 'Low Load Setpoint (default=75)
 ChwLlDif = 20 'Low Load Differential (default=20)
 ChwHlSpt = 90 'High Load Setpoint (default=90)
 ChwHlDif = 10 'High Load Differential (default=10)

 If FzMd and not SaFanSts then goto FreezeMode
 Goto NormalMode
 

NormalMode:
 SaFanSts = AH1ASaFanSts or AH1BSaFanSts
 If FzMd and not SaFanSts then goto FreezeMode
 If not ChwCPSts then 
	ChwVlvPos = ClgLoad 
 Else 
	ChwVlvPos = 0
 Endif

 'Note: the below code looks at the input binding for valve position to see forced values too
 If SaFanSts and UnitEna Then
  If ChwVlvPos <= (ChwReqSpt-ChwReqDif/2) Then
   ChwReq = 0
  Else
   If ChwVlvPos <= (ChwLlSpt-ChwLlDif/2) Then
    If ChwVlvPos >= (ChwReqSpt+ChwReqDif/2) Then ChwReq = 1 'Request active
   Else
    If ChwVlvPos <= (ChwHlSpt-ChwHlDif/2) Then
     If ChwVlvPos >= (ChwLlSpt+ChwLlDif/2) Then ChwReq = 2 'Low load active
    Else
     If ChwVlvPos >= (ChwHlSpt+ChwHlDif/2) Then ChwReq = 3 'High load active
    Endif    
   Endif
  Endif
  Else '(either fan status off or UnitEna off)
  ChwReq = 0 'If fan status not active or this unit is not intended to run, then don't request CHW
 Endif


FreezeMode:
 SaFanSts = AH1ASaFanSts or AH1BSaFanSts
 If SaFanSts or not FzMd then goto NormalMode

 ChwVlvPos = ChwVlvFzPos
 Turn Off ChwReq

E:
 If TS > 30 then goto Initialize
