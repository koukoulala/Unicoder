import argparse
import random
from random import randint
import os

def main(source_src_file, target_src_file, source_tgt_file, target_tgt_file):
    oldf_src = open(source_src_file, 'r', encoding='utf-8')
    newf_src = open(target_src_file, 'w', encoding='utf-8')
    oldf_tgt = open(source_tgt_file, 'r', encoding='utf-8')
    newf_tgt = open(target_tgt_file, 'w', encoding='utf-8')
    n = 0
    resultList = random.sample(range(0, 300000), 30000)

    lines = oldf_src.readlines()
    for i in resultList:
        newf_src.write(lines[i])
    oldf_src.close()
    newf_src.close()

    lines = oldf_tgt.readlines()
    for i in resultList:
        newf_tgt.write(lines[i])
    oldf_tgt.close()
    newf_tgt.close()

    print("done")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Language translate")
    parser.add_argument("--root_path", type=str, default="../../../Datasets/NTG_aug/",
                        help="root_path")
    args = parser.parse_args()

    source_src_file = os.path.join(args.root_path, "xglue.ntg.en.src.train")
    target_src_file = os.path.join(args.root_path, "sampled_xglue.ntg.en.src.train")
    source_tgt_file = os.path.join(args.root_path, "xglue.ntg.en.tgt.train")
    target_tgt_file = os.path.join(args.root_path, "sampled_xglue.ntg.en.tgt.train")

    main(source_src_file, target_src_file, source_tgt_file, target_tgt_file)

