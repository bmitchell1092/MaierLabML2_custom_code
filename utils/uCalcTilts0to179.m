function new_tilt = uCalcTilts0to179(old_tilt, signed_disparity)

new_tilt = old_tilt + signed_disparity; 
idx180 = new_tilt >= 180;
idx__0 = new_tilt <  0; 

new_tilt(idx180) =  new_tilt(idx180) - 180;
new_tilt(idx__0) =  new_tilt(idx__0) + 180;


  
