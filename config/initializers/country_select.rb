CountrySelect::FORMATS[:translated] = lambda do |country|
  # list of countries translated in German ("DE")
  "#{ISO3166::Country.translations("DE")[country.alpha2]} (#{country.alpha2})"
end
