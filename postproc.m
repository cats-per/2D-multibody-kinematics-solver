function postproc()
% funkcja przygotowująca wykresy przebiegów położeń, prędkości i
% przyspieszeń liniowych i kątowych dla wszystkich członów mechanizmu i
% zdefiniowanych czujników oraz zapisująca te dane do pliku Wynik.csv
% wykresy i plik csv zapisywane są w podfolderze Wyniki\

close all;
Dane_PD1;
wynik = load("wynik_PD1.mat");

disp("Zaczynam postprocessing");

Q = wynik.Q;
DQ = wynik.DQ;
D2Q = wynik.D2Q;
T = wynik.T;

saveTable = table();
saveTable.czas = T';

[answer, tf, answer2, tf2] = handle_input_dlg(c);

if tf2 && answer2 == 1
    ustawienia.format = "pdf";
else
    ustawienia.format = "png";
end

%% ===================== setup wykresów =====================

% wymiary renderu pdf
ustawienia.width = 15;
ustawienia.height = 8;

% ustawienia siatki
ustawienia.gridTransparency = .3;
ustawienia.gridColor = [0.5, 0.5, 0.5];

% spis kolorow
ustawienia.col_x = '#680404';
ustawienia.col_y = '#1c600f';
ustawienia.col_fi = '#680404';

% grubosci kresek
ustawienia.main_plotWidth = 2;
ustawienia.other_plotWidth = 1.25;

% czcionki
ustawienia.rozmiarCzcionkiMin = 12; % normal text
ustawienia.rozmiarCzcionkiMid = 13; % subtitle
ustawienia.rozmiarCzcionkiBig = 15; % title

ustawienia.wyswietl = 'off';

legenda.r = ["r_x", "r_y"];
legenda.fi = "\phi";
legenda.dr = ["v_x", "v_y"];
legenda.dfi = "\omega";
legenda.d2r = ["a_x", "a_y"];
legenda.d2fi = "\epsilon";
legenda.trajektoria = "y(x)";

label.x = "czas [s]";
label.r = "położenie [m]";
label.fi = "\phi [rad]";
label.dr = "v [m/s]";
label.dfi = "\omega [rad/s]";
label.d2r = "a [m/s^2]";
label.d2fi = "\epsilon [rad/s^2]";

%% wykresy dla środków mas

for i = 1:numel(c.x)
    % wczytanie rozwiązań położeń, prędkości i przyspieszeń dla środka masy
    % i-tego członu
    r = Q(3*i-2:3*i-1, :);
    fi = Q(3*i, :);
    dr = DQ(3*i-2:3*i-1, :);
    dfi = DQ(3*i, :);
    d2r = D2Q(3*i-2:3*i-1, :);
    d2fi = D2Q(3*i, :);

    if tf && ismember(i, answer)
        ustawienia.wyswietl = 'on';
    else
        ustawienia.wyswietl = 'off';
        continue
    end

    % zdefiniowanie nazw wykresów i ich opisów
    tytul.r = strcat("położenie członu ", num2str(i));
    tytul.fi = strcat("kąt obrotu członu ", num2str(i));
    tytul.dr = strcat("prędkość liniowa członu ", num2str(i));
    tytul.dfi = strcat("prędkość obrotowa członu ", num2str(i));
    tytul.d2r = strcat("przyspieszenie liniowe członu ", num2str(i));
    tytul.d2fi = strcat("przeyspieszenie obrotowe członu ", num2str(i));
    tytul.trajektoria = "trajektoria członu " + num2str(i);

    tytul.plik.r = "czlon_" + num2str(i) + "_r";
    tytul.plik.fi = "czlon_" + num2str(i) + "_fi";
    tytul.plik.dr = "czlon_" + num2str(i) + "_dr";
    tytul.plik.dfi = "czlon_" + num2str(i) + "_dfi";
    tytul.plik.d2r = "czlon_" + num2str(i) + "_d2r";
    tytul.plik.d2fi = "czlon_" + num2str(i) + "_d2fi";
    tytul.plik.trajektoria = "czlon_" + num2str(i) + "_trajektoria";

    kolumna.rx = "czlon_" + num2str(i) + "_rx";
    kolumna.ry = "czlon_" + num2str(i) + "_ry";
    kolumna.fi = "czlon_" + num2str(i) + "_fi";
    kolumna.vx = "czlon_" + num2str(i) + "_vx";
    kolumna.vy = "czlon_" + num2str(i) + "_vy";
    kolumna.dfi = "czlon_" + num2str(i) + "_dfi";
    kolumna.ax = "czlon_" + num2str(i) + "_ax";
    kolumna.ay = "czlon_" + num2str(i) + "_ay";
    kolumna.d2fi = "czlon_" + num2str(i) + "_d2fi";

    % przekazanie danych o wykresach i-tego członu do pomocniczych funkcji
    % plotujących i zapisujących do plików pdf
    disp("drukuję człon " + num2str(i));
    Plotuj_r(r, T, tytul.r, legenda.r, label.r, label.x, tytul.plik.r, ustawienia);
    Plotuj_r(dr, T, tytul.dr, legenda.dr, label.dr, label.x, tytul.plik.dr, ustawienia);
    Plotuj_r(d2r, T, tytul.d2r, legenda.d2r, label.d2r, label.x, tytul.plik.d2r, ustawienia);
    Plotuj_fi(fi, T, tytul.fi, legenda.fi, label.fi, label.x, tytul.plik.fi, ustawienia);
    Plotuj_fi(dfi, T, tytul.dfi, legenda.dfi, label.dfi, label.x, tytul.plik.dfi, ustawienia);
    Plotuj_fi(d2fi, T, tytul.d2fi, legenda.d2fi, label.d2fi, label.x, tytul.plik.d2fi, ustawienia);
    Plotuj_fi(r(2,:), r(1,:), tytul.trajektoria, legenda.trajektoria, "y [m]", "x [m]", tytul.plik.trajektoria, ustawienia);

    % dopisanie odpowiednich wektorów do tabeli przechowującej wyniki na
    % potrzebę pliku csv
    saveTable.(sprintf("%s", kolumna.rx)) = r(1, :)';
    saveTable.(sprintf("%s", kolumna.ry)) = r(2, :)';
    saveTable.(sprintf("%s", kolumna.fi)) = fi';
    saveTable.(sprintf("%s", kolumna.vx)) = dr(1, :)';
    saveTable.(sprintf("%s", kolumna.vy)) = dr(2, :)';
    saveTable.(sprintf("%s", kolumna.dfi)) = dfi';
    saveTable.(sprintf("%s", kolumna.ax)) = d2r(1, :)';
    saveTable.(sprintf("%s", kolumna.ay)) = d2r(2, :)';
    saveTable.(sprintf("%s", kolumna.d2fi)) = d2fi';

