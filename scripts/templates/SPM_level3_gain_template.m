% to define: OUT_DIR, CON_GROUP_1, CON_GROUP_2

matlabbatch = {};
matlabbatch{end+1}.spm.stats.factorial_design.dir = {OUT_DIR};
matlabbatch{end}.spm.stats.factorial_design.des.t2.scans1 = CON_GROUP{1};
matlabbatch{end}.spm.stats.factorial_design.des.t2.scans2 = CON_GROUP{2};
matlabbatch{end}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{end}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{end}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{end}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{end}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{end}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{end}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{end}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{end}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{end}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{end}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{end}.spm.stats.factorial_design.globalm.glonorm = 1;

% estimation
matlabbatch{end+1}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{end}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{end}.spm.stats.fmri_est.method.Classical = 1;

% contrasts
matlabbatch{end+1}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{end}.spm.stats.con.consess{1}.tcon.name = 'gain_param_indiff';
matlabbatch{end}.spm.stats.con.consess{1}.tcon.weights = CON_VECTOR_INDIFF;
matlabbatch{end}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{end}.spm.stats.con.consess{2}.tcon.name = 'gain_param_range';
matlabbatch{end}.spm.stats.con.consess{2}.tcon.weights = CON_VECTOR_RANGE;
matlabbatch{end}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

% inference
matlabbatch{end+1}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{end}.spm.stats.results.conspec(1).titlestr = '';
matlabbatch{end}.spm.stats.results.conspec(1).contrasts = 1;
matlabbatch{end}.spm.stats.results.conspec(1).threshdesc = 'FDR';
matlabbatch{end}.spm.stats.results.conspec(1).thresh = 0.05;
matlabbatch{end}.spm.stats.results.conspec(1).extent = 0;
matlabbatch{end}.spm.stats.results.conspec(1).conjunction = 1;
matlabbatch{end}.spm.stats.results.conspec(1).mask.none = 1;
matlabbatch{end}.spm.stats.results.conspec(2).titlestr = '';
matlabbatch{end}.spm.stats.results.conspec(2).contrasts = 2;
matlabbatch{end}.spm.stats.results.conspec(2).threshdesc = 'FDR';
matlabbatch{end}.spm.stats.results.conspec(2).thresh = 0.05;
matlabbatch{end}.spm.stats.results.conspec(2).extent = 0;
matlabbatch{end}.spm.stats.results.conspec(2).conjunction = 1;
matlabbatch{end}.spm.stats.results.conspec(2).mask.none = 1;
matlabbatch{end}.spm.stats.results.units = 1;
matlabbatch{end}.spm.stats.results.export{1}.ps = true;
matlabbatch{end}.spm.stats.results.export{2}.tspm.basename = 'thresh_';
matlabbatch{end}.spm.stats.results.export{3}.nidm.modality = 'FMRI';
% Check fmriprep ref space
matlabbatch{end}.spm.stats.results.export{3}.nidm.refspace = 'mni';
% add group info