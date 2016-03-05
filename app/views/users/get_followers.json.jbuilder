json.array!(@users) do |u|
  json.partial! 'show_info', user: @user
end
