function load_scene_params
  common scene_settings, settings
  
  ;Loads parameters need for scene generation procedures
  
  
  ;;fundamental constants
  ;-------------------------------------------------------------------------------------------------------
    km_au = 1.496d8

  ;;Stellar Parameters (Will want to make a library for the next three sections for when tyring multiple systems)
  ;--------------------------------------------------------------------------------------------------------
    starname = 'Epsilon_Eridani' ;(Named star in Zodipic, but updated data)
    rstar = 0.98D
    lstar = 0.30D
    dist = 3.218D; Hipparcos
    tstar = 5156.0D ; Bell, R. A., Gustafsson, B. 1989, MNRAS, 236, 653
    
    
  ;;Dust Parameters
  ;--------------------------------------------------------------------------------------------------------
    phi = 0.0D
    gk = 4.75D  ;Drake, S. & Smith, G., ApJ, 412, 797
    zk = -0.09D ;Drake, S. & Smith, G., ApJ, 412, 797
    zodis = 100D ; ??
    
    radin = 3.0D ; AU
    radout = 5.0D ; AU
    
    ring = 0.0D ; Density scaler of Earthring
    radring = 1.03D ; Ring Radius (Default, look into further(scales blob))
    blob = 0.0D ; Trail due to planet (O by default)
    earthlong = 0.0D ; Location of "Earth" (Check model, may be what needs to be set for planet location
    
    bands = 0.0D ; Density of asteroidal dust bands (Location Set?)
    
    inclination = 37.0D ;Allow to be different from planet?
    positionangle = 0.0D ;Does this matter for dust?
    
  ;;Planetary Parameters
  ;--------------------------------------------------------------------------------------------------------
    sma = 3.39D  ;Semi-major axis (AU)
    ecc = 0.702D ;Orbital Eccentricity
    inc = 30.1D  ;Orbital Inclination (Assume same as disk)
    arg = 47D    ;Argument of Periastron
    
    p = 2502.0D          ;Period in Days
    jd0 = 2454207.5D     ;Time of periastron (JD)
    jd =  2460766.5D     ;Query Time (JD)
    
    plan_albedo = 0.4D ;
    plan_rad = 69.911/km_au ; AU
    
    tplan = 150D ; Kelvin
     
    
  ;Instrument Parameters
  ;-----------------------------------------------------------------------------------------
  
    inst = load_inst_params()
  
    fov = inst.fov ; Arcseconds?
    num_pixels = 100 ; Pixels/line
    size_pixels = fov/num_pixels ; Angular size of pixels
    lambda = inst.lambda ; Microns

  
  ;Upsampling for image and correcting image size for Zodipic
  ;------------------------------------------------------------------------------------------
  
    upsample = 2
    
    pixnum = upsample*num_pixels 
  
    rounder = pixnum MOD 16 ;pixnum must be divisible by 16 for zodipic
    if BOOLEAN(rounder) THEN BEGIN 
      if (rounder GE 8) THEN pixnum += (16 - rounder) $
      else pixnum -= rounder
    endif
    
    apixsize = fov/pixnum ;Size of pixels in arcseconds
    lpixsize = apixsize * dist ; Size of pixels on image (AU)
    
    ;;Combine into single settings block
    ;--------------------------------------------------------------------------------------
    
    settings = {$
      ;Fundamental/Unit
      km_au: km_au, $
      
      ;Stellar
      starname:starname, $
      rstar: rstar, $
      lstar: lstar, $
      dist: dist, $
      tstar: tstar, $
      
      ;Dust
      phi: phi, $
      gk: gk, $
      zk: zk, $
      zodis: zodis, $
      radin: radin, $
      radout: radout, $
      ring: ring, $
      radring: radring, $
      blob: blob, $
      earthlong: earthlong, $
      bands: bands, $
      inclination: inclination, $
      positionangle: positionangle, $
      
      ;Planetary
      sma: sma, $
      ecc: ecc, $
      inc: inc, $
      arg: arg, $
      p: p, $
      jd: jd, $
      jd0: jd0, $
      plan_albedo: plan_albedo, $
      plan_rad: plan_rad, $
      tplan:tplan, $
      
      ;Instrument
      fov: fov, $
      num_pixels: num_pixels, $
      size_pixels: size_pixels, $
      lambda: lambda, $
      pixnum: pixnum, $
      apixsize: apixsize, $
      lpixsize:lpixsize $
      }
    
    return, settings
end
  
