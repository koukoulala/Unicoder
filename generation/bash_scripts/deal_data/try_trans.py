from pygoogletranslation import Translator
import argparse
import numpy as np
import os
from googletrans import Translator as TransGoogle
import glob

headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
translator_2 = TransGoogle(service_urls=['translate.google.cn'])


def main(root_path, source_file, target_file, target_lang):
    NO_OF_ATTEMPTS=10
    WAIT_SECONDS=20
    translator = Translator(retry=NO_OF_ATTEMPTS, sleep=WAIT_SECONDS, retry_messgae=True)

    if os.path.exists(target_file):
        os.remove(target_file)
    file2 = open(target_file, mode='a', encoding='utf-8')
    bad_case = []
    with open(source_file, mode='r', encoding='utf-8') as f:
        num = 0
        target_line = []
        for line in f:
            if num % 50 == 0:
                print('now dealing %s', num)
            # line = line.strip()
            try:
                target_line = translator.translate(line, dest=target_lang).text
            except Exception as e:
                print("error: ", num, len(line), e)
                try:
                    target_line = translator_2.translate(line, src="en", dest=target_lang).text
                except Exception as e:
                    print("still error: ", num, len(line), e)
                    bad_case.append(num)
                    file2.write('\n')
                    num += 1
                    continue

            if len(line) != 0 and len(target_line) != 0:
                file2.write(target_line + '\n')
            else:
                bad_case.append(num)
                file2.write('\n')

            num += 1
    file2.close()
    print("num of bad case", len(bad_case), bad_case)
    print("total number", num)

    return bad_case

def truncate(data_path):
    L = args.max_len - args.append_offset
    for fs in glob.glob(data_path):
        print(fs)
        wf = open(fs + ".truncated", 'w')
        with open(fs, 'r') as rf:
            for l in rf:
                x = " ".join(l.strip().split()[:L])
                wf.write(x + '\n')
        wf.close()
        os.system("mv {}.truncated {}".format(fs, fs))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Language translate")
    parser.add_argument("--root_path", type=str, default="../../datasets/sampled_NTG/",
                        help="root_path")
    parser.add_argument("--split", type=str, default="src",
                        help="split")
    parser.add_argument("--target_lang", type=str, default="de",
                        help="target_lang")
    parser.add_argument("--max_len", type=int, default=1024,
                        help="max input length")
    parser.add_argument("--append_offset", type=int, default=4,
                        help="offset for appending/prepending bos eos, etc")
    args = parser.parse_args()

    source_file = os.path.join(args.root_path, "xglue.ntg.en." + args.split + ".train")
    target_file = os.path.join(args.root_path, "xglue.ntg." + args.target_lang + "." + args.split + ".train")
    target_lang = args.target_lang

    print("source_file name:", source_file)
    print("target_file name:", target_file)

    truncate(source_file)

    all_badcase = main(args.root_path, source_file, target_file, target_lang)
    print(all_badcase)
    np.save(os.path.join(args.root_path, "badcase_" + args.target_lang + "_" + args.split + ".npy"), all_badcase)