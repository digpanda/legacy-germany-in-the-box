module Imageable
  extend ActiveSupport::Concern

  included do

    def extension_white_list
      %w(jpg jpeg png)
    end

  end

end
