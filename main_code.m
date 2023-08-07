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
        plot3([xUAV(i) xBS(directBS)], [yUAV(i) yBS(directBS)],[zUAV(i) zBS(directBS)], bsColorCodeLine(directBS,:),'linewidth', 1.5); drawnow
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
    plot3([xUAV_S(i) xUAV_E(i)], [yUAV_S(i) yUAV_E(i)],[zUAV_S(i) zUAV_E(i)], '--', 'Color', '#660000' ,'linewidth', 1); drawnow
end

mx = (zUAV_S - zUAV_E)/(yUAV_S - yUAV_E);
c = zUAV_S - mx*yUAV_S;

% 3D Plot labels
xlim([0 2050])
ylim([0 2050])
zlim([0 320])
xlabel('Width (m)');
ylabel('Length (m)');
zlabel('Height (m)');
grid on; hold on; drawnow

%% Information for path loss model

eta = 2.5;              % Path Loss Component
b_0dB = -50;            % Reference Channel Gain in dB
b_0 = db2pow(b_0dB);    % Reference Channel Gain in linear scale
k = 0.01;               % Additional attenuation for NLoS

%% Infromation for Rician Fading Model

% Rician factor
K_min = 4;      % K_min value in dB
K_max = 12;     % K_max value in dB

A1 = db2pow(K_min);
A2 = (2/pi)*log((db2pow(K_max))/A1);

%N = 10^5;
g = sqrt(1/2)*(randn(1,1)+1i*randn(1,1));


