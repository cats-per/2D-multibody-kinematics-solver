function R = Rot(phi)
% obliczenie macierzy rotacji

R = [cos(phi) -sin(phi); ...
     sin(phi) cos(phi)];
end