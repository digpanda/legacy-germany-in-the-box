json.array!(@collections) do |c|
  if c.user
    json.id c.id
    json.name c.name
    json.desc c.desc

    json.owner do
      json.partial! 'users/show_info', user: current_user
    end
  end
end
