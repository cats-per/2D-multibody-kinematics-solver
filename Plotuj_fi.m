function Plotuj_fi(fi, t, tytul, legenda, labele, label_x, plik_t, ustawienia)
% pomocnicza funkcja tworząca wykres jednej zmiennej od czasu według opisów
% zdefiniowanych w argumentach i zapisująca do pliku pdf w podfolderze Wyniki\

% ======================== setup wykresów ========================

% wymiary renderu pdf
width = ustawienia.width;
height = ustawienia.height;

% ustawienia siatki
gridTransparency = ustawienia.gridTransparency;
gridColor = ustawienia.gridColor;

% spis kolorow
col_fi = ustawienia.col_fi;

% grubosci kresek
other_plotWidth = ustawienia.other_plotWidth;

% czcionki
rozmiarCzcionkiMin = ustawienia.rozmiarCzcionkiMin; % normal text
rozmiarCzcionkiBig = ustawienia.rozmiarCzcionkiBig; % title

% ======================== tworzenie wykresów ========================
wykres = figure('Visible', ustawienia.wyswietl);
    set(gcf, 'Name', tytul, 'NumberTitle', 'off', 'Units', 'centimeters', 'Position', [10, 10, width, height]);
    set(gcf, 'PaperUnits', 'centimeters', 'PaperSize', [width, height]); % [width, height]
    set(gcf, 'PaperPosition', [0, 0, width, height]); % [left, bottom, width, height]
    set(gca, 'FontSize', rozmiarCzcionkiMin);

    hold on;

    plot(t, fi, "LineWidth", other_plotWidth, "Color", col_fi);

    title(tytul, 'FontSize', rozmiarCzcionkiBig, 'FontWeight', 'bold');
    legend(legenda, 'Location', 'northeast');

    xlabel(label_x); ylabel(labele);

    xlim([min(t) - 0.1, max(t) + 0.1]);
    grid on;
        ax = gca;
        ax.GridColor = gridColor; 
        ax.GridAlpha = gridTransparency;

        if ~exist("Wyniki", 'dir')
            mkdir("Wyniki");
        end

        savePath = fullfile("Wyniki", plik_t);
   if strcmp(ustawienia.format, "pdf")
       print(gcf, savePath, '-dpdf', '-r300', '-vector');
   else
       print(gcf, savePath, '-dpng', '-r300');
   end
end