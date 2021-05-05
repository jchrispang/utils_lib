function out_temp = manual_datafetching_from_cluster(job, num_outputs, location)
% cd /working/matlab/jamesPa/jobs/JobXXX
% cp -f *.out.mat ~/LabData/Lab_JamesR/jamesPa/matlab_temp/JobXXX
% OR
% job=338; cp -f /working/matlab/jamesPa/jobs/"Job${job}"/*.out.mat ~/LabData/Lab_JamesR/jamesPa/matlab_temp/"Job${job}"

if nargin<3
    location = 'cluster';
end

matlab_dir = 'L:/Lab_JamesR/jamesPa/matlab_temp';

if strcmpi(location, 'cluster')
    job_dir = sprintf('%s/Job%i', matlab_dir, job);
elseif strcmpi(location, 'local')
    job_dir = sprintf('%s/LocalJob%i', matlab_dir, job);
end
num_tasks = numel(dir([job_dir, '/Task*.mat']));

out_temp = cell(num_tasks, num_outputs);
for task_id = 1:num_tasks
    task_id
    task_output = load(sprintf('%s/Task%i.out.mat', job_dir, task_id));
    out_temp(task_id,:) = task_output.argsout;
end
    
    



