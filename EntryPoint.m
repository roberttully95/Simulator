beep off
addpath(genpath("src"))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the simulation file to be used.
simFile = "test_02-04-21_1.json";

% Create shortest path simulation
sp = ShortestPathSimulator(simFile);
sp.plotMap(gca);

% Create wavefront simulation
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