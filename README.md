# Add Furigana
Add [furigana](https://en.wikipedia.org/wiki/Furigana) (振り仮名/yomigana/読み仮名/ruby) notations to HTML or text

## Why?
MeCab discussion and documentation can be difficult to find and navigate, so I'm sharing some things I learned while making an Anki deck.

The Natto examples I saw choked on non-Japanese characters, so a sentence with a number like _3月は仕事が忙しい。_ wouldn't work, much less HTML. People refer to kanji as char_type 2, but some phrases with kanji like ご飯 are char_type 6. Parsing 10,000 strings is quick if you reuse Natto parsers, but you can't analyze two strings at the same time or the first will be interrupted. Natto is also picky about what happens it its `parse` block.

## Setup

MeCab and IPAdic are required. Installing with homebrew worked before, but on a newer ARM Mac, charset defaults seem to derail this. Downloading the [source](https://taku910.github.io/mecab/#download), configuring with [`--enable-utf8-only`](https://taku910.github.io/mecab/#utf-8), and installing work for me.

```
mecab-0.996 > ./configure --enable-utf8-only
mecab-0.996 > make install
mecab-ipadic-2.7.0-20070801 > ./configure --enable-utf8-only
mecab-ipadic-2.7.0-20070801 > make install
```

`make install` may require `sudo`. Update `/usr/local/lib/mecab/dic/ipadic/dicrc` to specify `config-charset = UTF-8` too.

## Usage

```rb
> af = AddFurigana.new

> af.enrich('今、朝ご飯を<b>作って</b>います。')
=> "今[いま]、 朝[あさ] ご飯[ごはん]を<b>作っ[つくっ]て</b>います。"

> af.enrich('雑誌にその女優の<b>対談</b>が載っていたよ。')
=> "雑誌[ざっし]にその 女優[じょゆー]の<b>対談[たいだん]</b>が 載っ[のっ]ていたよ。"

> af.enrich('32ページを<b>開いて</b>ください。')
=> "32ページを<b>開い[ひらい]て</b>ください。"
```
