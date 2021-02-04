beep off
addpath(genpath("src"))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the simulation file to be used.
simFile = "test_02-01-21_1.json";

% Create simulation
sp = WavefrontSimulator(simFile, [100, 100]);
sp.plotMap(gca);

%{
while ~sp.isFinished()
    sp.propogate();
    sp.plotVehicles(gca);
end
%}

disp('Finished')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%