class Tasks::Digpanda::CheckDatabaseConsistency

  def initialize

    puts "We go through FactoryGirl factories and check if they are valid ..."
    if Rails.env.test?
      begin
        #DatabaseCleaner.start
        FactoryGirl.lint
      ensure
        #DatabaseCleaner.clean
      end
    else
      puts "We switch to test environment."
      system("bundle exec rake digpanda:check_database_consistency RAILS_ENV='test'")
    end
    puts 'End of process.'

  end

end