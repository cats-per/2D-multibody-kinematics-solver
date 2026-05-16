function F = rWiez(q, t)
% funkcja licząca r-nia więzów w chwili t

Dane_PD1

F = [];
R = struct();
r = struct();
fi = [];

Om = [0 -1;
      1  0];

for i=1:length(c.x)
    fi(i) = q(3 * i);
    R(i).R = Rot(fi(i));
    r(i).r = [q(3*i-2) q(3*i-1)]';
end

% 1. PRZEGUBY

if przeguby
    for i = 1:length(przegub)
        idi = przegub(i).ciala(1);
        idj = przegub(i).ciala(2);

        if idi == 0
            rj = r(idj).r;

            fk = przegub(i).r0 - (rj + R(idj).R * przegub(i).sj);
        else
            ri = r(idi).r;
            rj = r(idj).r;

            fk = ri + R(idi).R * przegub(i).si - (rj + R(idj).R * przegub(i).sj);
        end

        F = [F; fk];
    end
end

% 2. PRZEGUBY KIERUJĄCE

if przeguby_kierujace
    for i = 1:length(pzegub_kier)
        idi = przegub_kier(i).ciala(1);
        idj = przegub_kier(i).ciala(2);

        if idi == 0
            fk = -fi(idj) - eval(przegub_kier(i).s);
        else
            fk = fi(idi) - fi(idj) - eval(przegub_kier(i).s);
        end
        F = [F;
             fk];
    end
end

% 3. PARY POSTĘPOWE

if postepowe
    for i = 1:length(postep)
        idi = postep(i).ciala(1);
        idj = postep(i).ciala(2);

        ri = r(idi).r;
        rj = r(idj).r;
        Ri = R(idi).R;
        Rj = R(idj).R;
        
        sa = postep(i).sa;
        sb = postep(i).sb;

        uj = postep(i).u;
        vj = Om * uj;

        % 1. brak względnego obrotu
        fk_kat = fi(idi) - fi(idj);

        % 2. brak przesunięcia poprzecznego
        fk_poprz = (Rj * vj)' * (rj - ri - Ri * sa) + vj' * sb;

        F = [F;
             fk_kat;
             fk_poprz];
    end
end

% 4. PARY POSTĘPOWE KIERUJĄCE

if postepowe_kierujace
    for i = 1:length(postep_kier)
        idi = postep_kier(i).ciala(1);
        idj = postep_kier(i).ciala(2);

        ri = r(idi).r;
        rj = r(idj).r;
        Ri = R(idi).R;
        Rj = R(idj).R;
        
        sa = postep_kier(i).sa;
        sb = postep_kier(i).sb;

        uj = postep_kier(i).u;
        vj = Om * uj;

        % 1. brak względnego obrotu
        fk_kat = fi(idi) - fi(idj);

        % 2. brak przesunięcia poprzecznego
        fk_poprz = (Rj * vj)' * (rj - ri - Ri * sa) + vj' * sb;

        % 3. zadane przesunięcie wzdłuż osi
        fk_d = (Rj * uj)' * (rj + Rj * sb - ri - Ri * sa) - eval(postep_kier(i).s);

        F = [F;
             fk_kat;
             fk_poprz;
             fk_d];
    end
end

end