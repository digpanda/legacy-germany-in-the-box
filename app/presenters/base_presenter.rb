class BasePresenter < SimpleDelegator
  def initialize(model)
    @model, @view = model
    super(@model)
  end
end