%% Simulation
index = 1;
for j = enLength:-10:0
    for i=1:noUAV
        zUAV(i) = mx*j + c;
        yUAV(i) = j;
        plot3(xUAV(i),  yUAV(i),  zUAV(i), '+','Color','#660000','linewidth', 1);hold on;

        
        for bm=1:noBS
            % LoS distance between UAVs and BSs
            groundDisUAV_BS(i,bm) = sqrt((xUAV(i)-xBS(bm))^2 + (yUAV(i)-yBS(bm))^2);
            DisUAV_BS(i,bm) = sqrt(groundDisUAV_BS(i,bm)^2 + (zBS(bm)-zUAV(i))^2);
            
            % Elavation Angle in radiant between UAVs and Users
            angleUAV_BS(i,bm) = atan(abs(zBS(bm)-zUAV(i))/groundDisUAV_BS(i,bm))*(180/pi);
            
            PLoS_BS(index,i,bm) = 1/(1+(10*exp(-0.6*(angleUAV_BS(i,bm)-10))));
            
            pow_LoS_BS = b_0*(DisUAV_BS(i,bm)^(-eta));
            
            
            % Angle depend rician factor
            K_UAV_BS(i,bm) = A1*exp(A2*angleUAV_BS(i,bm)*(pi/180));
            
            g_UAV_BS(i,bm) = sqrt(K_UAV_BS(i,bm)/(1+K_UAV_BS(i,bm)))*g + sqrt(1/(1+K_UAV_BS(i,bm)))*g;
            
            h_UAV_BS(index,i,bm) = sqrt(pow_LoS_BS)*g_UAV_BS(i,bm);
            
            h_UAV_BS_dB(index,i,bm) = pow2db(abs(h_UAV_BS(index,i,bm))^2);
            
        end
        
        
        for m=1:noUsers
            % LoS distance between UAVs and Users
            groundDisUAV_User(i,m) = sqrt((xUAV(i)-xUser(m))^2 + (yUAV(i)-yUser(m))^2);
            DisUAV_User(i,m) = sqrt(groundDisUAV_User(i,m)^2 + zUAV(i)^2);
            
            % Elavation Angle in radiant between UAVs and Users
            angleUAV_User(i,m) = atan(zUAV(i)/groundDisUAV_User(i,m))*(180/pi);
            
            
            PLoS(index,i,m) = 1/(1+(10*exp(-0.6*(angleUAV_User(i,m)-10))));
            
            pow_LoS = b_0*(DisUAV_User(i,m)^(-eta));
            
            
            % Angle depend rician factor
            K_UAV_User(i,m) = A1*exp(A2*angleUAV_User(i,m)*(pi/180));
            
            g_UAV_User(i,m) = sqrt(K_UAV_User(i,m)/(1+K_UAV_User(i,m)))*g + sqrt(1/(1+K_UAV_User(i,m)))*g;
            
            h_UAV_Users(index,i,m) = sqrt(pow_LoS)*g_UAV_User(i,m);
            
            h_UAV_Users_dB(index,i,m) = pow2db(abs(h_UAV_Users(index,i,m))^2);
           
        end
        
        % Power coefficeints calculation for users
        pow_coef_array_ch(index,:) = findPowCoeff(abs(h_UAV_Users(index,i,:)),noUsers);
        
        % Achievable Rate Calculations for Users
        achievableRate_ch(index,:) = findAchievableRate(h_UAV_Users(index,i,:),pow_coef_array_ch(index,:),noUsers);
        
        % Achievable Rate Calculations for BSs
        %achievableRate_BS(index,:) = findAchievableRate_BS(h_UAV_BS(index,i,:),noBS);
        
        % Achievable Rate Calculations for Users in SWIPT model
        achievableRate_ch_SWIPT(index,:) = findAchievableRate_SWIPT(h_UAV_Users(index,i,:),h_UAV_BS(index,i,:),pow_coef_array_ch(index,:),noUsers);
        
        minRate = min(achievableRate_ch(index,:))
        if index>1 && index<201
            updatedPosition = positionUpdate_PSO(xUAV(i),yUAV(i),zUAV(i),minRate,noUsers,xUser,yUser,g);
            up_xUAV(index,i) = xUAV(i) + updatedPosition.position(1);
            up_zUAV(index,i) = zUAV(i) + updatedPosition.position(2);
            up_yUAV(index,i) = yUAV(i);
        else
            up_xUAV(index,i) = xUAV(i);
            up_yUAV(index,i) = yUAV(i);
            up_zUAV(index,i) = zUAV(i);
        end
        plot3(up_xUAV(index,i),  up_yUAV(index,i),  up_zUAV(index,i), 'gh','linewidth', 0.5);hold on;
        
        if index>1 
            plot3([up_xUAV(index-1,i) up_xUAV(index,i)], [up_yUAV(index-1,i) up_yUAV(index,i)],[up_zUAV(index-1,i) up_zUAV(index,i)], 'g--','linewidth', 0.5); drawnow
        end
       % updatedPosition.minRate
        % LoS distance between UAVs and BSs
        for bm=1:noBS
            groundDisUAV_BS_Up(i,bm) = sqrt((up_xUAV(index,i)-xBS(bm))^2 + (up_yUAV(index,i)-yBS(bm))^2);
            DisUAV_BS_Up(i,bm) = sqrt(groundDisUAV_BS_Up(i,bm)^2 + (zBS(bm)-up_zUAV(index,i))^2);
            
            % Elavation Angle in radiant between UAVs and Users
            angleUAV_BS_Up(i,bm) = atan(abs(zBS(bm)-up_zUAV(index,i))/groundDisUAV_BS_Up(i,bm))*(180/pi);
            
            PLoS_BS_Up(index,i,bm) = 1/(1+(10*exp(-0.6*(angleUAV_BS_Up(i,bm)-10))));
            
            pow_LoS_BS_Up = b_0*(DisUAV_BS_Up(i,bm)^(-eta));
            pow_NLoS_BS_Up = k*b_0*(DisUAV_BS_Up(i,bm)^(-eta));
            Ch_pow_LoS_BS_Up(index,i,bm) = pow2db(pow_LoS_BS_Up); 
            Ch_pow_NLoS_BS_Up(index,i,bm) = pow2db(pow_NLoS_BS_Up);
            
            % Expected Path Loss Channel gain
            E_bd_BS_Up = PLoS_BS_Up(index,i,bm)*pow_LoS_BS_Up + (1 - PLoS_BS_Up(index,i,bm))*pow_NLoS_BS_Up;
            E_bd_dB_BS_Up(index,i,bm) = pow2db(E_bd_BS_Up); % in dB
            
            % Angle depend rician factor
            K_UAV_BS_Up(i,bm) = A1*exp(A2*angleUAV_BS_Up(i,bm)*(pi/180));
            
            g_UAV_BS_Up(i,bm) = sqrt(K_UAV_BS_Up(i,bm)/(1+K_UAV_BS_Up(i,bm)))*g + sqrt(1/(1+K_UAV_BS_Up(i,bm)))*g;
            
            h_UAV_BS_Up(index,i,bm) = sqrt(pow_LoS_BS_Up)*g_UAV_BS_Up(i,bm);
            
            h_UAV_BS_dB_Up(index,i,bm) = pow2db(abs(h_UAV_BS_Up(index,i,bm))^2);
            
        end
        
        % LoS distance between UAVs and Users
        for m=1:noUsers
            groundDisUAV_User_Up(i,m) = sqrt((up_xUAV(index,i)-xUser(m))^2 + (up_yUAV(index,i)-yUser(m))^2);
            DisUAV_User_Up(i,m) = sqrt(groundDisUAV_User_Up(i,m)^2 + up_zUAV(index,i)^2);
            
            % Elavation Angle in radiant between UAVs and Users
            angleUAV_User_Up(i,m) = atan(up_zUAV(index,i)/groundDisUAV_User_Up(i,m))*(180/pi);
            
            
            PLoS_Up(index,i,m) = 1/(1+(10*exp(-0.6*(angleUAV_User_Up(i,m)-10))));
            
            pow_LoS_Up = b_0*(DisUAV_User_Up(i,m)^(-eta));
            pow_NLoS_Up = k*b_0*(DisUAV_User_Up(i,m)^(-eta));
            Ch_pow_LoS_Up(index,i,m) = pow2db(pow_LoS_Up); 
            Ch_pow_NLoS_Up(index,i,m) = pow2db(pow_NLoS_Up);
            
            % Expected Path Loss Channel gain
            E_bd_Up = PLoS_Up(index,i,m)*pow_LoS_Up + (1 - PLoS_Up(index,i,m))*pow_NLoS_Up;
            E_bd_dB_Up(index,i,m) = pow2db(E_bd_Up); % in dB
            
            
            % Angle depend rician factor
            K_UAV_User_Up(i,m) = A1*exp(A2*angleUAV_User_Up(i,m)*(pi/180));
            
            g_UAV_User_Up(i,m) = sqrt(K_UAV_User_Up(i,m)/(1+K_UAV_User_Up(i,m)))*g + sqrt(1/(1+K_UAV_User_Up(i,m)))*g;
            
            h_UAV_Users_Up(index,i,m) = sqrt(pow_LoS_Up)*g_UAV_User_Up(i,m);
            
            h_UAV_Users_dB_Up(index,i,m) = pow2db(abs(h_UAV_Users_Up(index,i,m))^2);
           
        end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         minRate_SWIPT = min(achievableRate_ch_SWIPT(index,:))
