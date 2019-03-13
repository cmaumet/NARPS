% to define: OUT_DIR, CON_GROUP_1, CON_GROUP_2

matlabbatch = {};
matlabbatch{end+1}.spm.stats.factorial_design.dir = {OUT_DIR};
matlabbatch{end}.spm.stats.factorial_design.des.t2.scans1 = CON_GROUP_INDIF;
matlabbatch{end}.spm.stats.factorial_design.des.t2.scans2 = CON_GROUP_RANGE;
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

matlabbatch{end}.spm.stats.con.consess{1}.fcon.name = 'loss_param_indiff';
matlabbatch{end}.spm.stats.con.consess{1}.fcon.weights = CON_VECTOR_INDIFF;
matlabbatch{end}.spm.stats.con.consess{1}.fcon.sessrep = 'none';

matlabbatch{end}.spm.stats.con.consess{2}.fcon.name = 'loss_param_range';
matlabbatch{end}.spm.stats.con.consess{2}.fcon.weights = CON_VECTOR_RANGE;
matlabbatch{end}.spm.stats.con.consess{2}.fcon.sessrep = 'none';

matlabbatch{end}.spm.stats.con.consess{3}.tcon.name = 'loss_range_vs_indiff';
matlabbatch{end}.spm.stats.con.consess{3}.tcon.weights = CON_VECTOR_RANGE_VS_INDIFF;
matlabbatch{end}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

% inference
matlabbatch{end+1}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
for i = 1:3
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
matlabbatch{end}.spm.stats.results.export{2}.tspm.basename = 'thresh';
matlabbatch{end}.spm.stats.results.export{3}.nidm.modality = 'FMRI';
matlabbatch{end}.spm.stats.results.export{3}.nidm.refspace = 'mni';
matlabbatch{end}.spm.stats.results.export{3}.nidm.group(1).nsubj = N_SUB_GROUP_INDIF;
matlabbatch{end}.spm.stats.results.export{3}.nidm.group(1).label = 'Equal indifference group';
matlabbatch{end}.spm.stats.results.export{3}.nidm.group(2).nsubj = N_SUB_GROUP_RANGE;
matlabbatch{end}.spm.stats.results.export{3}.nidm.group(2).label = 'Equal range group';

matlabbatch{end+1}.spm.util.imcalc.input = {
                                        fullfile(OUT_DIR, 'spmF_0001_thresh.nii,1');
                                        fullfile(OUT_DIR, 'beta_0001.nii,1');
                                        };
matlabbatch{end}.spm.util.imcalc.output = 'hypo5_thresh';
matlabbatch{end}.spm.util.imcalc.outdir = {OUT_DIR};
matlabbatch{end}.spm.util.imcalc.expression = 'i1.*(i2<0)';
matlabbatch{end}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{end}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{end}.spm.util.imcalc.options.mask = 0;
matlabbatch{end}.spm.util.imcalc.options.interp = 1;
matlabbatch{end}.spm.util.imcalc.options.dtype = 16;

matlabbatch{end+1}.spm.util.imcalc.input = {
                                        fullfile(OUT_DIR, 'spmF_0002_thresh.nii,1');
                                        fullfile(OUT_DIR, 'beta_0002.nii,1');
                                        };
matlabbatch{end}.spm.util.imcalc.output = 'hypo6_thresh';
matlabbatch{end}.spm.util.imcalc.outdir = {OUT_DIR};
matlabbatch{end}.spm.util.imcalc.expression = 'i1.*(i2<0)';
matlabbatch{end}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{end}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{end}.spm.util.imcalc.options.mask = 0;
matlabbatch{end}.spm.util.imcalc.options.interp = 1;

matlabbatch{end+1}.spm.util.imcalc.input = {
                                        fullfile(OUT_DIR, 'spmF_0001_thresh.nii,1');
                                        fullfile(OUT_DIR, 'beta_0001.nii,1');
                                        };
matlabbatch{end}.spm.util.imcalc.output = 'hypo7_thresh';
matlabbatch{end}.spm.util.imcalc.outdir = {OUT_DIR};
matlabbatch{end}.spm.util.imcalc.expression = 'i1.*(i2>0)';
matlabbatch{end}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{end}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{end}.spm.util.imcalc.options.mask = 0;
matlabbatch{end}.spm.util.imcalc.options.interp = 1;
matlabbatch{end}.spm.util.imcalc.options.dtype = 16;

matlabbatch{end+1}.spm.util.imcalc.input = {
                                        fullfile(OUT_DIR, 'spmF_0002_thresh.nii,1');
                                        fullfile(OUT_DIR, 'beta_0002.nii,1');
                                        };
matlabbatch{end}.spm.util.imcalc.output = 'hypo8_thresh';
matlabbatch{end}.spm.util.imcalc.outdir = {OUT_DIR};
matlabbatch{end}.spm.util.imcalc.expression = 'i1.*(i2>0)';
matlabbatch{end}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{end}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{end}.spm.util.imcalc.options.mask = 0;
matlabbatch{end}.spm.util.imcalc.options.interp = 1;
matlabbatch{end}.spm.util.imcalc.options.dtype = 16;

matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.file_move.files = {fullfile(OUT_DIR, 'spmT_0003_thresh.nii')};
matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.copyto = {OUT_DIR};
matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.patrep.pattern = 'spmT_0003';
matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.patrep.repl = 'hypo9';
matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.unique = false;