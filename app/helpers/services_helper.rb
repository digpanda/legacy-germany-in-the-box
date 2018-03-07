module ServicesHelper
  def services_description
    Category.where(slug_name: 'services').first&.desc
  end
end
