module PackageSetHelper

  def package_set_highlight?
    Setting.instance.package_sets_highlight
  end

end
