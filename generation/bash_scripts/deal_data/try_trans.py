from pygoogletranslation import Translator
import argparse
import numpy as np
import os

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
            line = line.strip()
            if len(line) > 4891:
                print("using doc translation")
                tmp_file = open(os.path.join(root_path, 'tmp.txt'), 'w', encoding='utf-8')
                tmp_file.write(line)
                tmp_file.close()
                try:
                    target_line = translator.bulktranslate(os.path.join(root_path, 'tmp.txt'), dest=target_lang).text
                except Exception as e:
                    print("error: ", num, len(line), e)
                    bad_case.append(num)
                    file2.write('\n')
                    num += 1
                    continue
            else:
                try:
                    target_line = translator.translate(line, dest=target_lang).text
                except Exception as e:
                    print("error: ", num, len(line), e)
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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Language translate")
    parser.add_argument("--root_path", type=str, default="../../datasets/trans/",
                        help="root_path")
    parser.add_argument("--split", type=str, default="src",
                        help="split")
    parser.add_argument("--target_lang", type=str, default="de",
                        help="target_lang")
    args = parser.parse_args()

    source_file = os.path.join(args.root_path, "sampled_xglue.ntg.en." + args.split + ".train")
    target_file = os.path.join(args.root_path, "sampled_xglue.ntg." + args.target_lang + "." + args.split + ".train")
    target_lang = args.target_lang

    print("\n source_file name:", source_file)

    all_badcase = main(args.root_path, source_file, target_file, target_lang)
    print(all_badcase)
    np.save(os.path.join(args.root_path, "all_badcase_" + args.target_lang + "_" + args.split + ".npy"), all_badcase)