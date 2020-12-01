function load_scene_params
  common scene_settings, settings
  
  ;Loads parameters need for scene generation procedures
  ;May later wish to add functionality so that it will pull fov, num_pixels, lambda from load_instrument_params?
  
  ;;fundamental constants
  ;-------------------------------------------------------------------------------------------------------
    pi = 3.141592653D
    deg = 180/pi
    km_au = 1.496*(10^8)

  ;;Stellar Parameters (Will want to make a library for the next three sections for when tyring multiple systems)
  ;--------------------------------------------------------------------------------------------------------
    ;starname = 'Epsilon_Eridani' (Named star in Zodipic, but updated data)
    rstar = 0.98D
    lstar = 0.30D
    dist = 3.218D; Hipparcos
    tstar = 5156.0D ; Bell, R. A., Gustafsson, B. 1989, MNRAS, 236, 653
    
    
  ;;Dust Parameters
  ;--------------------------------------------------------------------------------------------------------
    phi = 0.0D
    gk = 4.75D  ;Drake, S. & Smith, G., ApJ, 412, 797
    zk = -0.09D ;Drake, S. & Smith, G., ApJ, 412, 797
    zodis = 1000D ; ??
    dust_albedo = 0.56D ;Consult DIRBE Model
    
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
     
    
  ;Instrument Parameters
  ;-----------------------------------------------------------------------------------------
  
    fov = 10.0D ; Arcseconds?
    num_pixels = 100.0D ; Pixels/line
    size_pixels = fov/num_pixels ; Angular size of pixels
    lambda = 0.4D ; Microns
  
  ;Upsampling for image and correcting image size for Zodipic
  ;------------------------------------------------------------------------------------------
  
    upsample = 2
    
    num_pixels = upsample*num_pixels 
  
    rounder = num_pixels MOD 16 ;pixnum must be divisible by 16 for zodipic
    if BOOLEAN(rounder) THEN BEGIN 
      if (rounder GT 8) || (rounder EQ 8) THEN pixnum = num_pixels + (16 - rounder) $
      else pixnum = num_pixels - rounder
    endif
    
    pixsize = size_pixels*(num_pixels/pixnum) ;Size of pixels in Zodipic to maintain FOV)
    
    
    ;;Combine into single settings block
    ;--------------------------------------------------------------------------------------
    
    settings = {$
      ;Fundamental
      pi: pi, $
      deg: deg, $
      km_au: km_au, $
      
      ;Stellar
      rstar: rstar, $
      lstar: lstar, $
      dist: dist, $
      tstar: tstar, $
      
      ;Dust
      phi: phi, $
      gk: gk, $
      zk: zk, $
      zodis: zodis, $
      dust_albedo: dust_albedo, $
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
      
      ;Instrument
      fov: fov, $
      num_pixels: num_pixels, $
      size_pixels: size_pixels, $
      lambda: lambda, $
      pixnum: pixnum, $
      pixsize: pixsize $
      }
    
    return, settings
end
  
