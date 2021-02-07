beep off
addpath(genpath("src"))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the simulation file to be used.
simFile = "classic_02-06-21_1.json";

% Create shortest path simulation
subplot(1, 2, 1)
sp = TriangulationSimulator(simFile);
sp.plotMap(gca);

% Create wavefront simulation
subplot(1, 2, 2)
wv = WavefrontSimulator(simFile, [100, 100]);
wv.plotMap(gca);

%{
while ~sp.isFinished()
    sp.propogate();
    sp.plotVehicles(gca);
end
%}

disp('Finished')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%