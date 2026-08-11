
% Report the number of Slurm cores
fprintf('Number of CPU cores in the Slurm job: %s\n', getenv('SLURM_CPUS_PER_TASK'));

% Save 4 cores for apptainer threads
poolobj = parpool(str2double(getenv('SLURM_CPUS_PER_TASK')) - 4);

fprintf('Number of workers: %g\n', poolobj.NumWorkers);

tic
n = 200;
A = 500;
a = zeros(n);
parfor i = 1:n
    a(i) = max(abs(eig(rand(A))));
end
toc
quit;
