json.array!(@brands) do |brand|
  json.extract! brand, :name
end
