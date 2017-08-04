require 'csv'

class Tasks::Digpanda::RefreshDutyCategoriesTaxes

  BORDER_GURU_FILE = 'border-guru-duty-categories-taxes.csv'

  def initialize

    puts "We are running on `#{Rails.env}` environment"
    puts "We clear the file cache"
    Rails.cache.clear

    csv_fetch do |column|

      code = column[0]
      if code.empty?
        puts "There we a problem trying to recover `code`"
        return
      end

      tax_rate = column[1]
      if tax_rate.empty?
        puts "There we a problem trying to recover `tax_rate`"
        return
      end
      tax_rate = tax_rate.gsub(/[^0-9]/, '').to_f

      duty_category = DutyCategory.where(code: code).first
      if duty_category.nil?
        puts "We did not find the DutyCategory with code `#{code}`"
        return
      end

      duty_category.tax_rate = tax_rate
      duty_category.save
      
      puts "DutyCategory #{duty_category.id} refresh with tax rate `#{tax_rate}`"

    end

    puts 'End of process.'

  end

  def csv_fetch
    CSV.foreach(csv_file, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |column|
      yield(column.map(&:to_s).map(&:strip))
    end
  end

  def csv_file
    @csv_file ||= File.join(Rails.root, 'vendor', BORDER_GURU_FILE)
  end

end
