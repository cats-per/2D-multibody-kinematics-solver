function q = NewtRaph(q0, t, eps)
% funkcja realizująca metodę Newtona-Raphsona

q = q0;
F = rWiez(q, t);
it = 1;
max_iter = 25;

while((norm(F) > eps) && it < max_iter)
    F = rWiez(q, t);
    Fq = Jakobian(q);
    %testJac(q, t);
    q = q - Fq \ F;
    it = it + 1;
    %fprintf('iter %d  ||F|| = %.12e\n',it,norm(F))
end
if it >= max_iter
    disp("Newton-Raphson nie osiągną zadanej dokładności");
    disp("By przerwać wpisz dbquit");
    disp("By zignorować wpisz dbcont");
    keyboard;
    q = q0;
end
%disp(det((Fq)));
end