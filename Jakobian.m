function Fq = Jakobian(q)
% funkcja automatycznie wyznaczająca jakobian na podstawie danych z pliku
% wejściowego

Dane_PD1;

Fq = [];
Om = [0 -1;
      1 0];

R = struct();
r = struct();
fi = [];

for i=1:length(c.x)
    fi(i) = q(3 * i);
    R(i).R = Rot(fi(i));
    r(i).r = [q(3*i-2) q(3*i-1)]';
end

for i = 1:length(przegub)
    fq = zeros(2, 3 * numel(c.x));
    idi = przegub(i).ciala(1);
    idj = przegub(i).ciala(2);

    if idi == 0
        sj = przegub(i).sj;
        
        fq(:, 3 * idj - 2:3 * idj - 1) = -eye(2,2);
        fq(:, 3 * idj) = -Om * R(idj).R * sj;

    else
        si = przegub(i).si;
        sj = przegub(i).sj;

        fq(:, 3 * idi - 2:3 * idi - 1) = eye(2,2);
        fq(:, 3 * idi) = Om * R(idi).R * si;
        fq(:, 3 * idj - 2:3 * idj - 1) = -eye(2,2);
        fq(:, 3 * idj) = -Om * R(idj).R * sj;

    end

    Fq = [Fq; fq];
end

if postepowe

    for i = 1:length(postep)
        fq_kat = zeros(1, 3 * length(c.x));
        fq_poprz = fq_kat;

        idi = postep(i).ciala(1);
        idj = postep(i).ciala(2);

        ri = r(idi).r;
        rj = r(idj).r;

        sa = postep(i).sa;
        sb = postep(i).sb;

        Ri = R(idi).R;
        Rj = R(idj).R;

        ui = postep(i).u; uj = postep(i).u;
        vi = Om * ui; vj = Om * uj;

        ui = Ri * ui; uj = Rj * uj;
        vi = Ri * vi; vj = Rj * vj;

        % 1. fk_kat

        fq_kat(3 * idi) = 1;
        fq_kat(3 * idj) = -1;
        
        % 2. fk_poprz

        dphi_i_n = -vj' * Om * Ri * sa;

        dphi_j_n = -vj' * Om * (rj - ri - Ri * sa);

        fq_poprz(3 * idi - 2:3 * idi) = [-vj' dphi_i_n];
        fq_poprz(3 * idj - 2:3 * idj) = [vj' dphi_j_n];
        
        Fq = [Fq; 
              fq_kat; 
              fq_poprz];        
    end
end

if postepowe_kierujace

    for i = 1:length(postep_kier)
        fq_kat = zeros(1, 3 * length(c.x));
        fq_poprz = fq_kat;
        fq_d = fq_kat;

        idi = postep_kier(i).ciala(1);
        idj = postep_kier(i).ciala(2);

        ri = r(idi).r;
        rj = r(idj).r;

        sa = postep_kier(i).sa;
        sb = postep_kier(i).sb;

        Ri = R(idi).R;
        Rj = R(idj).R;

        ui = postep_kier(i).u; uj = postep_kier(i).u;
        vi = Om * ui; vj = Om * uj;

        ui = Ri * ui; uj = Rj * uj;
        vi = Ri * vi; vj = Rj * vj;

        % 1. fk_kat

        fq_kat(3 * idi) = 1;
        fq_kat(3 * idj) = -1;
        
        % 2. fk_poprz

        dphi_i_n = -vj' * Om * Ri * sa;

        dphi_j_n = -vj' * Om * (rj - ri - Ri * sa);

        fq_poprz(3 * idi - 2:3 * idi) = [-vj' dphi_i_n];
        fq_poprz(3 * idj - 2:3 * idj) = [vj' dphi_j_n];
        
        % 3. fk_d

        dphi_i_d = -uj' * Om * Ri * sa;

        dphi_j_d = -uj' * Om * (rj - ri - Ri * sa);

        fq_d(3 * idi - 2:3 * idi) = [-ui' dphi_i_d];
        fq_d(3 * idj - 2:3 * idj) = [ui' dphi_j_d];

        Fq = [Fq; 
              fq_kat; 
              fq_poprz; 
              fq_d];        
    end
end

if norm(Fq) == 0
    disp('Jakobian uległ degeneracji');
    disp('By zatrzymać wpisz dbquit');
    disp('By zignorować wpisz dbcont');
    keyboard;
end
end