# frozen_string_literal: true

require 'active_support/all'
require 'json'
require 'natto'
require 'nkf'
require 'nokogiri'

# Add Anki-style furigana to HTML
class AddFurigana
  EMPTY_YOMI = '*'
  KANJI_CHAR_TYPE = 2
  NKF_ARGS = '-h1 -w'

  def initialize
    # Using a new instance every time is slow. Can't parse two texts simultaneously.
    @natto_sentence = Natto::MeCab.new
    @natto_yomi = Natto::MeCab.new
  end

  def enrich(html_str)
    html_fragment = Nokogiri::HTML.fragment(html_str)
    html_nodes = child_nodes_or_self(html_fragment)
    html_nodes.each { |html_node| html_node.content = enrich_content(html_node.content) }
    html_fragment.to_html
  end

  private

  def child_nodes_or_self(node)
    node.children.present? ? node.children.flat_map { |c| child_nodes_or_self(c) } : node
  end

  def enrich_content(str)
    enriched_lang_nodes = []
    @natto_sentence.parse(str) do |lang_node|
      feature = lang_node.feature
      surface = lang_node.surface
      yomi = feature.split(',').last
      # has_kanji? catches some words like ご飯 which are node type 6
      if yomi != EMPTY_YOMI && surface != yomi && (lang_node.char_type == KANJI_CHAR_TYPE || has_kanji?(surface))
        hiragana = NKF.nkf(NKF_ARGS, yomi)
        enriched_surface = " #{surface}[#{hiragana}]"
        enriched_lang_nodes << enriched_surface
      else
        enriched_lang_nodes << surface
      end
    end
    enriched_lang_nodes.join.squish
  end

  def has_kanji?(str)
    kanji = nil
    str.chars.any? do |char|
      @natto_yomi.parse(char) do |lang_node|
        kanji = lang_node.surface if lang_node.char_type == KANJI_CHAR_TYPE
      end
      kanji
    end
  end
end
