%cir = reuse(10, 10, 5000, 3, 2, 500, 500)


close all;
clear all;
clc;

radii = [2000 5000 10000 15000];
k = 7;
gamma = 3;
maxCIRdB = 30;
minCIRdB = -10;
noBins = 50;

% Para evitar abrir las figuras dentro de reuse()
set(0, 'DefaultFigureVisible', 'off');

% Guardamos CIRs de cada radio sin mostrar figuras
allCIR = cell(length(radii), 1);
for idx = 1:length(radii)
    allCIR{idx} = reuse(10,10,radii(idx),k,gamma,500,500);
end

% Volvemos a mostrar figuras
set(0, 'DefaultFigureVisible', 'on');

% Creamos la figura CDF comparativa
figure; hold on;
for idx = 1:length(radii)
    cirdB = 10*log10(allCIR{idx});
    cirdBSamples = cirdB(:);
    cirdBSamples = min(cirdBSamples, maxCIRdB);
    cirdBSamples = max(cirdBSamples, minCIRdB);
    [n,x] = hist(cirdBSamples, noBins);
    n = n / sum(n);
    cdf = cumsum(n);
    plot(x, cdf, 'DisplayName', sprintf('Radio = %d m', radii(idx)));
end
grid on;
xlabel('CIR (dB)');
ylabel('Proporción acumulada');
title('CDF comparativa para distintos radios');
legend;
