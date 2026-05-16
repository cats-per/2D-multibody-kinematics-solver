function przesuw = policzoffset(przesuw, c)

for i = 1:length(przesuw)
    r = przesuw(i).pkt_kon - przesuw(i).pkt_pocz;
    u = r / norm(r);

    przesuw(i).offset = atan2(abs(r(2)), r(1));
    przesuw(i).u = u;

    przesuw(i).sa = przesuw(i).pkt_pocz - [c.x(przesuw(i).ciala(1)) c.y(przesuw(i).ciala(1))]';
    przesuw(i).sb = przesuw(i).pkt_kon - [c.x(przesuw(i).ciala(2)) c.y(przesuw(i).ciala(2))]';
end
end