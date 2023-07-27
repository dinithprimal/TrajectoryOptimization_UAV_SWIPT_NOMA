clc;
clear variables;
close all;

%% Simulation Environment

enWidth = 2000;             % Simulation Environment Width (X axis)
enLength = 2000;            % Simulation Environment Length (Y axis)
enHeight = 320;             % Simulation Environment Height (Z axis)
maxHeighUAV = 300;          % Maximum Height of UAV
minHeighUAV = 50;           % Minimum Height of UAV
noUsers = 3;                % Number of Users
noBS = 3;                   % Number of Base Sations
noUAV = 1;                  % Number of UAVs

%% Ground Users, Base Stations and UAV Positions


for i=1:noUAV
    % UAV Start Position
    xUAV_S(i) = 1000;       % UAV start position in X axis
    yUAV_S(i) = enLength;   % UAV start position in Y axis
    zUAV_S(i) = 200;        % UAV start position in Z axis
    
    % UAV End Position
    xUAV_E(i) = 1000;       % UAV end position in X axis
    yUAV_E(i) = 0;          % UAV end position in Y axis
    zUAV_E(i) = 200;        % UAV end position in Z axis
end

% Initialization of UAV moving positions
for i=1:noUAV
    xUAV(i) = 1000;         % UAV position in X axis
    yUAV(i) = enLength;     % UAV position in Y axis
    zUAV(i) = zUAV_S(i);    % UAV position in Z axis
end

% BS positions in the environment
xBS = [2000,0,2000];        % BSs positions in X axis
yBS = [2000,1000,0];        % BSs positions in Y axis
zBS = [20, 30, 25];         % BSs positions in Z axis

% Ground Users' posision
for i=1:noUsers
    xUser(i) = randi([enWidth/4, 3*enWidth/4]);     % User position in X axis
    yUser(i) = randi([enLength/4, 3*enLength/4]);   % User position in Y axis
    zUser(i) = 0;                                   % User position in Z axis = 0
end

%% Figure plot in Initialization of Environment


% Ground User plotting
figure,
%userPlot = plot3(xUser,yUser,zUser,'k*','linewidth',3); hold on;
userColorCode = ['m*';'g*';'b*'];
for o=1:noUsers
    userPlot(o) = plot3(xUser(o),yUser(o),zUser(o),userColorCode(o,:),'linewidth',3); 
    hold on;
end
for o=1:noUsers
    textUsers(o) = text(xUser(o)-10,yUser(o)-10,zUser(o)+10,['U',num2str(o)],'FontSize', 12);
    %textUsAngle(o) = text(xUser(o)+10,yUser(o)+10,['U_{\theta_{',num2str(o),'}}'],'FontSize', 12);
end

% UAVs Plotting
uavColorCode = ['kh'];
for o=1:noUAV
    plot3(xUAV_S(o), yUAV_S(o), zUAV_S(o), uavColorCode(o,:),'linewidth', 3);
end
for o=1:noUAV
    text(xUAV_S(o) + 20, yUAV_S(o) + 10, zUAV_S(o) + 10,['UAV',num2str(o),' Start Position'],'FontSize', 12);
end

for o=1:noUAV
    plot3(xUAV_E(o), yUAV_E(o), zUAV_E(o), uavColorCode(o,:),'linewidth', 3);
end
for o=1:noUAV
    text(xUAV_E(o) + 20, yUAV_E(o) + 10, zUAV_E(o) + 10,['UAV',num2str(o),' End Position']);
end

% BSs Plotting
bsColorCode = ['c^';'r^';'y^'];
for o=1:noBS
    plot3(xBS(o), yBS(o), zBS(o), bsColorCode(o,:),'linewidth', 3);
end
for o=1:noBS
    plot3([xBS(o) xBS(o)], [yBS(o) yBS(o)],[zBS(o) 0], 'k-','linewidth', 1); drawnow
    text(xBS(o) + 20, yBS(o) + 10, zBS(o) - 10,['BS', num2str(o)],'FontSize', 12);
end

% Plotting LoS Channel between BSs and UAVs
bsColorCodeLine = ['c:';'r:';'y:'];
for i = 1:noUAV
    for directBS = 1:noBS
        plot3([xUAV(i) xBS(directBS)], [yUAV(i) yBS(directBS)],[zUAV(i) zBS(directBS)], bsColorCodeLine(directBS,:),'linewidth', 1); drawnow
    end
end

% Plotting LoS Channel between users and UAVs
userColorCodeLine = ['m-.';'g-.';'b-.'];
for i = 1:noUAV
    for directUsers = 1:noUsers
        plot3([xUAV(i) xUser(directUsers)], [yUAV(i) yUser(directUsers)],[zUAV(i) zUser(directUsers)], userColorCodeLine(directUsers,:),'linewidth', 1); drawnow
    end
end

% Plotting UAV default path
for i = 1:noUAV
    plot3([xUAV_S(i) xUAV_E(i)], [yUAV_S(i) yUAV_E(i)],[zUAV_S(i) zUAV_E(i)], 'y--','linewidth', 0.5); drawnow
end


