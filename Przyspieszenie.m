function d2q = Przyspieszenie(q, dq, t)
% funkcja wyznaczająca wektor drugiej pochodnej wektora q po czasie

Dane_PD1;

gamma = [];
Fq = Jakobian(q);
Om = [0 -1;
      1 0];

for i=1:length(c.x)
    fi(i) = q(3 * i);
    dfi(i) = dq(3 * i);
    R(i).R = Rot(fi(i));
    r(i).r = [q(3*i-2) q(3*i-1)]';
    r(i).dr = [dq(3*i-2) dq(3*i-1)]';
end

if przeguby
    for i = 1:numel(przegub)
        idi = przegub(i).ciala(1);
        idj = przegub(i).ciala(2);

        if idi == 0
            gamma_i = -R(idj).R * przegub(i).sj * dfi(idj) ^ 2;
        else
            gamma_i = R(idi).R * przegub(i).si * dfi(idi) ^ 2 - R(idj).R * przegub(i).sj * dfi(idj) ^ 2;
        end

        gamma = [gamma;
                 gamma_i];
    end
end

if przeguby_kierujace
    disp('Jeszcze nie zaimplementowano');
end

if postepowe
    disp('Jeszcze nie zaimplementowano');
end

if postepowe_kierujace
    for i = 1:numel(postep_kier)
        idi = postep_kier(i).ciala(1);
        idj = postep_kier(i).ciala(2);

        timeTemp = t;
        syms t;
        s = str2sym(postep_kier(i).s);
        ds = diff(s, t);
        d2s = diff(ds, t);

        t = timeTemp;

        ri = r(idi).r;
        rj = r(idj).r;

        dri = r(idi).dr;
        drj = r(idj).dr;

        Ri = R(idi).R;
        Rj = R(idj).R;

        sa = postep_kier(i).sa;
        sb = postep_kier(i).sb;

        %v_local = Rot(postep_kier(i).offset) * [0 1]';

        %v = Ri * v_local;
        %u = -Om * v;

        u = postep_kier(i).u;
        v = Om * u;

        gamma_k_kat = 0;
        gamma_k_poprz = (Rj * v)' * (2 * Om * (drj - dri) * dfi(idj) + (rj - ri) * (dfi(idj) ^ 2) - Ri * sa * ((dfi(idj) - dfi(idi)) ^ 2));

        gamma_d = (Rj * u)' * (2 * Om * (drj - dri) * dfi(idj) + (rj - ri) * (dfi(idj) ^ 2) - Ri * sa * ((dfi(idj) - dfi(idi)) ^ 2)) + eval(d2s);

        gamma = [gamma;
                 gamma_k_kat;
                 gamma_k_poprz;
                 gamma_d];
    end
end

d2q = Fq \ (gamma);

end