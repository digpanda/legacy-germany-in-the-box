class ConsistencyDataReferrerProvisionOrder < Mongoid::Migration
  def self.up
    puts "Checking through all the referrer for data consistency ..."
    Referrer.all.each do |referrer|
      puts "Check Referrer `#{referrer.id}`"
      referrer.provisions.each do |provision|
        puts "Check Provision `#{provision.id}`"
        unless provision.order
          puts "Provision is orphan / has no order"
          provision.delete
          puts "Provision deleted."
        end
      end
    end
    puts 'End of process.'
  end

  def self.down
  end
end
