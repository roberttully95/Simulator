beep off
addpath(genpath("src"))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the simulation file to be used.
simFile = "classic_02-06-21_1.json";

% Run triangulation simulation
tri = TriangulationSimulator(simFile, gca);
while ~tri.isFinished()
   tri.propogate();
   pause(1e-6)
end

% Run shortest path simulation
sp = ShortestPathSimulator(simFile);
while ~sp.isFinished()
    sp.propogate();
    pause(1e-6);
end

% Plot the normal distributions of the distances travelled
%subplot(1, 2, 1);
[triMu, triStd] = normDist(tri.getDistances(), 'r');
%subplot(1, 2, 2);
[spMu, spStd] = normDist(sp.getDistances(), 'b');

tri.getDistances()'

disp('Finished')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%