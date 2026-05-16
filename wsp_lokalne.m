function przegub = wsp_lokalne(przegub, c)

% funkcja zwracająca wsp lokalne przegubów w układach współrzędnych do
% których należą

si = []; sj = [];

for i = 1:length(przegub)
    p = przegub(i).ciala(1);
    if p == 0 
        si = przegub(i).r0(:);
    else
        rx = c.x(przegub(i).ciala(1));
        ry = c.y(przegub(i).ciala(1));
        si = przegub(i).r0 - [rx ry]';
    end

    rx = c.x(przegub(i).ciala(2));
    ry = c.y(przegub(i).ciala(2));
    sj = przegub(i).r0 - [rx ry]';

    przegub(i).si = si;
    przegub(i).sj = sj;
end

end