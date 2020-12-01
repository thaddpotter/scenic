function signal_inject, sig1, jd, jd0, p, sma, ecc, inc, arg, lpixsize, lstar, rstar, tstar, rplan, tplan, albedo
  
  ;;Fundamental Constants (CGS)
  ;--------------------------------------------------------------------------------
  c = 2.9979d10
  h = 6.62608d-27
  k = 1.38066d-16  
  cm_pc = 3.085678e18
  cm_au = 1.496d10
  
  r_sun = 6.957d10 
  
  
   
  ;;Locate Planet in Space
  ;------------------------------------------------------------------------------
  
  M0 = 2*!const.pi*((jd-jd0) MOD p)/p       ;Mean Anomaly at query time
  E = eccanom(M0, ecc)                 ;eccentric anomaly
  v = 2*atan(sqrt(1+ecc)*sin(E/2), sqrt(1-ecc)*cos(E/2)) ;True anomaly
  
  r = sma*(1-ecc^2)/(1+ecc*cos(v))  ;Find orbital radius at current time
  x0 = [[r*cos(v)],[r*sin(v)],[0]]  ;Convert to cartesian in xyz

  xw = rotate3d(x0, 0, 0, -arg, /Degrees)   ;Rotate about arg
  xf = rotate3d(xw, -inc, 0, 0, /Degrees)   ;Rotate about inc
  
  true_plan_dist = norm(xf)
  proj_plan_dist = norm([xf[0:1],0])
  arg2d = atan(xf[1],xf[0])
  
  ;;Blackbody Fluxes
  ;-------------------------------------------------------------------------------

  ;Star Blackbody Luminosity | Units (erg s^-1 cm^-2 ster^-1 Hz^-1)
  nu = c/l0
  xb=h*nu/(k*tstar)
  bnu=xb^3.0/(exp(xb)-1.0)
  bnu=bnu*2.0*((k*tstar)^3.0)/((c*h)^2.0)
  
  ;Flux Density at planet
  distcm = true_plan_dist * cm_au  ; distance to planet in cm
  fsp = 1e23 * !const.pi * bnu * ((rstar * r_sun / distcm)^2.0)
  
  ;Reflected Luminosity (Need phase angle...)
  fp = albedo * fsp
  
  

  ;Average Planet Distance, Temperature
  ;rbar = sma *(1 + (ecc^2)/2)
  ;tbar = (lstar * (1-albedo)/(16e3 * !const.pi * sigma * true_plan_dist^2))^(1/4)

  ;Planet Blackbody
  nu = c/l0
  xb=h*nu/(k*tplan)
  pnu=xb^3.0/(exp(xb)-1.0)
  pnu=pnu*2.0*((k*tplan)^3.0)/((c*h)^2.0)

 

  

  
  
  
  
  ;;Locate Planet on Image, add brightness
  ;------------------------------------------------------------------------------
  sz = size(sig1)
    
  x_scale = floor(xf / lpixsize) ; Scale distance to pixels, round
    
  sig2 = sig1 ;Copy Brightness Map to other variable
  sig2[sz(1)/2 + 1 + x_scale[0], sz(2)/2 + 1 + x_scale[1]] += plan_flux  ;Add Planet Brightness

  
  return, sig2
  
end