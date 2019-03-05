function run_smoothing(fmriprep_dirs, preproc_dir, sub_template)

    func_dir = fullfile(preproc_dir, 'func');
    scripts_dir = fullfile(preproc_dir, '..', 'scripts');    
    
    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end
    
    for i = 1:numel(fmriprep_dirs)
        clearvars FUNC_RUN_*
        
        sub = spm_file(fmriprep_dirs{i}, 'filename');
        sub = ['^' sub];
        
        input_fMRI = cellstr(spm_select('FPList', fullfile(fmriprep_dirs{i}, 'func'), [sub '.*_run-.*_bold_space-MNI152NLin2009cAsym_preproc\.nii\.gz$']));
        last_out_file = spm_file(input_fMRI{end}, 'prefix', 's', 'path', func_dir, 'ext', '');
        if ~isfile(last_out_file)    
            copy_gunzip({fmriprep_dirs{i}}, preproc_dir)
            
            fmri_files = cellstr(spm_select('List', func_dir, [sub '.*\.nii$']));
            
            for r = 1:numel(fmri_files)
                disp([sub(2:end) ': smoothing (run ' num2str(r) ')'])
                
                sub_run = [sub '.*_run-' sprintf('%02d',r)];
                fmris = cellstr(spm_select('ExtFPList', func_dir, [sub_run '.*\.nii'], Inf)); 
                eval(['FUNC_RUN_' num2str(r) ' =  fmris;']);
            end

            % Create the matlabbatch for this subject
            eval(sub_template);

            save(fullfile(scripts_dir, [strrep(sub,'^','') '_smoothing.mat']), 'matlabbatch');
            spm_jobman('run', matlabbatch);
        end
    end
end