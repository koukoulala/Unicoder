# 7.20
# Unicoder original evaluate:
# 32-2
cd /data/xiaoyu && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_2 && . /tmp/env_2/bin/activate && python -m pip install --editable . && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  sh ./bash_scripts/finetune/eval_exp.sh en  6  ./   ../../ckpt/Unicoder  ./output_G6  ../../XGLUE/NTG 14 30
# p40
cd /vc_data/users/xiaoyu && cd Unicoder/generation && pip install --user . && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  sh ./bash_scripts/finetune/eval_exp.sh en  4  ./   ../../ckpt/Unicoder  ./output_G2  ../../XGLUE/NTG 12 20

# Local evaluate:
bash ./bash_scripts/preprocess/preprocess_NTG.sh ./  ../../ckpt/Unicoder  ../../../Datasets/xglue_full_dataset/NTG

sh ./bash_scripts/finetune/eval_exp.sh en  2  ./   ../../ckpt/Unicoder  ../../ckpt/Unicoder_ckpts/output_G6  ../../datasets/xglue_full_dataset/NTG 14 30

# evaluate test
python evaluation/xglue_evaluate.py --prediction_dir evaluation/XGLUE_test --ground_truth_dir ..\..\..\Datasets\xglue_full_dataset --tasks NTG --split test

# train on 6 GPU
cd /data/xiaoyu && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_2 && . /tmp/env_2/bin/activate && python -m pip install --editable . && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  sh ./bash_scripts/finetune/finetune_NTG.sh en  6  ./   ../../ckpt/Unicoder  ./output_G6_7.20  ../../XGLUE/NTG 14 30

# 7.21 evaluate of 6gpu Unicoder with torch==1.5.0
cd /data/xiaoyu && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_2 && . /tmp/env_2/bin/activate && python -m pip install --editable . && python --version && python ./bash_scripts/try_docker.py && python -m pip install torch==1.5.0 && python ./bash_scripts/try_docker.py && nvcc -V &&  sh ./bash_scripts/finetune/eval_exp.sh en  6  ./   ../../ckpt/Unicoder  ./output_G6_7.20  ../../XGLUE/NTG 14 30

python bash_scripts/deal_data/try_2.py --source_file=../../../Datasets/NTG_aug/xglue.ntg.en.tgt.test  --target_file=../../../Datasets/NTG_aug/xglue.ntg.en.tgt.test_trans  --final_file=../../../Datasets/NTG_aug/xglue.ntg.en.tgt.test_aug --source_lang=en --target_lang=de
python bash_scripts/deal_data/translate_lang.py --source_file=../../../Datasets/NTG_aug/xglue.ntg.en.tgt.test  --target_file=../../../Datasets/NTG_aug/xglue.ntg.en.tgt.test_trans  --final_file=../../../Datasets/NTG_aug/xglue.ntg.en.tgt.test_aug --source_lang=en --target_lang=de
python bash_scripts/deal_data/try_2.py --source_file=../../../Datasets/NTG_aug/xglue.ntg.en.src.test  --target_file=../../../Datasets/NTG_aug/xglue.ntg.en.src.test_trans  --final_file=../../../Datasets/NTG_aug/xglue.ntg.en.src.test_aug --source_lang=en --target_lang=de
python bash_scripts/deal_data/try_trans.py --source_file=../../../Datasets/NTG_aug/en_src_train.txt  --target_file=../../../Datasets/NTG_aug/en_src_train_trans.txt  --source_lang=en --target_lang=de

# on 8002
nohup python -u bash_scripts/deal_data/try_trans_iter.py --source_file=../../datasets/trans/en_src_train  --target_file=../../datasets/trans/en_src_train_trans  --source_lang=en --target_lang=de &> try.out &

# 7.22
split -l 5000 sampled_xglue.ntg.en.src.train -d -a 1 sampled_xglue.ntg.en.src.train_
split -l 5000 sampled_xglue.ntg.en.tgt.train -d -a 1 sampled_xglue.ntg.en.tgt.train_
nohup python -u bash_scripts/deal_data/try_trans_iter.py --root_path=../../datasets/trans/  --split=src --target_lang=de --start=0 &> try_iter.out &
nohup python -u bash_scripts/deal_data/try_trans.py --root_path=../../datasets/trans/  --split=src --target_lang=de &> logs/trans_src_de_2.out &

# 7.28
cd /data/xiaoyukou && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_pre && . /tmp/env_pre/bin/activate && python -m pip install --editable .  && python -m pip install sentencepiece && python --version && python ./bash_scripts/try_docker.py && nvcc -V && sh bash_scripts/preprocess/preprocess_trans_NTG.sh ./ ../../ckpt/Unicoder ../../XGLUE/sampled_NTG
cd /data/xiaoyukou && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_en && . /tmp/env_en/bin/activate && python -m pip install --editable .  && python -m pip install sentencepiece && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  bash ./bash_scripts/finetune/finetune_NTG.sh en 4  ./  ../../ckpt/Unicoder  ./output_sampled/en_G4_7.28  ../../XGLUE/sampled_NTG 12 30

