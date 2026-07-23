function [cir, noIterations, utilityPerIteration] = channelallocation(noCells, hlength, vlength, k, exponent, deltaX, deltaY, seed1, seed2, bPlay)

% MAX and MIN values for CIR figures (not used in calculations)
maxCIRdB = 30; % dB
minCIRdB = -10; % dB

% Random number generator for the initial frequency assignment
rng(seed1);

% Position of the center of the cells
% *** COMPUTE THE RANDOM LOCATION OF CELL i HERE, IN cellsX(i) and cellsY(i) ***

% Initial random frequency assignment
% *** COMPUTE THE INITIAL RANDOM FREQUENCY ASSIGNMENT HERE. THE FREQUENCY OF CELL i SHALL BE
% SAVED IN frequency(i) ***

% Game theoretical solution
% Gain matrix
gainMatrix = zeros(noCells,noCells);
for i=1:noCells 
    for j=1:noCells
        % *** COMPUTE THE GAIN MATRIX (GAIN = 1 / PATHLOSS) HERE. THE GAIN BETWEEN CELLS i AND
        % j SHALL BE SAVED IN gainMatrix(i,j) AND gainMatrix(j,i) ***
    end
end


% Initial utility
utilityPerIteration(1) = aggregateUtility(gainMatrix, frequency);
% Game
noIterations = 0;
if (bPlay)
    % Random number generator for the game
    rng(seed2);
    finished = false;
    while (~finished)
        noChanges = 0;
        % Update cell utility 
        for i=1:noCells
            % All possible utilities for each frequency selection
            util = utilities(gainMatrix, frequency, k, i);
            % Select the frequency that maximizes the cell utility
            bestFrequency = find(util == max(util));
            bestFrequency = bestFrequency(1); % Just in case there were two frequencies with
            % same max utility
            if (frequency(i) ~= bestFrequency)
                frequency(i) = bestFrequency;
                noChanges = noChanges + 1;
            end
        end
        % Test whether there has been any change (then continue) or not (game has finished)
        if (noChanges > 0)
            noIterations = noIterations + 1;
            utilityPerIteration(noIterations+1) = aggregateUtility(gainMatrix, frequency);
        else
            finished = true;
        end
    end
end

% Figure with frequency assignments
figure; hold on;
plot (cellsX, cellsY, '+k');
hcolor=colormap(hsv(k));
for i=1:noCells 
    % Plot cells
    textOffset = 1;
    text(cellsX(i) + textOffset*deltaX, cellsY(i), num2str(frequency(i)), 'FontSize', 8, 'Color', hcolor(frequency(i),:));
end
xlabel('X position (meters)'); ylabel('Y position (meters)');
title('Cell locations and frequencies');
cb1=colorbar;
set(get(cb1,'ylabel'),'String', 'frequency');
maxX = hlength;
maxY = vlength;
axis ([0 maxX 0 maxY]);

% Calculate pathloss values
maxX2 = ceil(maxX/deltaX);
maxY2 = ceil(maxY/deltaY);
pathloss = zeros(noCells, maxX2, maxY2);
% Loop for cells
for i=1:noCells
    % Loops for X and Y
    for x=1:maxX2
        for y=1:maxY2
            % Pathloss between the cell and the point (x*deltaX, y*deltaY)
            %pathloss(i, x, y) = pathloss_model(...);
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
        cellsWithSameFrequency = cellsWithSameFrequency(find(cellsWithSameFrequency ~= predominantCell));
       
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
figure; set(gcf, 'renderer', painters');
colormap jet;
pcolor((1:maxX2)*deltaX, (1:maxY2)*deltaY, limitedCIRdB');
shading(gca, 'interp'); cb2=colorbar;
set(get(cb2,'ylabel'),'String', 'CIR (dB)');

xlabel('X position (meters)'); ylabel('Y position (meters)');
title('Carrier to Interference Ratio (CIR)');

% Utility for each iteration
figure;
maxUtility = -sum(sum(triu(gainMatrix,1)));
plot(1:(noIterations+1), utilityPerIteration/abs(maxUtility), 'b*-');
grid on; xlabel('iteration number'); ylabel ('utility');
title('Normalized aggregate utility');

% CIR histogram (probability density function)
figure;
cirdBsamples = cirdB(:); % All points within the area
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


function [util] = utilities(gainMatrix, frequency, k, cell)
util = zeros(1,k);
for i=1:k
    % Cells using frequency i
    cellsWithSameFrequency = find(frequency == i);
    % Removing selected cell
    
    utility = 0;
    for j=1:length(cellsWithSameFrequency)
        % The utility is proportional to the propagation gain between the
        % selected cell and other cells using the same frequency (assuming
        % that each cell has the same transmission power)
        utility = utility - gainMatrix(cell,cellsWithSameFrequency(j));
    end
    util(i) = utility;
end
end

function [util] = aggregateUtility(gainMatrix, frequency)
noCells = length(frequency);
aggregateUtility = 0;
for i=1:noCells
    currentFrequency = frequency(i);
    % Cells using the same frequency
    cellsWithSameFrequency = find(frequency == currentFrequency);
    % Removing cells that have been already considered
    cellsWithSameFrequency = cellsWithSameFrequency(find(cellsWithSameFrequency > i));
    
    % The utility is proportional to the propagation gain between the
    % selected cell and other cells using the same frequency (assuming
    % that each cell has the same transmission power)
    utility = 0;
    for j=1:length(cellsWithSameFrequency)
        % The utility is proportional to the propagation gain between the
        % selected cell and other cells using the same frequency (assuming
        % that each cell has the same transmission power)
        utility = utility - gainMatrix(i,cellsWithSameFrequency(j));
    end
    aggregateUtility = aggregateUtility + utility;
end

util = aggregateUtility;
end


function [pathloss] = pathloss_model(...)
% *** IMPLEMENTATION OF THE PATHLOSS MODEL ***
end