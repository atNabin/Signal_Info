'Description: Room Temperature Setpoint Program
'Flow Type: Looping
'Triggers: none
'This program manages the occupied room heating and cooling setpoints
'Software changes to the setpoints should be made to the base setpoints (RmTmpBsCspt and RmTmpBsHspt)
'Base setpoints are automatically adjusted to enforce high and low limits, and to maintain minimum separation (RmTmpSptDifLlmt)
'Version 1.0

Numeric Input EffOcc, TmpSbSpt, HtgClgMd, RmTmpCsptLlmt, RmTmpHsptHlmt
Numeric Output RmTmpCspt, RmTmpHspt, RmTmpSpt, RmTmpBsCspt, RmTmpBsHspt, RmTmpSptDifLlmt
Numeric Last_RmTmpBsCspt, Last_RmTmpBsHspt
 
Initialize:
If RmTmpSptDifLlmt <= 0 then WriteProperty(RmTmpSptDifLlmt, 2, 16)
Goto Calculating

Calculating:
RmTmpBsCspt = maximum(RmTmpCsptLlmt, RmTmpBsCspt)
RmTmpBsHspt = minimum(RmTmpHsptHlmt, RmTmpBsHspt)
If RmTmpBsCspt - RmTmpBsHspt < RmTmpSptDifLlmt then
  If Last_RmTmpBsCspt <> RmTmpBsCspt then
    RmTmpBsHspt = RmTmpBsCspt - RmTmpSptDifLlmt
  Else
    If Last_RmTmpBsHspt <> RmTmpBsHspt then
      RmTmpBsCspt = RmTmpBsHspt + RmTmpSptDifLlmt
    Else
      If RmTmpBsCspt - RmTmpCsptLlmt < RmTmpHsptHlmt - RmTmpBsHspt then RmTmpBsCspt = RmTmpBsHspt + RmTmpSptDifLlmt Else RmTmpBsHspt = RmTmpBsCspt - RmTmpSptDifLlmt
    Endif
  Endif
Endif
RmTmpHspt = minimum(RmTmpHsptHlmt, RmTmpBsHspt)
RmTmpCspt = maximum(RmTmpCsptLlmt, RmTmpBsCspt)
RmTmpSpt = (HtgClgMd = 0) * RmTmpHspt + (HtgClgMd = 1) * RmTmpCspt
Last_RmTmpBsCspt = RmTmpBsCspt
Last_RmTmpBsHspt = RmTmpBsHspt


E:
If TS > 30 then goto Calculating
