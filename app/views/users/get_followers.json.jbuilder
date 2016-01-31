json.array!(@users) do |u|
  json.extract! u, :id, :username, :country, :pic
end
