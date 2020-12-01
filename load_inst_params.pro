function load_inst_params
  common inst_settings, settings

  ;Loads parameters needed for instrument model procedures

  ;;fundamental constants
  ;-------------------------------------------------------------------------------------------------------
  km_au = 1.496e8


  ;;Parameters needed in scene generation
  ;-----------------------------------------------------------------------------------------------------
  fov = 10.0D ; Arcseconds
  num_pixels = 100.0D ; Pixels/line

  lambda = 0.4D ; Central Wavelength (Microns)

  ;;Combine into single settings block
  ;-----------------------------------------------------------------------------------------------------

  settings = {$
    ;Category
    fov: fov, $
    num_pixels: num_pixels, $
    lambda: lambda }

  return, settings
end

