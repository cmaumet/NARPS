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

        group_names = unique(groups);

        CON_GROUP = {};
        CON_GROUP{1} = {};
        CON_GROUP{2} = {};

        for i = 1:numel(sub_names)
            sub_dir = fullfile(level1_dir, sub_names{i});
            [~, group_id] = ismember(groups{i}, group_names);

            CON_GROUP{group_id}{end+1,1} = spm_select(...
                'FPList', sub_dir, ['con_' contrast_id '\.nii']);
        end

        if contains(lower(group_names{1}), 'indiff')
            CON_VECTOR_INDIFF = [1 0];
            CON_VECTOR_INDIFF_NEG = [-1 0];
            if contains(lower(group_names{2}), 'range')
                CON_VECTOR_RANGE = [0 1];
                CON_VECTOR_RANGE_NEG = [0 -1];
                CON_VECTOR_RANGE_VS_INDIFF = [-1 1];
            else
                error(['Unknown group: ' group_names{2}]);
            end
        elseif contains(lower(group_names{1}), 'range')
            CON_VECTOR_RANGE = [1 0];
            CON_VECTOR_RANGE_NEG = [-1 0];
            if contains(lower(group_names{2}), 'indiff')
                CON_VECTOR_INDIFF = [0 1];
                CON_VECTOR_INDIFF_NEG = [0 -1];
                CON_VECTOR_RANGE_VS_INDIFF = [1 -1];
            else
                error(['Unknown group: ' group_names{2}]);
            end
        else
            error(['Unknown group: ' group_names{1}]);
        end

        % Create the matlabbatch for this subject
        eval(group_batch_template);

        save(fullfile(scripts_dir, 'group.mat'), 'matlabbatch');

        % Topological FDR should be 0 for voxelwise FDR
        global defaults
        defaults.stats.topoFDR = 0;
        spm_jobman('run', matlabbatch);
    end
end