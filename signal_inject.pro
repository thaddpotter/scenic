pro signal_inject
  
  ;;Load Scene Generation Parameters
  ;;Need to Specify PATH?
  
  scene = load_scene_params()
  
  ;;Load in Input Matrix, Use fake for now
  ;-------------------------------------------------------------------------------
  
  pixnum = scene.pixnum
  init = make_array(pixnum, pixnum, /DOUBLE, value = 0)
  
  flux = 1.0D
  
  init[pixnum/2-1,pixnum/2-1] = init[pixnum/2-1,pixnum/2-1] + flux/4
  init[pixnum/2+1,pixnum/2-1] = init[pixnum/2+1,pixnum/2-1] + flux/4
  init[pixnum/2-1,pixnum/2+1] = init[pixnum/2-1,pixnum/2+1] + flux/4
  init[pixnum/2+1,pixnum/2+1] = init[pixnum/2+1,pixnum/2+1] + flux/4
  
  signal = init
  
  ;;Calculate Planet Flux
  ;---------------------------------------------------------------------------------
  
  plan_flux = 1
  
  
  ;;Locate Planet in Space
  ;------------------------------------------------------------------------------
  
  M0 = 2*scene.pi*((scene.jd-scene.jd0) MOD scene.p)/scene.p       ;Mean Anomaly at query time
  Ecc = eccanom(M0, scene.e)                 ;eccentric anomaly
  v = 2*atan(sqrt(1+scene.e)*sin(Ecc/2), sqrt(1-scene.e)*cos(Ecc/2)) ;True anomaly
  
  r = scene.a*(1-scene.e^2)/(1+scene.e*cos(deg*scene.v))  ;Find orbital radius at current time
  x0 = [r*cos(scene.v),r*sin(scene.v),0]  ;Convert to cartesian in xyz

  xw = rotate3d(x0, 0, 0, -arg, /Degrees)   ;Rotate about arg
  xf = rotate3d(xw, -inc, 0, 0, /Degrees)   ;Rotate about inc
  
  true_plan_dist = norm(xf)
  proj_plan_dist = norm([xf[0:1],0])
  arg2d = atan(xf[1],xf[0])
  
  
  ;;Locate Planet on Image, add brightness
  ;------------------------------------------------------------------------------
  
  if 10*scene.plan_rad < scene.pixsize then begin ; Case 1: Planet Radius Much Smaller than Pixel Size
    
    x_scale = floor(xf / scene.pixsize) ; Scale distance to pixels, round
    
    signal[pixnum/2 + 1 + xscale[0], pixnum/2 + 1 + xscale[1]] += plan_flux
    
  endif
  
  ;;Plot Output
  ;------------------------------------------------------------------------------
  
  window, 0, XSIZE = pixnum, YSIZE = pixnum, TITLE = 'Star and Planet Brightness'
  tvscl, signal
  
end