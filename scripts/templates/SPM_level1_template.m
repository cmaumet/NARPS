matlabbatch = {};
matlabbatch{end+1}.spm.stats.fmri_spec.dir = {OUT_DIR};
matlabbatch{end}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{end}.spm.stats.fmri_spec.timing.RT = TR;
matlabbatch{end}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{end}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{end}.spm.stats.fmri_spec.sess(1).scans = FUNC_RUN_1;
matlabbatch{end}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{end}.spm.stats.fmri_spec.sess(1).multi = {ONSETS_RUN_1};
regressor_names = {'X', 'Y', 'Z', 'RotX', 'RotY', 'RotZ'};
for re = 1:numel(regressor_names)
    for se = 1:4
        reg = eval([regressor_names{re} '_' num2str(se)]);
        name = regressor_names{re};

        matlabbatch{end}.spm.stats.fmri_spec.sess(se).regress(re).name = name;
        matlabbatch{end}.spm.stats.fmri_spec.sess(se).regress(re).val = reg;
        
        matlabbatch{end}.spm.stats.fmri_spec.sess(se).regress(re).name = [name '^2'];
        matlabbatch{end}.spm.stats.fmri_spec.sess(se).regress(re).val = reg.^2;
        
        matlabbatch{end}.spm.stats.fmri_spec.sess(se).regress(re+6).name = [name ''''];
        matlabbatch{end}.spm.stats.fmri_spec.sess(se).regress(re+6).val = [0; diff(reg)];
        
        matlabbatch{end}.spm.stats.fmri_spec.sess(se).regress(re+6).name = [name '''^2'];
        matlabbatch{end}.spm.stats.fmri_spec.sess(se).regress(re+6).val = [0; diff(reg)].^2;
    end
end
matlabbatch{end}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{end}.spm.stats.fmri_spec.sess(2).scans = FUNC_RUN_2;
matlabbatch{end}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{end}.spm.stats.fmri_spec.sess(2).multi = {ONSETS_RUN_2};
% covariates of no interest are set for all sessions in the loop above
matlabbatch{end}.spm.stats.fmri_spec.sess(2).hpf = 128;
matlabbatch{end}.spm.stats.fmri_spec.sess(3).scans = FUNC_RUN_3;
matlabbatch{end}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{end}.spm.stats.fmri_spec.sess(3).multi = {ONSETS_RUN_3};
% covariates of no interest are set for all sessions in the loop above
matlabbatch{end}.spm.stats.fmri_spec.sess(3).hpf = 128;
matlabbatch{end}.spm.stats.fmri_spec.sess(4).scans = FUNC_RUN_4;
matlabbatch{end}.spm.stats.fmri_spec.sess(4).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{end}.spm.stats.fmri_spec.sess(4).multi = {ONSETS_RUN_4};
% covariates of no interest are set for all sessions in the loop above
matlabbatch{end}.spm.stats.fmri_spec.sess(4).hpf = 128;
matlabbatch{end}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{end}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{end}.spm.stats.fmri_spec.volt = 1;
matlabbatch{end}.spm.stats.fmri_spec.global = 'None';
matlabbatch{end}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{end}.spm.stats.fmri_spec.mask = {''};
matlabbatch{end}.spm.stats.fmri_spec.cvi = 'FAST';
matlabbatch{end+1}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{end}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{end}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{end+1}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{end}.spm.stats.con.consess{1}.tcon.name = 'gain_param';
matlabbatch{end}.spm.stats.con.consess{1}.tcon.weights = [0 0.25 0 0 repmat(0, 1, 24) 0 0.25 0 0 repmat(0, 1, 24) 0 0.25 0 0 repmat(0, 1, 24) 0 0.25 0 0 repmat(0, 1, 24)];
matlabbatch{end}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{end}.spm.stats.con.consess{2}.tcon.name = 'loss_param';
matlabbatch{end}.spm.stats.con.consess{2}.tcon.weights = [0 0 0.25 0 repmat(0, 1, 24) 0 0 0.25 0 repmat(0, 1, 24) 0 0 0.25 0 repmat(0, 1, 24) 0 0 0.25 0 repmat(0, 1, 24)];
matlabbatch{end}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{end}.spm.stats.con.delete = 0;
% inference
matlabbatch{end+1}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
for i = 1:2
    matlabbatch{end}.spm.stats.results.conspec(i).titlestr = '';
    matlabbatch{end}.spm.stats.results.conspec(i).contrasts = i;
    matlabbatch{end}.spm.stats.results.conspec(i).threshdesc = 'FDR';
    matlabbatch{end}.spm.stats.results.conspec(i).thresh = 0.05;
    matlabbatch{end}.spm.stats.results.conspec(i).extent = 0;
    matlabbatch{end}.spm.stats.results.conspec(i).conjunction = 1;
    matlabbatch{end}.spm.stats.results.conspec(i).mask.none = 1;
end
matlabbatch{end}.spm.stats.results.units = 1;
matlabbatch{end}.spm.stats.results.export{1}.ps = true;
matlabbatch{end}.spm.stats.results.export{2}.tspm.basename = 'thresh_';
matlabbatch{end}.spm.stats.results.export{3}.nidm.modality = 'FMRI';
matlabbatch{end}.spm.stats.results.export{3}.nidm.refspace = 'mni';
matlabbatch{end}.spm.stats.results.export{3}.nidm.group.nsubj = 1;
matlabbatch{end}.spm.stats.results.export{3}.nidm.group.label = 'subject';