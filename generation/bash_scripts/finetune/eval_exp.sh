# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.


lg=$1          # supervised lanugage for finetuning [en]
NGPU=$2        # num of GPUs to use
CODE_ROOT=$3   # path/to/code_root
MODEL_DIR=$4   # path/to/model_dir
OUTPUT_DIR=$5  # output dir to save checkpoints, decodings, etc 
DATA_ROOT=$6   # path/to/XGLUE/NTG
max_sents=$7
mepoch=$8


PRETRAIN=$MODEL_DIR/checkpoint.pt
SPE=$MODEL_DIR/sentencepiece.bpe.model

DATA_BIN=$DATA_ROOT/bin
DATA_REF=$DATA_ROOT/ref

langs=af,als,am,an,ang,ar,arz,ast,az,bar,be,bg,bn,br,bs,ca,ceb,ckb,cs,cy,da,de,el,en,eo,es,et,eu,fa,fi,fr,fy,ga,gan,gl,gu,he,hi,hr,hu,hy,ia,id,is,it,ja,jv,ka,kk,kn,ko,ku,la,lb,lt,lv,mk,ml,mn,mr,ms,my,nds,ne,nl,nn,no,oc,pl,pt,ro,ru,scn,sco,sh,si,simple,sk,sl,sq,sr,sv,sw,ta,te,th,tl,tr,tt,uk,ur,uz,vi,war,wuu,yi,zh,zh_classical,zh_min_nan,zh_yue

lr=1e-5

TBS=1024
#max_sents=16
update_freq=$(($TBS/$max_sents/$NGPU))

warmup=2000
#mepoch=30

task=generation_from_pretrained_bart
EXP="FINETUNE_NTG_${lg}"

SAVE=${OUTPUT_DIR}/$EXP

# mkdir -p $SAVE

SUFFIX=""
if [ ! -f $SAVE/checkpoint_last.pt ]; then
   echo "copy pretrained model to last"
   cp $PRETRAIN $SAVE/checkpoint_last.pt
fi


python $CODE_ROOT/evaluation/eval_exp.py --task $task --test_beam 10 --ngpu ${NGPU} --epoch ${mepoch} \
           --exp $EXP --data_path $DATA_BIN --ref_folder $DATA_REF \
           --lgs en-fr-es-ru-de --supervised_lg $lg --spe $SPE --save_dir $OUTPUT_DIR --dataset NTG \
           --code_root $CODE_ROOT