%         if index>1 && index<21
%             updatedPosition_SWIPT = positionUpdate_PSO_SWIPT(xUAV(i),yUAV(i),zUAV(i),xBS,yBS,zBS,minRate,noUsers,xUser,yUser,g,noBS);
%             up_xUAV_SWIPT(index,i) = xUAV(i) + updatedPosition_SWIPT.position(1);
%             up_zUAV_SWIPT(index,i) = zUAV(i) + updatedPosition_SWIPT.position(2);
%             up_yUAV_SWIPT(index,i) = yUAV(i);
%         else
%             up_xUAV_SWIPT(index,i) = xUAV(i);
%             up_yUAV_SWIPT(index,i) = yUAV(i);
%             up_zUAV_SWIPT(index,i) = zUAV(i);
%         end
%         plot3(up_xUAV_SWIPT(index,i),  up_yUAV_SWIPT(index,i),  up_zUAV_SWIPT(index,i), 'gp','linewidth', 0.5);hold on;
%         
%         if index>1 
%             plot3([up_xUAV_SWIPT(index-1,i) up_xUAV_SWIPT(index,i)], [up_yUAV_SWIPT(index-1,i) up_yUAV_SWIPT(index,i)],[up_zUAV_SWIPT(index-1,i) up_zUAV_SWIPT(index,i)], 'm--','linewidth', 0.5); drawnow
%         end
%        % updatedPosition.minRate
%         % LoS distance between UAVs and BSs
%         for bm=1:noBS
%             groundDisUAV_BS_Up_SWIPT(i,bm) = sqrt((up_xUAV_SWIPT(index,i)-xBS(bm))^2 + (up_yUAV_SWIPT(index,i)-yBS(bm))^2);
%             DisUAV_BS_Up_SWIPT(i,bm) = sqrt(groundDisUAV_BS_Up_SWIPT(i,bm)^2 + (zBS(bm)-up_zUAV_SWIPT(index,i))^2);
%             
%             % Elavation Angle in radiant between UAVs and Users
%             angleUAV_BS_Up_SWIPT(i,bm) = atan(abs(zBS(bm)-up_zUAV_SWIPT(index,i))/groundDisUAV_BS_Up_SWIPT(i,bm))*(180/pi);
%             
%             PLoS_BS_Up_SWIPT(index,i,bm) = 1/(1+(10*exp(-0.6*(angleUAV_BS_Up_SWIPT(i,bm)-10))));
%             
%             pow_LoS_BS_Up_SWIPT = b_0*(DisUAV_BS_Up_SWIPT(i,bm)^(-eta));
%             pow_NLoS_BS_Up_SWIPT = k*b_0*(DisUAV_BS_Up_SWIPT(i,bm)^(-eta));
%             Ch_pow_LoS_BS_Up_SWIPT(index,i,bm) = pow2db(pow_LoS_BS_Up_SWIPT); 
%             Ch_pow_NLoS_BS_Up_SWIPT(index,i,bm) = pow2db(pow_NLoS_BS_Up_SWIPT);
%             
%             % Expected Path Loss Channel gain
%             E_bd_BS_Up_SWIPT = PLoS_BS_Up_SWIPT(index,i,bm)*pow_LoS_BS_Up_SWIPT + (1 - PLoS_BS_Up_SWIPT(index,i,bm))*pow_NLoS_BS_Up_SWIPT;
%             E_bd_dB_BS_Up_SWIPT(index,i,bm) = pow2db(E_bd_BS_Up_SWIPT); % in dB
%             
%             % Angle depend rician factor
%             K_UAV_BS_Up_SWIPT(i,bm) = A1*exp(A2*angleUAV_BS_Up_SWIPT(i,bm)*(pi/180));
%             
%             g_UAV_BS_Up_SWIPT(i,bm) = sqrt(K_UAV_BS_Up_SWIPT(i,bm)/(1+K_UAV_BS_Up_SWIPT(i,bm)))*g + sqrt(1/(1+K_UAV_BS_Up_SWIPT(i,bm)))*g;
%             
%             h_UAV_BS_Up_SWIPT(index,i,bm) = sqrt(pow_LoS_BS_Up_SWIPT)*g_UAV_BS_Up_SWIPT(i,bm);
%             
%             h_UAV_BS_dB_Up_SWIPT(index,i,bm) = pow2db(abs(h_UAV_BS_Up_SWIPT(index,i,bm))^2);
%             
%         end
%         
%         % LoS distance between UAVs and Users
%         for m=1:noUsers
%             groundDisUAV_User_Up_SWIPT(i,m) = sqrt((up_xUAV_SWIPT(index,i)-xUser(m))^2 + (up_yUAV_SWIPT(index,i)-yUser(m))^2);
%             DisUAV_User_Up_SWIPT(i,m) = sqrt(groundDisUAV_User_Up_SWIPT(i,m)^2 + up_zUAV_SWIPT(index,i)^2);
%             
%             % Elavation Angle in radiant between UAVs and Users
%             angleUAV_User_Up_SWIPT(i,m) = atan(up_zUAV_SWIPT(index,i)/groundDisUAV_User_Up_SWIPT(i,m))*(180/pi);
%             
%             
%             PLoS_Up_SWIPT(index,i,m) = 1/(1+(10*exp(-0.6*(angleUAV_User_Up_SWIPT(i,m)-10))));
%             
%             pow_LoS_Up_SWIPT = b_0*(DisUAV_User_Up_SWIPT(i,m)^(-eta));
%             pow_NLoS_Up_SWIPT = k*b_0*(DisUAV_User_Up_SWIPT(i,m)^(-eta));
%             Ch_pow_LoS_Up_SWIPT(index,i,m) = pow2db(pow_LoS_Up_SWIPT); 
%             Ch_pow_NLoS_Up_SWIPT(index,i,m) = pow2db(pow_NLoS_Up_SWIPT);
%             
%             % Expected Path Loss Channel gain
%             E_bd_Up_SWIPT = PLoS_Up_SWIPT(index,i,m)*pow_LoS_Up_SWIPT + (1 - PLoS_Up_SWIPT(index,i,m))*pow_NLoS_Up_SWIPT;
%             E_bd_dB_Up_SWIPT(index,i,m) = pow2db(E_bd_Up_SWIPT); % in dB
%             
%             
%             % Angle depend rician factor
%             K_UAV_User_Up_SWIPT(i,m) = A1*exp(A2*angleUAV_User_Up_SWIPT(i,m)*(pi/180));
%             
%             g_UAV_User_Up_SWIPT(i,m) = sqrt(K_UAV_User_Up_SWIPT(i,m)/(1+K_UAV_User_Up_SWIPT(i,m)))*g + sqrt(1/(1+K_UAV_User_Up_SWIPT(i,m)))*g;
%             
%             h_UAV_Users_Up_SWIPT(index,i,m) = sqrt(pow_LoS_Up_SWIPT)*g_UAV_User_Up_SWIPT(i,m);
%             
%             h_UAV_Users_dB_Up_SWIPT(index,i,m) = pow2db(abs(h_UAV_Users_Up_SWIPT(index,i,m))^2);
%            
%         end
% 
%         
%         
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Power coefficeints calculation for users
        pow_coef_array_ch_Up(index,:) = findPowCoeff(abs(h_UAV_Users_Up(index,i,:)),noUsers);
        
        % Achievable Rate Calculations for Users
        achievableRate_ch_Up(index,:)= findAchievableRate(h_UAV_Users_Up(index,i,:),pow_coef_array_ch_Up(index,:),noUsers);
        
        % Achievable Rate Calculations for BSs
        achievableRate_BS_Up(index,:) = findAchievableRate_BS(h_UAV_BS_Up(index,i,:),noBS);
        
        % Achievable Rate Calculations for Users in SWIPT model
        achievableRate_ch_SWIPT_Up(index,:) = findAchievableRate_SWIPT(h_UAV_Users_Up(index,i,:),h_UAV_BS_Up(index,i,:),pow_coef_array_ch_Up(index,:),noUsers);
        
        minAchRate(index) = min(achievableRate_ch(index,:));
        minAchRate_Up(index) = min(achievableRate_ch_Up(index,:));
        
        minAchRate_SWIPT(index) = min(achievableRate_ch_SWIPT(index,:));
        minAchRate_Up_SWIPT(index) = min(achievableRate_ch_SWIPT_Up(index,:));
        
        
