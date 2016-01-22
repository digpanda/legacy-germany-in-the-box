class I18n
  include Mongoid::Document

  field :locale, type: Symbol
  field :key, type: Symbol
  field :value, type:String
end