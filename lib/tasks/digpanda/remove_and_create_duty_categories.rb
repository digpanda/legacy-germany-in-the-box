require 'csv'

class Tasks::Digpanda::RemoveAndCreateDutyCategories

  def initialize

    puts "We first delete the duty categories"
    DutyCategory.all.delete

    csv_file = File.join(Rails.root, 'vendor', 'bg-duty-categories.csv')
    puts "We fetch the appropriate CSV file"

    CSV.foreach(csv_file, quote_char: '"', col_sep: ';', row_sep: :auto, headers: true) do |row|

      if row[2].blank?
        DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => row[1].strip} )
      else

        if row[3].blank?
          parent = DutyCategory.where(:'name.en' => row[1].strip).first
          DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => row[2].strip}, :parent => parent )
        else
          
          if row[4].blank?
            parent = DutyCategory.where(:'name.en' => row[2].strip).first
            DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => row[3].strip}, :parent => parent )
          else
            parent = DutyCategory.where(:'name.en' => row[3].strip).first
            DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => row[4].strip}, :parent => parent )
          end

        end

      end

    end

    puts "End of process."

  end

end
