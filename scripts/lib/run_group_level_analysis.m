function run_group_level_analysis(sub_names, groups, level1_dir, ...
    group_batch_template, out_dir, contrast_id, contrast_prefix)
% (sub_names, groups, level1_dir, 'SPM_level3_gain_template', level3_dir, '0001');
%          run_group_level_analysis(sub_names, groups, level1_dir, 'SPM_level2_template', level2_dir, '0001');

    out_file = fullfile(out_dir, 'spmT_0002.nii');
    
    if ~exist(out_file, 'file')
        scripts_dir = fullfile(out_dir, 'batch');
        OUT_DIR = out_dir;

        if ~isdir(scripts_dir)
            mkdir(scripts_dir)
        end

        CON_GROUP_INDIF = {};
        CON_GROUP_RANGE = {};

        for i = 1:numel(sub_names)
            sub_dir = fullfile(level1_dir, sub_names{i});
            con_file = spm_select('FPList', ...
                                  sub_dir, ['con_' contrast_id '\.nii']);
            
            if contains(lower(groups{i}), 'indiff')
                CON_GROUP_INDIF{end+1,1} = con_file;
            elseif contains(lower(groups{i}), 'range')
                CON_GROUP_RANGE{end+1,1} = con_file;
            else
                error(['Unknown group: ' groups{i}]);
            end
        end
        
        CON_VECTOR_INDIFF = [1 0];
        CON_VECTOR_RANGE = [0 1];
        CON_VECTOR_INDIFF_NEG = [-1 0];
        CON_VECTOR_RANGE_NEG = [0 -1];
        CON_VECTOR_RANGE_VS_INDIFF = [-1 1];

        N_SUB_GROUP_INDIF = numel(CON_GROUP_INDIF);
        N_SUB_GROUP_RANGE = numel(CON_GROUP_RANGE);
        
        % Create the matlabbatch for this subject
        eval(group_batch_template);

        save(fullfile(scripts_dir, 'group.mat'), 'matlabbatch');

        spm_jobman('run', matlabbatch);
    end
end