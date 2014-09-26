json.array!(@words) do |word|
  json.extract! word, :id, :han, :pinyin, :meaning
  json.url word_url(word, format: :json)
end
