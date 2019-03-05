function run_subject_level_analyses(fmriprep_sub_dirs, preproc_dir, sub_template, level1_dir, num_ignored_volumes, TR, varargin)

    func_dir = fullfile(preproc_dir, 'func');

    for i = 1:numel(fmriprep_sub_dirs)       
        clearvars FUNC_RUN_* ONSETS_RUN_* OUT_DIR X Y Z RotX RotY RotZ
        
        fmriprep_sub_dir = fmriprep_sub_dirs{i};
        sub = spm_file(fmriprep_sub_dir, 'filename');       
        
        OUT_DIR = fullfile(level1_dir, sub);
        if ~isdir(OUT_DIR)
            mkdir(OUT_DIR)
        end
        
        onset_dir = fullfile(OUT_DIR, 'onsets');
        script_dir = fullfile(OUT_DIR, 'scripts');
        if ~isdir(script_dir)
            mkdir(script_dir)
        end             
        
        % Check whether second stat files was created
        stat_file = fullfile(OUT_DIR, 'spmT_0002.nii');
        if ~isfile(stat_file)
            fmri_files = cellstr(spm_select('List', func_dir, ['^s' sub '.*\.nii$']));
            for r = 1:numel(fmri_files)
                run = ['run-' sprintf('%02d',r)];
                
                sub_run = [sub '.*_' run];
                fmris = cellstr(spm_select('ExtFPList', func_dir, ['^s' sub_run '.*\.nii'], Inf)); 
                fmris = fmris(num_ignored_volumes+1:end);
                eval(['FUNC_RUN_' num2str(r) ' =  fmris;']);
                onset_file = spm_select('FPList', onset_dir, ['^' sub_run '.*\.mat']);
                eval(['ONSETS_RUN_' num2str(r) ' = onset_file;']);
                
                motion_file = spm_select('FPList', fullfile(fmriprep_sub_dir, 'func'), ['^' sub '.*' run '.*\.tsv$']);
                params = tdfread(motion_file);
                eval(['X_' num2str(r) ' =  params.X;']);
                eval(['Y_' num2str(r) ' =  params.Y;']);
                eval(['Z_' num2str(r) ' =  params.Z;']);
                eval(['RotX_' num2str(r) ' =  params.RotX;']);
                eval(['RotY_' num2str(r) ' =  params.RotY;']);
                eval(['RotZ_' num2str(r) ' =  params.RotZ;']);
            end
            
            % Create the matlabbatch for this subject
            eval(sub_template);

            save(fullfile(script_dir, ['batch_' strrep(sub,'^','') '_level1.mat']), 'matlabbatch');
            spm_jobman('run', matlabbatch);
        end
    end
end