require 'csv'

class Tasks::Digpanda::RemoveAndCreateDutyCategories

  def csv_fetch
    CSV.foreach(csv_file, quote_char: '"', col_sep: ';', row_sep: :auto, headers: false) do |column|
      yield(column.map(&:to_s).map(&:strip))
    end
  end

  def csv_file
    @csv_file ||= File.join(Rails.root, 'vendor', 'border-guru-duty-categories.csv')
  end

  def initialize

    puts "We clear the file cache"
    Rails.cache.clear

    puts "We first delete the duty categories"
    DutyCategory.delete_all

    csv_fetch do |column|

      code = column[0]
      if code.empty?
        puts "There we a problem trying to generate `code`"
        return
      end

      #DutyCategory.where()

      binding.pry

      if row[2].blank?

        l1_name = row[1].strip
        l1 = DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => l1_name} )

        level1[l1_name]=l1

      else

        if row[3].blank?

          l1_name = row[1].strip
          l1 = level1[l1_name]

          l2_name = row[2].strip
          l2 = DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => l2_name }, :parent => l1 )

          level2[[l1_name, l2_name]] = l2

        else

          if row[4].blank?

            l1_name = row[1].strip
            l2_name = row[2].strip
            l2 = level2[[l1_name, l2_name]]

            l3_name = row[3].strip
            l3 = DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => l3_name }, :parent => l2 )

            level3[[l1_name, l2_name, l3_name]] = l3
          else

            l1_name = row[1].strip
            l2_name = row[2].strip
            l3_name = row[3].strip
            l3 = level3[[l1_name, l2_name, l3_name]]

            l4_name = row[4].strip
            DutyCategory.create!(:code => row[0].strip, :name_translations => {:en => l4_name}, :parent => l3 )

          end

        end

      end

    end

    puts "End of process."

  end

end