end

%% wykresy dla zdefiniowanych czujników

if czujniki
    ustawienia.wyswietl = 'on';
    Om = [0 -1;
          1 0];
    for i = 1:numel(czujnik)
        % wczytanie danych o czujniku i rozwiązań zadań o położeniach,
        % prędkościach i przyspieszeniach członu, do którego należy
        id = czujnik.czlon;

        r = Q(3*id-2:3*id-1, :);
        fi = Q(3*id, :);
        dr = DQ(3*id-2:3*id-1, :);
        dfi = DQ(3*id, :);
        d2r = D2Q(3*id-2:3*id-1, :);
        d2fi = D2Q(3*id, :);

        r_loc = czujnik(i).r0 - [c.x(id) c.y(id)]';

        % wyznaczenie rozwiązań zadań o położeniach, prędkościach i
        % przyspieszeniach dla zdefiniowanego czujnika
        for j = 1:length(T)
            R = Rot(fi(j));
            ri = r(:, j);
            dri = dr(:, j);
            d2ri = d2r(:, j);

            r_czuj(:, j) = (ri + R * r_loc);
            dr_czuj(:, j) = (dri + Om * R * r_loc * dfi(j));
            d2r_czuj(:, j) = (d2ri + Om * R * r_loc * d2fi(j) - R * r_loc * dfi(j) ^ 2);
        end

        % zdefiniowanie nazw wykresów i ich opisów
        tytul.r = "położenie czujnika " + num2str(i);
        tytul.dr = "prędkość czujnika " + num2str(i);
        tytul.d2r = "przyspieszenie czujnika " + num2str(i);
        tytul.trajektoria = "trajektoraia czujnika " + num2str(i);

        tytul.plik.r = "czujnik_" + num2str(i) + "_r";
        tytul.plik.dr = "czujnik_" + num2str(i) + "_dr";
        tytul.plik.d2r = "czujnik_" + num2str(i) + "_d2r";
        tytul.plik.trajektoria = "czujnik_" + num2str(i) + "_trajektoria";

        kolumna.rx = "czujnik_" + num2str(i) + "_rx";
        kolumna.ry = "czujnik_" + num2str(i) + "_ry";
        kolumna.vx = "czujnik_" + num2str(i) + "_vx";
        kolumna.vy = "czujnik_" + num2str(i) + "_vy";
        kolumna.ax = "czujnik_" + num2str(i) + "_ax";
        kolumna.ay = "czujnik_" + num2str(i) + "_ay";

        % przekazanie danych o wykresach i-tego czujnika do pomocniczych funkcji
        % plotujących i zapisujących do plików pdf
        disp("drukuję czujnik " + num2str(i));
        Plotuj_r(r_czuj, T, tytul.r, legenda.r, label.r, label.x, tytul.plik.r, ustawienia);
        Plotuj_r(dr_czuj, T, tytul.dr, legenda.dr, label.dr, label.x, tytul.plik.dr, ustawienia);
        Plotuj_r(d2r_czuj, T, tytul.d2r, legenda.d2r, label.d2r, label.x, tytul.plik.d2r, ustawienia);
        Plotuj_fi(r_czuj(2,:), r_czuj(1,:), tytul.trajektoria, legenda.trajektoria, "y [m]", "x [m]", tytul.plik.trajektoria, ustawienia);

        % dopisanie odpowiednich wektorów do tabeli przechowującej wyniki na
        % potrzebę pliku csv
        saveTable.(sprintf("%s", kolumna.rx)) = r_czuj(1, :)';
        saveTable.(sprintf("%s", kolumna.ry)) = r_czuj(2, :)';
        saveTable.(sprintf("%s", kolumna.vx)) = r_czuj(1, :)';
        saveTable.(sprintf("%s", kolumna.vy)) = r_czuj(2, :)';
        saveTable.(sprintf("%s", kolumna.ax)) = d2r_czuj(1, :)';
        saveTable.(sprintf("%s", kolumna.ay)) = d2r_czuj(2, :)';
    end
end

%% zapis do pliku csv

nazwa_pliku = 'Wynik.csv';

if ~exist('Wyniki', 'dir')
    makedir('Wyniki');
end

savePath = fullfile('Wyniki', nazwa_pliku);

writetable(saveTable, savePath);
disp("Zakończono postprocessing");

end