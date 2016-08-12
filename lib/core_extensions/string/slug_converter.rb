module CoreExtensions
  module String
    module SlugConverter
      def to_slug
        self.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      end
    end
  end
end
