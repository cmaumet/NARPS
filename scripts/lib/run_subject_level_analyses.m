function run_subject_level_analyses(sub_dirs, preproc_dir, sub_template, level1_dir, num_ignored_volumes, TR, varargin)

    onset_dir = fullfile(preproc_dir, '..', 'onsets');
    func_dir = fullfile(preproc_dir, 'func');
    anat_dir = fullfile(preproc_dir, 'anat');
    scripts_dir = fullfile(preproc_dir, '..', 'scripts');    
    
    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end

    for i = 1:numel(sub_dirs)       
        clearvars FUNC_RUN_* ONSETS_RUN_* OUT_DIR
        
        [~,sub,~] = fileparts(sub_dirs{i});
        OUT_DIR = fullfile(level1_dir, sub);
        
        stat_file = fullfile(OUT_DIR, 'spmT_0001.nii');
        if ~isfile(stat_file)
            fmri_files = cellstr(spm_select('List', func_dir, ['^s' sub '.*\.nii$']));
            for r = 1:numel(fmri_files)
                sub_run = [sub '.*_run-' sprintf('%02d',r)];
                fmris = cellstr(spm_select('ExtFPList', func_dir, ['^s' sub_run '.*\.nii'], Inf)); 
                fmris = fmris(num_ignored_volumes+1:end);
                eval(['FUNC_RUN_' num2str(r) ' =  fmris;']);
                onset_file = spm_select('FPList', onset_dir, ['^' sub_run '.*\.mat']);
                eval(['ONSETS_RUN_' num2str(r) ' = onset_file;']);
            end

            % Create the matlabbatch for this subject
            eval(sub_template);

            save(fullfile(scripts_dir, [strrep(sub,'^','') '_level1.mat']), 'matlabbatch');
            spm_jobman('run', matlabbatch);
        end
    end
end