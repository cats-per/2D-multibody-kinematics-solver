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

[answer, tf] = handle_input_dlg(c);

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
    end

    % zdefiniowanie nazw wykresów i ich opisów
    tytul_r = strcat("położenie członu ", num2str(i));
    tytul_fi = strcat("kąt obrotu członu ", num2str(i));
    tytul_dr = strcat("prędkość liniowa członu ", num2str(i));
    tytul_dfi = strcat("prędkość obrotowa członu ", num2str(i));
    tytul_d2r = strcat("przyspieszenie liniowe członu ", num2str(i));
    tytul_d2fi = strcat("przeyspieszenie obrotowe członu ", num2str(i));
    tytul_trajektoria = "trajektoria członu " + num2str(i);

    tytul_plik_r = "czlon_" + num2str(i) + "_r";
    tytul_plik_fi = "czlon_" + num2str(i) + "_fi";
    tytul_plik_dr = "czlon_" + num2str(i) + "_dr";
    tytul_plik_dfi = "czlon_" + num2str(i) + "_dfi";
    tytul_plik_d2r = "czlon_" + num2str(i) + "_d2r";
    tytul_plik_d2fi = "czlon_" + num2str(i) + "_d2fi";
    tytul_plik_trajektoria = "czlon_" + num2str(i) + "_trajektoria";

    legenda_r = ["r_x", "r_y"];
    legenda_fi = "\phi";
    legenda_dr = ["v_x", "v_y"];
    legenda_dfi = "\omega";
    legenda_d2r = ["a_x", "a_y"];
    legenda_d2fi = "\epsilon";
    legenda_trajektoria = "y(x)";

    label_x = "czas [s]";
    label_r = "położenie [m]";
    label_fi = "\phi [rad]";
    label_dr = "v [m/s]";
    label_dfi = "\omega [rad/s]";
    label_d2r = "a [m/s^2]";
    label_d2fi = "\epsilon [rad/s^2]";

    kolumna_rx = "czlon_" + num2str(i) + "_rx";
    kolumna_ry = "czlon_" + num2str(i) + "_ry";
    kolumna_fi = "czlon_" + num2str(i) + "_fi";
    kolumna_vx = "czlon_" + num2str(i) + "_vx";
    kolumna_vy = "czlon_" + num2str(i) + "_vy";
    kolumna_dfi = "czlon_" + num2str(i) + "_dfi";
    kolumna_ax = "czlon_" + num2str(i) + "_ax";
    kolumna_ay = "czlon_" + num2str(i) + "_ay";
    kolumna_d2fi = "czlon_" + num2str(i) + "_d2fi";

    % przekazanie danych o wykresach i-tego członu do pomocniczych funkcji
    % plotujących i zapisujących do plików pdf
    disp("drukuję człon " + num2str(i));
    Plotuj_r(r, T, tytul_r, legenda_r, label_r, label_x, tytul_plik_r, ustawienia);
    Plotuj_r(dr, T, tytul_dr, legenda_dr, label_dr, label_x, tytul_plik_dr, ustawienia);
    Plotuj_r(d2r, T, tytul_d2r, legenda_d2r, label_d2r, label_x, tytul_plik_d2r, ustawienia);
    Plotuj_fi(fi, T, tytul_fi, legenda_fi, label_fi, label_x, tytul_plik_fi, ustawienia);
    Plotuj_fi(dfi, T, tytul_dfi, legenda_dfi, label_dfi, label_x, tytul_plik_dfi, ustawienia);
    Plotuj_fi(d2fi, T, tytul_d2fi, legenda_d2fi, label_d2fi, label_x, tytul_plik_d2fi, ustawienia);
    Plotuj_fi(r(2,:), r(1,:), tytul_trajektoria, legenda_trajektoria, "y [m]", "x [m]", tytul_plik_trajektoria, ustawienia);

    % dopisanie odpowiednich wektorów do tabeli przechowującej wyniki na
    % potrzebę pliku csv
    saveTable.(sprintf("%s", kolumna_rx)) = r(1, :)';
    saveTable.(sprintf("%s", kolumna_ry)) = r(2, :)';
    saveTable.(sprintf("%s", kolumna_fi)) = fi';
    saveTable.(sprintf("%s", kolumna_vx)) = dr(1, :)';
    saveTable.(sprintf("%s", kolumna_vy)) = dr(2, :)';
    saveTable.(sprintf("%s", kolumna_dfi)) = dfi';
    saveTable.(sprintf("%s", kolumna_ax)) = d2r(1, :)';
    saveTable.(sprintf("%s", kolumna_ay)) = d2r(2, :)';
    saveTable.(sprintf("%s", kolumna_d2fi)) = d2fi';

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
        tytul_r = "położenie czujnika " + num2str(i);
        tytul_dr = "prędkość czujnika " + num2str(i);
        tytul_d2r = "przyspieszenie czujnika " + num2str(i);
        tytul_trajektoria = "trajektoraia czujnika " + num2str(i);

        tytul_plik_r = "czujnik_" + num2str(i) + "_r";
        tytul_plik_dr = "czujnik_" + num2str(i) + "_dr";
        tytul_plik_d2r = "czujnik_" + num2str(i) + "_d2r";
        tytul_plik_trajektoria = "czujnik_" + num2str(i) + "_trajektoria";

        legenda_r = ["r_x", "r_y"];
        legenda_dr = ["v_x", "v_y"];
        legenda_d2r = ["a_x", "a_y"];
        legenda_trajektoria = "y(x)";

        label_r = "położenie [m]";
        label_dr = "v [m/s]";
        label_d2r = "a [m/s^2]";

        kolumna_rx = "czujnik_" + num2str(i) + "_rx";
        kolumna_ry = "czujnik_" + num2str(i) + "_ry";
        kolumna_vx = "czujnik_" + num2str(i) + "_vx";
        kolumna_vy = "czujnik_" + num2str(i) + "_vy";
        kolumna_ax = "czujnik_" + num2str(i) + "_ax";
        kolumna_ay = "czujnik_" + num2str(i) + "_ay";

        % przekazanie danych o wykresach i-tego czujnika do pomocniczych funkcji
        % plotujących i zapisujących do plików pdf
        disp("drukuję czujnik " + num2str(i));
        Plotuj_r(r_czuj, T, tytul_r, legenda_r, label_r, label_x, tytul_plik_r, ustawienia);
        Plotuj_r(dr_czuj, T, tytul_dr, legenda_dr, label_dr, label_x, tytul_plik_dr, ustawienia);
        Plotuj_r(d2r_czuj, T, tytul_d2r, legenda_d2r, label_d2r, label_x, tytul_plik_d2r, ustawienia);
        Plotuj_fi(r_czuj(2,:), r_czuj(1,:), tytul_trajektoria, legenda_trajektoria, "y [m]", "x [m]", tytul_plik_trajektoria, ustawienia);

        % dopisanie odpowiednich wektorów do tabeli przechowującej wyniki na
        % potrzebę pliku csv
        saveTable.(sprintf("%s", kolumna_rx)) = r_czuj(1, :)';
        saveTable.(sprintf("%s", kolumna_ry)) = r_czuj(2, :)';
        saveTable.(sprintf("%s", kolumna_vx)) = r_czuj(1, :)';
        saveTable.(sprintf("%s", kolumna_vy)) = r_czuj(2, :)';
        saveTable.(sprintf("%s", kolumna_ax)) = d2r_czuj(1, :)';
        saveTable.(sprintf("%s", kolumna_ay)) = d2r_czuj(2, :)';
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