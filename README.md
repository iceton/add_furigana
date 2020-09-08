# japanese_mecab
Tools for parsing and enriching Japanese

## What?
Add furigana notations to HTML or text

## Why?
MeCab discussion and documentation can be difficult to find and navigate, so I'm sharing some things I learned while making an Anki deck.

The Natto examples I saw choked on non-Japanese characters, so a sentence with a number like _3月は仕事が忙しい。_ wouldn't work, much less HTML. People refer to kanji as char_type 2, but some phrases with kanji like ご飯 are char_type 6. Parsing 10,000 strings is quick if you reuse Natto parsers, but you can't analyze two strings at the same time or the first will be interrupted.

## Usage

```rb
> require './add_furigana'
=> true
> af = AddFurigana.new
> af.enrich('今、朝ご飯を<b>作って</b>います。')
=> "今[いま]、 朝[あさ] ご飯[ごはん]を<b>作っ[つくっ]て</b>います。"
> af.enrich('雑誌にその女優の<b>対談</b>が載っていたよ。')
=> "雑誌[ざっし]にその 女優[じょゆー]の<b>対談[たいだん]</b>が 載っ[のっ]ていたよ。"
```
