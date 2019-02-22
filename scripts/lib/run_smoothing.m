function run_smoothing(sub_dirs, preproc_dir, sub_template)

    func_dir = fullfile(preproc_dir, 'func');
    scripts_dir = fullfile(preproc_dir, '..', 'scripts');    
    
    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end
    
    for i = 1:numel(sub_dirs)
        clearvars FUNC_RUN_*
        
        [~,sub,~] = fileparts(sub_dirs{i});
        sub = ['^' sub];
        
        fmri_files = cellstr(spm_select('List', func_dir, [sub '.*\.nii$']));
        
        last_out_file = spm_file(spm_select('FPList', func_dir, [sub '.*_run-' sprintf('%02d',numel(fmri_files)) '.*\.nii']), 'prefix', 's');
        if ~isfile(last_out_file)
            for r = 1:numel(fmri_files)
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