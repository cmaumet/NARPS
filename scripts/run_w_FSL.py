import os
import json
import glob

from lib.fsl_processing import create_fsl_onset_files
from lib.fsl_processing import run_run_level_analyses
from lib.fsl_processing import run_subject_level_analyses
from lib.fsl_processing import run_group_level_analysis
from lib.fsl_processing import run_permutation_test
from lib.fsl_processing import mean_mni_images

with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 
	                   'config.json')) as f:
    config = json.load(f)

fsl_dir = os.path.join(config['output_dir'], 'FSL')
if not os.path.isdir(fsl_dir):
    os.mkdir(fsl_dir)

preproc_dir = os.path.join(fsl_dir, 'preproc')
level1_dir = os.path.join(fsl_dir, 'level1')
level2_dir = os.path.join(fsl_dir, 'level2')
level3_dir = os.path.join(fsl_dir, 'level3')

# Specify the number of functional volumes ignored in the study
TR = 2
num_ignored_volumes = 0 # TODO

# Specify the TR that will be removed from onesets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR 

cwd = os.path.dirname(os.path.realpath(__file__))

subject_ids = ('sub-001', 'sub-002')
raw_sub_dirs = []
fmriprep_sub_dirs = []

# All subject directories
if subject_ids:
    for s in subject_ids:
        raw_sub_dirs.append(os.path.join(config['raw_dir'], s))
        fmriprep_sub_dirs.append(os.path.join(config['fmriprep_dir'], s))
else:
    raw_sub_dirs = glob.glob(os.path.join(config['raw_dir'], 'sub-*/'))
    fmriprep_sub_dirs = glob.glob(os.path.join(config['fmriprep_dir'], 'sub-*/'))

sub_names = list(map(os.path.basename, 
	                 list(map(os.path.normpath, raw_sub_dirs))))

# # Copy raw anatomical and functional data to the preprocessing directory and
# # run BET on the anatomical images
# copy_data(fmriprep_sub_dirs, preproc_dir)

# Directory to store the onset files
onsetDir = os.path.join(fsl_dir, 'onsets')

    # conditions = {...
    #         {{'gamble','gain_param', 'loss_param', 'RT_param'}, {'onset', 'duration', 'gain', 'loss', 'RT'}},...
    #     };

# Define conditions and parametric modulations (if any)
#   {VariableLabel,{TrialType,Durations}}
#   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
# Use 'onset' for 'TrialType' if all rows should be used

conditions = (
    (('gamble', 'gain_param'), ('onset', 'duration', 'gain')),
    (('gamble', 'loss_param'), ('onset', 'duration', 'loss')),
    (('gamble', 'RT_param'), ('onset', 'duration', 'RT')),
)

# Create 3-columns onset files based on BIDS tsv files
cond_files = create_fsl_onset_files(raw_sub_dirs, onsetDir, conditions, removed_TR_time)

run_level_fsf = os.path.join(cwd, 'templates', 'FSL_level1_template.fsf')
# Run a GLM for each fMRI run of each subject


run_run_level_analyses(sub_names, fmriprep_sub_dirs, run_level_fsf, level1_dir, cond_files)

raise Exception('Stopping here')
################################################################

sub_level_fsf = os.path.join(cwd, 'lib', 'template_ds001_FSL_level2.fsf')
grp_level_fsf = os.path.join(cwd, 'lib', 'template_ds001_FSL_level3.fsf')
perm_template = os.path.join(cwd, 'lib', 'template_ds001_FSL_perm_test')

# Run a GLM combining all the fMRI runs of each subject
run_subject_level_analyses(level1_dir, sub_level_fsf, level2_dir)

# Run the group-level GLM
run_group_level_analysis(level2_dir, grp_level_fsf, level3_dir, '1')

# Run a permutation test
run_permutation_test(level1_dir, perm_dir, perm_template)

# Create mean and standard deviations maps of the mean func and anat images in MNI space
mean_mni_images(preproc_dir, level1_dir, mni_dir)