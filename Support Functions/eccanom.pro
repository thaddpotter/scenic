function eccanom, M, e

  ;;Finds eccentric anomaly from mean anomaly and eccentricity
  ;;Adapted from EXOSIMS, Dmitry Savransky

  ;;This method uses algorithm 2 from Vallado to find the eccentric anomaly
  ;;from mean anomaly and eccentricity.

  ;;Args:
  ;;M (float):  mean anomaly
  ;;e (float or ndarray): eccentricity 

  ;;Returns:
  ;;E (float or ndarray):  eccentric anomaly

  ;initial values for E
  E = M/(1-e)
  mask = e*(E^2) > 6*(1-e)
  E[mask] = (6*M[mask]/e[mask])**(1./3)

  ; Newton-Raphson setup
  tolerance = 0.00001
  numIter = 0
  maxIter = 200
  err = 1.
  
  while err > tolerance and numIter < maxIter do begin
  E = E - (M - E + e*sin(E))/(e*cos(E)-1) ;verbatim from first page of Vallado
  err = abs(M - (E - e*sin(E)))
  ++numIter
  endwhile

  ;if numIter == maxIter:
  ;print, 'eccanom failed to converge. Final error of ', err

  return, E
end