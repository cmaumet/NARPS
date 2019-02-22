% _________________________________________________________________________
% Copy to 'preproc_dir' and gunzip anatomical and fmri files found in 
% 'study_dir' (and organised according to BIDS)
% _________________________________________________________________________
function copy_gunzip(fmriprep_dir, preproc_dir, subject_ids)
    
    if ~exist('subject_ids', 'var')
        sub_dirs = cellstr(spm_select('FPList', fmriprep_dir, 'dir', 'sub-*'));
    else
        % Select only subjects of interest
        sub_dirs = cell(length(subject_ids),1);
        for i = 1:length(subject_ids)
            sub_dirs(i,1) = cellstr(...
                spm_select('FPList', fmriprep_dir, 'dir', subject_ids(i)));
        end
    end

    % Create subfolder to store preprocessed data in the output folder
    if ~isdir(preproc_dir)
        mkdir(preproc_dir)
    end
    
    for n = 1:numel(sub_dirs)
        sub_folder = sub_dirs{n};
        anat_regexp = '.*_T1w_space-MNI152NLin2009cAsym_preproc\.nii\.gz';
        fun_regexp = '.*_bold_space-MNI152NLin2009cAsym_preproc\.nii\.gz';

        amri = spm_select('FPList', fullfile(sub_folder, 'anat'), ...
                          anat_regexp);                
       
        % Create output anat preproc directory
        anat_preproc_dir = fullfile(preproc_dir, 'anat');
        if ~isdir(anat_preproc_dir)
            mkdir(anat_preproc_dir)
        end        
        
        % Copy  & gunzip the anatomical image
        out_amri = spm_file(amri, 'path', anat_preproc_dir, 'ext', '');
        if ~isfile(out_amri)
            disp([spm_file(sub_folder, 'basename') ': copy & gunzip (anat)'])
            matlabbatch = {};
            
            % Copy            
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.file_move.files ...
                = {amri};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyto ...
                = {anat_preproc_dir};
            
            amri = spm_file(amri, 'path', anat_preproc_dir);
            
            % Gunzip
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = {amri};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = false;
            
            spm_jobman('run', matlabbatch);    
        end
            
        fmri = cellstr(...
                    spm_select('FPList', fullfile(sub_folder, 'func'), ...
                        fun_regexp));

        % For each run, copy & gunzip the fmri image       
        func_preproc_dir = fullfile(preproc_dir, 'func');
        if ~isdir(func_preproc_dir)
            mkdir(func_preproc_dir)
        end
        
        out_fmri = cell(numel(fmri), 1);
        for r = 1:numel(fmri)
            out_fmri{r} = spm_file(fmri{r}, 'path', func_preproc_dir, 'ext', '');
            
            if ~isfile(out_fmri{r})
                disp([spm_file(sub_folder, 'basename') ': copy & gunzip (run ' num2str(r) ')'])
                
                matlabbatch = {};
                
                % Copy
                matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.file_move.files ...
                    = {fmri{r}};
                matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyto ...
                    = {func_preproc_dir};
                
                fmri{r} = spm_file(fmri{r}, 'path', anat_preproc_dir);
                
                % Gunzip
                matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = fmri(r);
                matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
                matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = false;
                
                spm_jobman('run', matlabbatch);    
            end
        end
    end
end
