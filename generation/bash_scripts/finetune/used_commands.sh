# 7.20
# Unicoder original evaluate:
cd /data/xiaoyu && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_2 && . /tmp/env_2/bin/activate && python -m pip install --editable . && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  sh ./bash_scripts/finetune/eval_exp.sh en  6  ./   ../../ckpt/Unicoder  ./output_G6  ../../XGLUE/NTG 14 30

# Local evaluate:
bash ./bash_scripts/preprocess/preprocess_NTG.sh ./  ../../ckpt/Unicoder  ../../../Datasets/xglue_full_dataset/NTG

sh ./bash_scripts/finetune/eval_exp.sh en  2  ./   ../../ckpt/Unicoder  ../../ckpt/Unicoder_ckpts/output_G6  ../../datasets/xglue_full_dataset/NTG 14 30
