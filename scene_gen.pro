pro scene_gen, DUMMY=dummy, PLANET=planet, VIEWRAW=viewraw

  ;;Load Scene Generation Parameters
  ;------------------------------------------------------------------------------

  scene = load_scene_params()

  ;;Create Star Brightness Map
  ;-------------------------------------------------------------------------------

  if keyword_set(dummy) then begin
  
    pixnum = scene.pixnum
    init = make_array(pixnum, pixnum, /DOUBLE, value = 0)
    
    ;;Still need to convert to flux and jansky's
    flux = scene.lstar

    init[pixnum/2,pixnum/2] = init[pixnum/2,pixnum/2] + flux

    ;init[pixnum/2,pixnum/2-1] = init[pixnum/2,pixnum/2-1] + flux/4
    ;init[pixnum/2+1,pixnum/2] = init[pixnum/2+1,pixnum/2] + flux/4
    ;init[pixnum/2-1,pixnum/2] = init[pixnum/2-1,pixnum/2] + flux/4
    ;init[pixnum/2,pixnum/2+1] = init[pixnum/2,pixnum/2+1] + flux/4

    map1 = init
  endif else begin
  
  ;;Create Brightness Map Including Disk
  ;-------------------------------------------------------------------------------
   
    zodipic, fnu, 1000*scene.apixsize, scene.lambda, $
             starname=scene.starname, inclination=scene.inclination, positionangle=scene.positionangle, $
             radin=scene.radin, radout=scene.radout, zodis=scene.zodis, /nodisplay
    
    map1=rotate(fnu,2)  ; to make North up in the display
  endelse
  
  ;;Run Planet Signal Inject
  ;-------------------------------------------------------------------------------
  
  if keyword_set(planet) then begin  
    
    if (20 * scene.plan_rad) GE (scene.lpixsize) then begin
      print, 'Warning: Planet Diameter is on the order of pixel size. There may be errors in planet brightness/location'
    endif
    
    map2 = signal_inject(params)
    
    
  endif else begin
    map2 = map1
  endelse
  
  
  ;;View Raw Brightness Maps
  ;------------------------------------------------------------------------------
  
  if keyword_set(viewraw) then begin
    
    num = scene.pixnum/2.0
    
    case 1 of
    num le 9: rfactor=16 
    (num le 18) and (num gt 9) : rfactor=8 
    (num le 37) and (num gt 18) : rfactor=8
    (num le 73) and (num gt 37) : rfactor=4 
    (num le 145) and (num gt 73) : rfactor=2 
    else: rfactor=1
    endcase
    
    if scene.pixnum lt 600 then begin
      pic=rebin(map2, scene.pixnum*rfactor, scene.pixnum*rfactor, /sample)
      sz=size(pic)
    
     window, 0, title='Surface Brightness',xsize=sz(1),ysize=sz(2)
     tvscl, pic
    
     window, 2, title='Log Surface Brightness',xsize=sz(1),ysize=sz(2)
     places=where(pic gt 0)
     if places(0) ne -1 then begin
      amin=min(pic(places))
      amin=amin > 1e-20
      pic=pic > amin
      tvscl, alog10(pic)
    endif
    
    loadct, 3
    
    endif
  endif
end