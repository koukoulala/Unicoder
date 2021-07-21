from pygoogletranslation import Translator
import argparse

def main(source_file, target_file, source_lang, target_lang):
    NO_OF_ATTEMPTS=10
    WAIT_SECONDS=20
    translator = Translator(retry=NO_OF_ATTEMPTS, sleep=WAIT_SECONDS, retry_messgae=True)

    file2 = open(target_file, mode='a', encoding='utf-8')
    bad_case = []
    with open(source_file, mode='r', encoding='utf-8') as f:
        num = 0
        for line in f:
            if num % 50 == 0:
                print('now dealing %s', num)
            line = line.strip()
            try:
                target_line = translator.translate(line, dest=target_lang).text
            except Exception as e:
                print("error: ", e)
                bad_case.append(num)
                file2.write('\n')

            if len(line) != 0 and len(target_line) != 0:
                file2.write(target_line + '\n')
            else:
                bad_case.append(num)
                file2.write('\n')

            num += 1
    file2.close()
    print("num of bad case", len(bad_case), bad_case)
    print("total number", num)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Language translate")
    parser.add_argument("--source_file", type=str, required=True,
                        help="source_file")
    parser.add_argument("--target_file", type=str, required=True,
                        help="target_file")
    parser.add_argument("--source_lang", type=str, default="en",
                        help="source_lang")
    parser.add_argument("--target_lang", type=str, default="de",
                        help="target_lang")
    args = parser.parse_args()

    for i in range(60):
        s = "%02d" % i
        source_file = args.source_file + "_" + s + ".txt"
        target_file = args.target_file + "_" + s + ".txt"
        source_lang = args.source_lang
        target_lang = args.target_lang

        main(source_file, target_file, source_lang, target_lang)