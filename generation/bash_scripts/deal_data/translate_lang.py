import urllib.request
import execjs
import argparse
import logging
from googletrans import Translator

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', filename='log.txt')
logger = logging.getLogger()

translator = Translator(service_urls=['translate.google.cn'])

class Yuguii():

    def __init__(self):
        self.ctx = execjs.compile(""" 
        function TL(a) { 
        var k = ""; 
        var b = 406644; 
        var b1 = 3293161072; 

        var jd = "."; 
        var $b = "+-a^+6"; 
        var Zb = "+-3^+b+-f"; 

        for (var e = [], f = 0, g = 0; g < a.length; g++) { 
            var m = a.charCodeAt(g); 
            128 > m ? e[f++] = m : (2048 > m ? e[f++] = m >> 6 | 192 : (55296 == (m & 64512) && g + 1 < a.length && 56320 == (a.charCodeAt(g + 1) & 64512) ? (m = 65536 + ((m & 1023) << 10) + (a.charCodeAt(++g) & 1023), 
            e[f++] = m >> 18 | 240, 
            e[f++] = m >> 12 & 63 | 128) : e[f++] = m >> 12 | 224, 
            e[f++] = m >> 6 & 63 | 128), 
            e[f++] = m & 63 | 128) 
        } 
        a = b; 
        for (f = 0; f < e.length; f++) a += e[f], 
        a = RL(a, $b); 
        a = RL(a, Zb); 
        a ^= b1 || 0; 
        0 > a && (a = (a & 2147483647) + 2147483648); 
        a %= 1E6; 
        return a.toString() + jd + (a ^ b) 
    }; 

    function RL(a, b) { 
        var t = "a"; 
        var Yb = "+"; 
        for (var c = 0; c < b.length - 2; c += 3) { 
            var d = b.charAt(c + 2), 
            d = d >= t ? d.charCodeAt(0) - 87 : Number(d), 
            d = b.charAt(c + 1) == Yb ? a >>> d: a << d; 
            a = b.charAt(c) == Yb ? a + d & 4294967295 : a ^ d 
        } 
        return a 
    } 
    """)

    def getTk(self, text):
        return self.ctx.call("TL", text)

def open_url(url):
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20100101 Firefox/23.0'}
    req = urllib.request.Request(url=url, headers=headers)
    response = urllib.request.urlopen(req)
    data = response.read().decode('utf-8')
    return data


def translate(content, tk, source_lang, target_lang, num):
    if len(content) > 4891:
        print("翻译文本超过限制！", num)
        return ""

    content = urllib.parse.quote(content)

    url = "http://translate.google.cn/translate_a/single?client=t" \
          "&sl=%s&tl=%s&hl=%s&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca" \
          "&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&clearbtn=1&otf=1&pc=1" \
          "&srcrom=0&ssel=0&tsel=0&kc=2&tk=%s&q=%s" % (source_lang, target_lang, target_lang, tk, content)


    result = open_url(url)

    end = result.find("\",")
    if end > 4:
        return result[4:end]
    else:
        return ""

def totaltranslate(source_file, target_file, source_lang, target_lang, js):
    file2 = open(target_file, mode='a', encoding='utf-8')
    bad_case = []
    with open(source_file, mode='r', encoding='utf-8') as f:
        num = 0
        for line in f:
            line = line.strip()
            tk = js.getTk(line)
            target_line = translate(line, tk, source_lang, target_lang, num)

            if len(line) != 0 and len(target_line) != 0:
                file2.write(target_line + '\n')
            else:
                bad_case.append(num)
                file2.write('\n')

            if num % 50 == 0:
                logger.info('finish above sentence, now at', num)
                print('finish above sentence, now at %s', num)
            num += 1
    file2.close()
    print("num of bad case", len(bad_case))

def sentencetranslate(line, source_lang, target_lang):
    line = line.strip()
    text = translator.translate(line, src=source_lang, dest=target_lang).text
    return text

def completetranslate(source_file, target_file, final_file, source_lang, target_lang):
    file1 = open(target_file, target_file, mode='r', encoding='utf-8')
    file2 = open(final_file, mode='a', encoding='utf-8')
    i = 1
    bad_case = []
    with open(source_file, mode='r', encoding='utf-8') as f:
        for line in f:
            t = file1.readline()
            if len(t) == 1:  #'only \n'
                text = sentencetranslate(line, source_lang, target_lang)
                bad_case.append(i)
                file2.write(text+'\n')
            else:
                file2.write(t)
            i += 1
            if i % 100 == 0:
                print(i)
    file1.close()
    file2.close()
    print("num of added case", len(bad_case))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Language translate")
    parser.add_argument("--source_file", type=str, required=True,
                        help="source_file")
    parser.add_argument("--target_file", type=str, required=True,
                        help="target_file")
    parser.add_argument("--final_file", type=str, required=True,
                        help="final_file")
    parser.add_argument("--source_lang", type=str, default="en",
                        help="source_lang")
    parser.add_argument("--target_lang", type=str, default="de",
                        help="target_lang")
    args = parser.parse_args()

    source_file = args.source_file
    target_file = args.target_file
    final_file = args.final_file
    source_lang = args.source_lang
    target_lang = args.target_lang

    js = Yuguii()
    totaltranslate(source_file, target_file, source_lang, target_lang, js)
    completetranslate(source_file, target_file, final_file, source_lang, target_lang)