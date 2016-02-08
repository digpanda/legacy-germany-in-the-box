json.array!(@addresses) do |a|
  json.extract! a, :id, :street_building_room, :district, :city, :province, :zip, :country, :primary, :email, :mobile, :tel, :fname, :lname
end
