module PackageSetHelper
  def package_set_highlight?
    Setting.instance.package_sets_highlight
  end

  def landing_page_highlight?
    Setting.instance.landing_page_highlight
  end
end
