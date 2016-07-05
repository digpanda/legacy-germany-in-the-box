require 'csv'

class Tasks::Digpanda::RemoveAndCreateDutyCategories

  #Todo: can also to create categories in a recursive way, but for the man who do it later.
  def initialize

    puts "We clear the file cache"
    Rails.cache.clear

    puts "We first delete the duty categories"
    DutyCategory.all.delete

    csv_file = File.join(Rails.root, 'vendor', 'bg-duty-categories.csv')
    puts "We fetch the appropriate CSV file"

    level1 = {}
    level2 = {}
    level3 = {}

    CSV.foreach(csv_file, quote_char: '"', col_sep: ';', row_sep: :auto, headers: false) do |row|

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
