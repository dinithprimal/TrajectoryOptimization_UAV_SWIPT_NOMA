function updatedPosition = positionUpdate_PSO(xUAV,yUAV,zUAV,minRat,noUsers,xUser,yUser,g)
    
    %rates = zeros(1,noUsers);
    
    %% Problem
    nVar = 2;
    varMin = [-500 -100];
    varMax = [500 200];
    
    %% PSO parameters
    
    kappa = 1;
    phi1 = 2.05;
    phi2 = 2.05;
    
    phi = phi1+phi2;
    
    chi = 2*kappa/abs(2-phi-sqrt(phi^2-4*phi));
    
    maxIter = 5000;
    nPop = 50;
    w = chi;
    d = 0.99;
    c1 = chi*phi1;
    c2 = chi*phi2;
    
    %% Initial
    x0.position = [];
    x0.velocity = [];
    x0.fitness = [];
    x0.best.position = [];
    x0.best.fitness = [];
    x = repmat(x0,nPop,1);
    global_best.fitness = -inf;
    minRate = minRat;
    % Generate initial population
    for i = 1:nPop
        % Generate random solutions
        for k = 1:nVar
            x(i).position(k) = unifrnd(varMin(k),varMax(k));
        end
        x(i).velocity = zeros([1 nVar]);    % Initial velocity
        [minZ, x(i).fitness] = objective_function_positionUpdate_3D(x(i).position,...
            xUAV,yUAV,zUAV,noUsers,xUser,yUser,minRate,g);
        
       if minZ > minRate
            minRate = minZ;
       end
        
        x(i).best.position = x(i).position;     % Update the local best
        x(i).best.fitness = x(i).fitness;       % Update the local best
        if x(i).best.fitness > global_best.fitness
            global_best = x(i).best;
        end
    end
    
    B = zeros(maxIter,1);   % save the best fitness in each iteration
    C = zeros(maxIter, nVar);
    %% Main Program
    for j = 1:maxIter
        for i = 1:nPop
            x(i).velocity = w*x(i).velocity + c1*rand([1, nVar]).*(x(i).best.position - x(i).position) + c2*rand([1 nVar]).*(global_best.position - x(i).position); % update velocity
            x(i).position = x(i).position + x(i).velocity;  % update position
            %check the range
            for k = 1:nVar
                if x(i).position(k) < varMin(k)
                    x(i).position(k) = varMin(k);
                end
                if x(i).position(k) > varMax(k)
                    x(i).position(k) = varMax(k);
                end
            end
            [minZ, x(i).fitness] = objective_function_positionUpdate_3D(x(i).position,...
                xUAV,yUAV,zUAV,noUsers,xUser,yUser,minRate,g);
            
           if minZ > minRate
                minRate = minZ;
           end
            
            if x(i).fitness > x(i).best.fitness
                x(i).best.position = x(i).position;
                x(i).best.fitness = x(i).fitness;
                if x(i).best.fitness > global_best.fitness
                    global_best = x(i).best;
                end
            end
        end
        w = w*d;        % update the damping ratio
        
        %save the best fitness
        B(j) = global_best.fitness;
        C(j,:) = global_best.position;
        %disp(['Iteration ' num2str(j) '; Best fitness = ' num2str(B(j)) '; Optimal solution = ' num2str(C(j,:))]);
        %figure;
           % plot(B(1:j,1),'r.'); hold on; drawnow
        
    end
    %% Output
    if(global_best.fitness == 0)
        global_best.position(1) = 0;
        global_best.position(2) = 0;
        %global_best.position(3) = 0;
    end
    updatedPosition = global_best;
    updatedPosition.minRate = minRate
end