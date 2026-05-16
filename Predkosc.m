function dq = Predkosc(q, t)
% funckcja automatycznie uzupełniająca wektor pierwszej pochodnej wektora q
% po czasie

Dane_PD1;

nu = [];
Fq = Jakobian(q);

if przeguby
    for i = 1:numel(przegub)
        nu_i = 0;
        nu_j = 0;

        nu = [nu; 
              nu_i; 
              nu_j];
    end
end

if przeguby_kierujace
    disp('Jeszcze nie zaimplementowano');
end

if postepowe
    for i = 1:numel(postep)
        nu_kat = 0;
        nu_poprzeczny = 0;

        nu = [nu;
              nu_kat;
              nu_poprzeczny];
    end
end

if postepowe_kierujace
    for i = 1:numel(postep_kier)
        nu_kat  = 0;
        nu_poprzeczny = 0;
        timeTemp = t;
        syms t;
        s = str2sym(postep_kier(i).s);
        ds = diff(s, t);

        t = timeTemp;
        nu_kierujacy = -eval(ds);

        nu = [nu;
              nu_kat;
              nu_poprzeczny;
              nu_kierujacy];
    end
end

dq = Fq \ (-nu);

end