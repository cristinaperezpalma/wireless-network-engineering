function [cir] = reuse(hcells, vcells, r, k, exponent, deltaX, deltaY) 
% Syntax: %       
%      [cir] = reuse(hcells, vcells, r, k, exponent) 
%       cir ........ matrix with CIR for the different (x,y) positions 
%       hcells ..... number of horizontal cells in the grid 
%       vcells ..... number of verticall cells in the grid 
%       r .......... cell radius (meters) 
%       k .......... frequency reuse (cluster size) 
%       exponent ... exponent of the simplified model (between 2 and 4) 
%       deltaX ..... CIR is calculated every deltaX meters 
%       deltaY ..... CIR is calculated every deltaY meters 

% MAX and MIN values for CIR figures (not used in calculations) 
maxCIRdB = 30;  % dB 
minCIRdB = -10; % dB 

%Find the i and j values for the cluster size k (k = i^2 + j^2 + i*j) 
found = false; 
for i=0:k 
    for j=0:i 
        auxK = i^2 + j^2 + i*j; 
        if ((auxK == k) && (not(found))) 
            found = true; 
            ki = i; 
            kj = j; 
        end
    end
end

% Position of the center of the cells 
h = sqrt(3)*r; 
for i=1:hcells 
    for j=1:vcells 
        % Cell position (cellsX and cellsY are the X and Y values of the 
        % center of the cell) 
        cellsX(i,j) = r + (i-1)*3*r + (3/2)*r*(1-mod(j,2)); 
        cellsY(i,j) = j*h/2; 
    end
end

% Plot cells
figure; hold on;
%plot (cellsX, cellsY, '+k'); 
hcolor=colormap(hsv(k)); 
for i1=1:hcells 
    for j1=1:vcells 
        % Plot cells 
        [x,y] = hexagon(0.9*r, cellsX(i1,j1), cellsY(i1,j1));
        plot(x,y, 'k'); 
        textOffset = -2; 
        text(cellsX(i1,j1) + textOffset*deltaX, cellsY(i1,j1), ['(' num2str(i1) ',' num2str(j1) ')'], 'FontSize', 8); 
    end
end
xlabel('X position (meters)'); ylabel('Y position (meters)');
title('Cell indexing (i,j)');

