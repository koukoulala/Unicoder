# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.


CODE_ROOT=$1     # path to code root
MODEL_DIR=$2     # path/to/saved_model_dir
DATA=$3          # path/to/XGLUE/NTG

SPE_MODEL=$MODEL_DIR/sentencepiece.bpe.model
DICT=$MODEL_DIR/dict.txt

DATA_SPM=$DATA/spm
DATA_BIN=$DATA/bin
DATA_REF=$DATA/ref

if [ ! -x $DATA_SPM ]; then
   mkdir $DATA_SPM
fi

if [ ! -x $DATA_REF ]; then
   mkdir $DATA_REF
fi

if [ ! -x $DATA_BIN ]; then
   mkdir $DATA_BIN
fi

# Save references

for lg in en es fr de ru; do
    cp ${DATA}/xglue.ntg.$lg.tgt.dev ${DATA_REF}/$lg.tgt.valid 
done


# Tokenize

for lg in en es fr de ru; do
    for split in train dev; do
        for pair in tgt src; do
            echo $lg.$pair.$split
            python $CODE_ROOT/scripts/spm_encode.py --model $SPE_MODEL \
                --inputs ${DATA}/xglue.ntg.$lg.$pair.$split --outputs $DATA_SPM/$lg.$split.spm.$pair
        done
    done
done


for lg in en es fr de ru; do
    for split in test; do
        for pair in src; do
            echo $lg.$pair.$split
            python $CODE_ROOT/scripts/spm_encode.py --model $SPE_MODEL \
                --inputs ${DATA}/xglue.ntg.$lg.$pair.$split --outputs $DATA_SPM/$lg.$split.spm.$pair
        done
    done
done


# Truncate source to 512

python $CODE_ROOT/bash_scripts/preprocess/truncate_src.py --path $DATA_SPM --max_len 512


# Binarize

for lg in en es fr de ru; do
    echo $lg
    if [ ! -x $DATA_BIN/$lg ]; then
     mkdir $DATA_BIN/$lg
    fi

    python $CODE_ROOT/preprocess.py \
      --source-lang src \
      --target-lang tgt \
      --only-source \
      --testpref $DATA_SPM/$lg.test.spm \
      --destdir $DATA_BIN/$lg \
      --thresholdtgt 0 \
      --thresholdsrc 0 \
      --srcdict ${DICT} \
      --workers 120
done


for lg in en es fr de ru; do
    echo $lg
    if [ ! -x $DATA_BIN/$lg ]; then
     mkdir $DATA_BIN/$lg
    fi

    python $CODE_ROOT/preprocess.py \
    --source-lang src \
    --target-lang tgt \
    --trainpref $DATA_SPM/$lg.train.spm \
    --validpref $DATA_SPM/$lg.dev.spm \
    --destdir $DATA_BIN/$lg \
    --thresholdtgt 0 \
    --thresholdsrc 0 \
    --srcdict ${DICT} \
    --tgtdict ${DICT} \
    --workers 120
done

echo "Done!"
