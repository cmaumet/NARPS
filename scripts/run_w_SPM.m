function run_w_SPM()

    config()
    
    % Repetition time in seconds
    TR = 1;
    
    raw_dir

    spm_out_dir = fullfile(output_dir, 'SPM');
    if ~isdir(spm_out_dir)
        mkdir(spm_out_dir) 
    end
    
    preproc_dir = fullfile(spm_out_dir, 'preproc');
    level1_dir = fullfile(spm_out_dir, 'level1');
    level2_dir = fullfile(spm_out_dir, 'level2');
    level3_dir = fullfile(spm_out_dir, 'level3');

    
    % TODO specify dummy scans
    % Specify the number of functional volumes ignored in the study
    num_ignored_volumes = 0;
    
    % Specify the TR that will be removed from onsets, equal to num_ignored_volumes*TR
    removed_TR_time = num_ignored_volumes*TR;
    
    % Add 'lib' folder to the matlab path
    if ~exist('copy_gunzip', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
        addpath(fullfile(fileparts(mfilename('fullpath')), 'templates'))
    end

    subject_ids = {}; %{'sub-001'} %, 'sub-002'} %, ...
%         'sub-003', 'sub-004', 'sub-005'});
    if isempty(subject_ids)
        fmriprep_sub_dirs = cellstr(spm_select('FPList', fmriprep_dir, 'dir', 'sub-*'));
        raw_sub_dirs = cellstr(spm_select('FPList', raw_dir, 'dir', 'sub-*'));
        
    else
        % Select only subjects of interest
        fmriprep_sub_dirs = cell(length(subject_ids),1);
        raw_sub_dirs = cell(length(subject_ids),1);
        for i = 1:length(subject_ids)
            fmriprep_sub_dirs(i,1) = cellstr(...
                spm_select('FPList', fmriprep_dir, 'dir', subject_ids(i)));
            raw_sub_dirs(i,1) = cellstr(...
                spm_select('FPList', raw_dir, 'dir', subject_ids(i)));
        end
    end
    sub_names = spm_file(raw_sub_dirs, 'basename');
    
    copy_gunzip(fmriprep_sub_dirs, preproc_dir)
    
    % Directory to store the onset files
    onset_dir = fullfile(spm_out_dir, 'onsets');

    % Define conditions and parametric modulations (if any)
    % FORMAT
    %   {VariableLabel,{TrialType,Durations}}
    %   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
    %  
    conditions = {...
            {{'gamble','gain_param', 'loss_param', 'RT_param'}, {'onset', 'duration', 'gain', 'loss', 'RT'}},...
        };
    create_onset_files(onset_dir, conditions, removed_TR_time, raw_sub_dirs);
    run_smoothing(raw_sub_dirs, preproc_dir, 'SPM_preproc_template');
    run_subject_level_analyses(sub_names, preproc_dir, 'SPM_level1_template', level1_dir, num_ignored_volumes, TR);
    run_group_level_analysis(level1_dir, 'SPM_level2_template', level2_dir, '0001');
    % run_permutation_test(level1_dir, 'template_ds001_SPM_perm_test', perm_dir, '0001');
    % mean_mni_images(preproc_dir, level1_dir, mni_dir);
end
