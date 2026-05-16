% plik z danymi 

% parametry symulacji
eps = 1e-10;    % wymagana dokładność
t_k = 2*pi;      % czas zakończenia symulacji [s]
dt = 0.05;      % długość kroku czasowego [s]

% środki mas członów (posłużą za lokalne układy współrzędnych)
c.x = [-0.95 0.4 0.6 -0.15 -0.35 -0.05 0.25 0.35 0.4 0.6];
c.y = [0.55 0.75 0.5 0.35 0.85 0.65 0.4 0 0.35 -0.15];

% pary przegubowe
przeguby = true;

% A
przegub(1).ciala = [1 4];
przegub(1).r0 = [-1 0.2]';

% B
przegub(2).ciala = [1 5];
przegub(2).r0 = [-0.7 0.8]';

% D
przegub(3).ciala = [4 6];
przegub(3).r0 = [-0.2 0.5]';

% E
przegub(4).ciala = [2 6];
przegub(4).r0 = [0.1 0.8]';

% F
przegub(5).ciala = [2 3];
przegub(5).r0 = [0.9 0.7]';

% G
przegub(6).ciala = [3 9];
przegub(6).r0 = [0.3 0.6]';

% H
przegub(7).ciala = [0 10];
przegub(7).r0 = [0.7 -0.4]';

% I
przegub(8).ciala = [3 4];
przegub(8).r0 = [0.7 0.3]';

% J
przegub(9).ciala = [2 5];
przegub(9).r0 = [0.0 0.9]';

% L
przegub(10).ciala = [0 3];
przegub(10).r0 = [0.6 0.3]';

% M
przegub(11).ciala = [2 7];
przegub(11).r0 = [0.2 0.6]';

% N
przegub(12).ciala = [0 8];
przegub(12).r0 = [0.4 -0.2]';

przegub = wsp_lokalne(przegub, c);

% pary przegubowe kierujące
przeguby_kierujace = false;

% pary postępowe
postepowe = false;

% pary postępowe kierujące
postepowe_kierujace = true;

postep_kier(1).ciala = [7 8];
postep_kier(1).pkt_pocz = [0.2 0.6]';
postep_kier(1).pkt_kon = [0.4 -0.2]';
postep_kier(1).s = 'l_mn + a_mn * sin(omega_mn * t + fi_mn)';
l_mn = sqrt(0.2^2 + 0.8^2); a_mn = 0.05; omega_mn = 1; fi_mn = 0;

postep_kier(2).ciala = [9 10];
postep_kier(2).pkt_pocz = [0.3 0.6]';
postep_kier(2).pkt_kon = [0.7 -0.4]';
postep_kier(2).s = 'l_gh + a_gh * sin(omega_gh * t + fi_gh)';
l_gh = sqrt(0.4^2 + 1); a_gh = 0.05; omega_gh = 2; fi_gh = 0;

postep_kier = policzoffset(postep_kier, c);

% czujniki
czujniki = true;

czujnik(1).czlon = 1;
czujnik(1).r0 = [-1.2 0.6]';

czujnik(2).czlon = 2;
czujnik(2).r0 = [-0.25 0.4]';