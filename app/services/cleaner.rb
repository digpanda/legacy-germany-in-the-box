module Cleaner
  module_function

  # TODO : this method was abstracted real fast to clean up the CSV generations
  # you could refactor it.
  def slug(string, characters = nil)
    unless string
      return ''
    end
    string = string.squish.downcase.strip
    string = I18n.transliterate(string)
    string = string.gsub(/[^\w-]/, ' ').gsub(/\s+/, ' ')
    if characters
      string = string[0..characters]
    end
    string
  end
end