cd /data/xiaoyukou && cd Unicoder/generation && pip install --user . && pip install --user numpy==1.20.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V && sh ./bash_scripts/finetune/finetune_NTG.sh en 4  ./  ../../ckpt/Unicoder  ./output_sampled/en_G4_7.28  ../../XGLUE/sampled_NTG 12 30

# 7.29
cd /data/xiaoyukou && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_en && . /tmp/env_en/bin/activate && python -m pip install --editable .  && python -m pip install torch==1.5.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  bash ./bash_scripts/finetune/finetune_NTG.sh en 4  ./  ../../ckpt/Unicoder  ./output_sampled/en_G4_7.28  ../../XGLUE/NTG 12 30
cd /data/xiaoyukou && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_fr && . /tmp/env_fr/bin/activate && python -m pip install --editable .  && python -m pip install torch==1.5.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  bash ./bash_scripts/finetune/finetune_NTG.sh fr 4  ./  ../../ckpt/Unicoder  ./output_sampled/fr_G4_7.28  ../../XGLUE/NTG 12 30

cd /data/xiaoyukou && cd Unicoder/generation && pip install --user . && pip install --user numpy==1.20.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V && sh ./bash_scripts/finetune/finetune_NTG.sh fr 4  ./  ../../ckpt/Unicoder  ./output_sampled/fr_G4_7.28  ../../XGLUE/sampled_NTG 12 30
cd /data/xiaoyukou && cd Unicoder/generation && pip install --user . && pip install --user numpy==1.20.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V && sh ./bash_scripts/finetune/finetune_NTG.sh de 4  ./  ../../ckpt/Unicoder  ./output_sampled/de_G4_7.28  ../../XGLUE/sampled_NTG 12 30
cd /data/xiaoyukou && cd Unicoder/generation && pip install --user . && pip install --user numpy==1.20.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V && sh ./bash_scripts/finetune/finetune_NTG.sh es 4  ./  ../../ckpt/Unicoder  ./output_sampled/es_G4_7.28  ../../XGLUE/sampled_NTG 12 30
cd /data/xiaoyukou && cd Unicoder/generation && pip install --user . && pip install --user numpy==1.20.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V && sh ./bash_scripts/finetune/finetune_NTG.sh ru 4  ./  ../../ckpt/Unicoder  ./output_sampled/ru_G4_7.28  ../../XGLUE/sampled_NTG 12 30

# 7.30
cd /data/xiaoyukou && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_en && . /tmp/env_en/bin/activate && python -m pip install --editable .  && python -m pip install torch==1.5.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  bash ./bash_scripts/finetune/eval_exp.sh en 4  ./  ../../ckpt/Unicoder  ./output/en_G4_7.28  ../../XGLUE/NTG 12 30
cd /data/xiaoyukou && cd Unicoder/generation && python -m pip install virtualenv --user && python -m virtualenv /tmp/env_ru && . /tmp/env_ru/bin/activate && python -m pip install --editable .  && python -m pip install torch==1.5.0 && python --version && python ./bash_scripts/try_docker.py && nvcc -V &&  bash ./bash_scripts/finetune/finetune_NTG.sh ru 4  ./  ../../ckpt/Unicoder  ./output_sampled/ru_G4_7.28  ../../XGLUE/sampled_NTG 12 30

# 8.1
cd /data/xiaoyukou && cd Unicoder/generation && pip install --user . && pip install --user numpy==1.20.0 && pip install --user sentencepiece && python --version && python ./bash_scripts/try_docker.py && nvcc -V && sh ./bash_scripts/preprocess/preprocess_trans_NTG.sh ./ ../../ckpt/Unicoder ../../XGLUE/NTG

# 8.2
"pip install --user torch==1.6.0 sklearn scipy==1.3.1 Unicoder/understanding/. && python convert_model.py --reload [#input-previous-model-path]/best-valid_mlm_ppl.pth --output_file [#input-previous-model-path]/best-ulr_large.pth --source_only true && bash scripts/train.sh xlm-roberta-large [#input-previous-model-path]/best-ulr_large.pth [#output-model-path] [#input-training-data-path] mlqa"
"python -m pip install virtualenv --user && python -m virtualenv /tmp/env_pre && . /tmp/env_pre/bin/activate && python -m pip install --editable .  && python -m pip install sentencepiece && python --version && python ./bash_scripts/try_docker.py && nvcc -V && sh bash_scripts/preprocess/preprocess_trans_NTG.sh ./ [#input-previous-model-path]/Unicoder [#input-training-data-path]"


