class NotificationsRemovedForAllAdmins < Mongoid::Migration
  def self.up
    Notification.all.each do |notification|
      unless notification.user
        puts "Notification #{notification.id} without user deleted."
        notification.delete
        next
      end
      if notification.user.admin?
        puts "Deleting notification `#{notification.id}` related to Admin `#{notification.user.id}` ..."
        notification.delete
        puts "Done."
      end
    end
  end

  def self.down
  end
end
