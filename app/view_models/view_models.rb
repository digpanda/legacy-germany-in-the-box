class ViewModels

  attr_accessor :model

  def method_missing(method, *args, &block)
    @model.send(method, *args, &block)
  end

  def initialize(model)
    @model = model
  end

end
