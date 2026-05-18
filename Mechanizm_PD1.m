% wczytanie danych do zadania
clear all;
Dane_PD1;

n_uk = length(c.x);

q = zeros(n_uk * 3, 1); dq = zeros(n_uk * 3, 1); d2q = zeros(n_uk * 3, 1);

n_rozw = 0;
disp("Rozpoczynam obliczenia");

for t = 0:dt:t_k
    % obliczenie rozwiązania w czasie t
    q0 = q + dq * dt + 0.5 * d2q * dt ^ 2;
    q = NewtRaph(q0, t, eps);

    % obliczenie prędkości i przyspiesznia w czasie t
    dq = Predkosc(q, t);
    d2q = Przyspieszenie(q, dq, t);

    % zapisanie rozwiązania dla czasu t obliczonego powyżej
    n_rozw = n_rozw + 1;
    T(1, n_rozw) = t; 
    Q(:, n_rozw) = q;
    DQ(:, n_rozw) = dq;
    D2Q(:, n_rozw) = d2q;
end

disp("Zakończono obliczenia");
save("wynik_PD1", "T", "Q", "DQ", "D2Q");
%postproc();