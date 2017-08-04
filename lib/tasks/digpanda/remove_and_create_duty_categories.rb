require 'csv'

class Tasks::Digpanda::RemoveAndCreateDutyCategories

  BORDER_GURU_FILE = 'border-guru-duty-categories.csv'

  # add `to_slug` functionality to strings
  String.include CoreExtensions::String::SlugConverter

  def initialize

    puts "We are running on `#{Rails.env}` environment"
    puts 'We clear the file cache'
    Rails.cache.clear

    puts 'We first delete the duty categories'
    DutyCategory.delete_all

    csv_fetch do |column|

      code = column[0]
      if code.empty?
        puts 'There we a problem trying to generate `code`'
        return
      end

      if master?(column)
        name = column[1]
        puts "Parent : NONE / Self : #{name}"
        DutyCategory.create!(:code => code, :name_translations => {en: name})
      end

      if submaster?(column)
        parent_name = column[1]
        name = column[2]
        puts "Parent : #{parent_name} / Self : #{name}"
        DutyCategory.create!(:code => code, :name_translations => {en: name}, :parent => duty_finder(parent_name))
      end

      if slave?(column)
        parent_name = column[2]
        name = column[3]
        puts "Parent : #{parent_name} / Self : #{name}"
        DutyCategory.create!(:code => code, :name_translations => {en: name}, :parent => duty_finder(parent_name))
      end

    end

    puts 'End of process.'

  end

  def csv_fetch
    CSV.foreach(csv_file, quote_char: '"', col_sep: ';', row_sep: :auto, headers: false) do |column|
      yield(column.map(&:to_s).map(&:strip))
    end
  end

  def csv_file
    @csv_file ||= File.join(Rails.root, 'vendor', BORDER_GURU_FILE)
  end

  def duty_finder(name)
    category = DutyCategory.where(slug: name.to_slug).order_by(c_at: 'desc').order_by(:_id => 'desc').first
    if category.nil?
      puts 'DutyCategory searched but not found, exiting.'
      exit
    end
    category
  end

  def master?(column)
    column[1].present? && column[2].empty? && column[3].empty?
  end

  def submaster?(column)
    column[1].present? && column[2].present? && column[3].empty?
  end

  def slave?(column) # funny name right
    column[1].present? && column[2].present? && column[3].present?
  end

end
