module Helpers
  module Global
    module_function

    def random_time
      rand * Time.now.utc.to_i
    end

    def random_date
      Time.at(random_time).strftime('%F')
    end

    def random_year
      Time.at(random_time).year
    end

    def next_number(symbol)
      User.where(role: symbol).count + 1
    end

    def random_gender
      ['f', 'm'].sample
    end
  end
end