%     
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         % Power coefficeints calculation for users
%         [pow_coef_array_ch_Up_SWIPT(index,:), pow_coef_array_fr_Up_SWIPT(index,:)] = findPowCoeff(abs(h_UAV_Users_Up_SWIPT(index,i,:)),noUsers);
%         
%         % Achievable Rate Calculations for Users
%         %[achievableRate_ch_Up_SWIPT(index,:), achievableRate_fr_Up_SWIPT(index,:)] = findAchievableRate(h_UAV_Users_Up_SWIPT(index,i,:),pow_coef_array_ch_Up_SWIPT(index,:),pow_coef_array_fr_Up_SWIPT(index,:),noUsers);
%         
%         % Achievable Rate Calculations for BSs
%         %achievableRate_BS_Up_SWIPT(index,:) = findAchievableRate_BS(h_UAV_BS_Up_SWIPT(index,i,:),noBS);
%         
%         % Achievable Rate Calculations for Users in SWIPT model
%         [achievableRate_ch_SWIPT_Up(index,:), achievableRate_fr_SWIPT_Up(index,:)] = findAchievableRate_SWIPT(h_UAV_Users_Up_SWIPT(index,i,:),h_UAV_BS_Up_SWIPT(index,i,:),pow_coef_array_ch_Up_SWIPT(index,:),pow_coef_array_fr_Up_SWIPT(index,:),noUsers);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         minAchRate_SWIPT(index) = min(achievableRate_ch_SWIPT(index,:));
%         minAchRate_Up_SWIPT(index) = min(achievableRate_ch_SWIPT_Up(index,:));
%         
        
    end
    index = index +1;
end



