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
    end
    
    copy_gunzip(fmriprep_dir, preproc_dir, {'sub-001', 'sub-002'}) %, ...
%         'sub-003', 'sub-004', 'sub-005'});
    
    % Directory to store the onset files
    onset_dir = fullfile(spm_out_dir, 'onsets');

    % Define conditions and parametric modulations (if any)
    % FORMAT
    %   {VariableLabel,{TrialType,Durations}}
    %   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
    %  
    conditions = {...
            {'gamble', {'onset', 'duration'}},...
            {{'gain','gain_param'}, {'onset', 'duration', 'gain'}},...
            {{'loss','loss_param'}, {'onset', 'duration', 'loss'}},...
            {{'RT','RT_param'}, {'onset', 'duration', 'RT'}},...
        };
    create_onset_files(raw_dir, onset_dir, conditions, removed_TR_time);
    % spm('defaults','FMRI');
    % run_subject_level_analyses(study_dir, preproc_dir, 'template_ds001_SPM_level1', level1_dir, num_ignored_volumes, TR);
    % run_group_level_analysis(level1_dir, 'template_ds001_SPM_level2', level2_dir, '0001');
    % run_permutation_test(level1_dir, 'template_ds001_SPM_perm_test', perm_dir, '0001');
    % mean_mni_images(preproc_dir, level1_dir, mni_dir);
end
