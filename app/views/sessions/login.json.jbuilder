json.status :ok
json.authentication_token current_user.authentication_token
json.user do
  json.partial! 'users/show', user: current_user
end