% Regular frequency assignment 
frequency = zeros(hcells, vcells); 
for i=1:k 
    % Find a cell with no frequency assigned 
    cellnumber = find(frequency==0); 
    cellnumber = cellnumber(1); 
    cellI = mod((cellnumber-1), hcells) + 1; 
    cellJ = floor((cellnumber-1) / hcells) + 1; 
    frequency(cellI, cellJ) = i; 
    % Assign same frequency to the six cells around this cell (using i steps in one direction  
    % and then j steps in another direction (see Figure 1) 
    for j=1:6 
        frequency = setFrequencyNextCell(cellI, cellJ, ki, kj, j, i, frequency, hcells, vcells); 
    end
end

% Figure with frequency assignments 
figure; hold on; 
plot (cellsX, cellsY, '+k'); 
hcolor=colormap(hsv(k)); 
for i1=1:hcells 
    for j1=1:vcells 
        % Plot cells 
        [x,y] = hexagon(0.9*r, cellsX(i1,j1), cellsY(i1,j1)); 
        size(frequency);
        plot(x,y, 'LineWidth', 3, 'Color', hcolor(frequency(i1,j1),:)); 
        textOffset = 1; 
        text(cellsX(i1,j1) + textOffset*deltaX, cellsY(i1,j1), num2str(frequency(i1,j1)),  'FontSize', 8, 'Color', hcolor(frequency(i1,j1),:)); 
    end
end
xlabel('X position (meters)'); ylabel('Y position (meters)'); 
title('Cell locations and frequencies'); 
cb1=colorbar; 
set(get(cb1,'ylabel'),'String', 'frequency'); 
maxX = max(max(cellsX)) + r; 
maxY = max(max(cellsY)) + r; 
axis ([0 maxX 0 maxY]);

% Calculate pathloss values 
maxX2 = ceil(maxX/deltaX); 
maxY2 = ceil(maxY/deltaY); 
pathloss = zeros(hcells*vcells, maxX2, maxY2); 
% Loops for cells 
for i=1:hcells 
    for j=1:vcells 
        % Loops for X and Y 
        for x=1:maxX2 
            for y=1:maxY2 
                txPos = [cellsX(i,j), cellsY(i,j)];
                rxPos = [x * deltaX, y * deltaY];
                % Pathloss between the cell and the point (x*deltaX, y*deltaY) 
                pathloss(i + (j-1)*hcells, x, y) = pathloss_model(txPos, rxPos, exponent); 
                    
            end
        end
    end
end

% Calculate CIR values 
cir = zeros(maxX2, maxY2); 
receivedPower = zeros(maxX2, maxY2); 
interferencePower = zeros(maxX2, maxY2); 
for x=1:maxX2 
    for y=1:maxY2 
        % Cell with highest received power, i.e. lowest path loss 
        predominantCell = find(pathloss(:,x,y) == min(pathloss(:,x,y))); 
        predominantCell = predominantCell(1); % Just in case two cells were at the same  
        % distance 
        frequencyPredominantCell = frequency(predominantCell); 
        % Received power (but scaling factors) 
        receivedPower(x,y) = 1/pathloss(predominantCell,x,y); 
        % Cells using same frequency 
        cellsWithSameFrequency = find(frequency == frequencyPredominantCell); 
        % Removing selected (predominant) cell 
        cellsWithSameFrequency = cellsWithSameFrequency(find(cellsWithSameFrequency ~=  predominantCell)); 
        % Interference power (but scaling factors) 
        interferencePower(x,y) = sum(1./pathloss(cellsWithSameFrequency,x,y)); 
        % CIR 
        cir(x,y) = receivedPower(x,y) / interferencePower(x,y); 
    end
end

% Values in dBs 
receivedPowerdB = 10*log10(receivedPower); 
interferencePowerdB = 10*log10(interferencePower); 
cirdB = 10*log10(cir); 
% Bound CIR values for the plot 
maxCIRdBMatrix = maxCIRdB*ones(size(cirdB)); 
minCIRdBMatrix = minCIRdB*ones(size(cirdB)); 
limitedCIRdB = max(minCIRdBMatrix,min(maxCIRdBMatrix, cirdB));

% CIR figure 
figure; set(gcf, 'renderer', 'painters');
colormap jet; 
pcolor((1:maxX2)*deltaX, (1:maxY2)*deltaY, limitedCIRdB'); 
shading(gca, 'interp'); cb2=colorbar; set(get(cb2,'ylabel'),'String', 'CIR (dB)'); 
xlabel('X position (meters)'); ylabel('Y position (meters)'); 
title('Carrier to Interference Ratio (CIR)');

% CIR histogram (probability density function) 
figure; 
cirdBsamples = cirdB(:); 
noBins = 50; 
[n,x] = hist(cirdBsamples, noBins); 
n = n / sum(n); 
plot(x,n); 
grid on; xlabel('CIR (dB)'); ylabel('proportion of samples'); 
title('CIR probability density function'); 

% CIR cumulative density function 
figure; 
n = cumsum(n); 
plot(x,n); 
grid on; xlabel('CIR (dB)'); ylabel('proportion of samples'); 
title('CIR cumulative density function'); 
end

function [x,y] = hexagon(r, centerX, centerY) 
    % r ......... radius of the cell (meters) 
    % centerX ... X value of the center of the cell (meters) 
    % centerY ... Y value of the center of the cell (meters) 
    theta = 0:60:360; 
    x = r*cosd(theta) + centerX;     
    y = r*sind(theta) + centerY; 
end 

function [d] = distance(P1, P2)    
    % P1 ... first point (vector with X and Y values)    
    % P2 ... second point (vector with X and Y values)        
    d = sqrt((P1(1)-P2(1))^2 + (P1(2)-P2(2))^2);  
end 

function [frequency] = setFrequencyNextCell(cellI, cellJ, ki, kj, side, channel, frequency, hcells, vcells) 
switch side     
    case 1 % Up then right         
        newCellI = floor((((2*cellI - mod(cellJ,2)) + kj) - 1) / 2) + 1;         
        newCellJ = cellJ + 2*ki + kj;     
    case 2 % Right-up then right-down         
        newCellI = floor((((2*cellI - mod(cellJ,2)) + ki + kj) - 1) / 2) + 1;         
        newCellJ = cellJ + ki - kj;     
    case 3 % Right-down then down         
        newCellI = floor((((2*cellI - mod(cellJ,2)) + ki) - 1) / 2) + 1;         
        newCellJ = cellJ - ki - 2*kj;     
    case 4 % Down then left-down         
        newCellI = floor((((2*cellI - mod(cellJ,2)) - kj) - 1) / 2) + 1;         
        newCellJ = cellJ - 2*ki - kj;     
    case 5 % Left-down then left-up         
        newCellI = floor((((2*cellI - mod(cellJ,2)) - ki - kj) - 1) / 2) + 1;         
        newCellJ = cellJ - ki + kj;     
    case 6 % Left-up then up         
        newCellI = floor((((2*cellI - mod(cellJ,2)) - ki) - 1) / 2) + 1;         
        newCellJ = cellJ + ki + 2*kj; 
end 

% Check whether the cell is on the map and has not been visited yet 
if ((newCellI >= 1) && (newCellI <= hcells) && (newCellJ >= 1) && (newCellJ <= vcells) && (frequency(newCellI, newCellJ) == 0))     
    frequency(newCellI, newCellJ) = channel;     
    for j=1:6         
        % Call recursively this function with the 6 sides of the hexagon         
        frequency = setFrequencyNextCell(newCellI, newCellJ, ki, kj, j, channel, frequency, hcells, vcells);     
    end
end
end

function [pathloss] = pathloss_model(P1, P2, exponent)
    d = distance(P1, P2);
    d0 = 1;
    if d < d0
        d = d0;
    end
    pathloss = (d / d0)^exponent;
end
