class BaseService

  def return_with(state, data=nil)
    case state
    when :error
      Response.new(false, data)
    when :success
      Response.new(true, data)
    else throw "Bad state."
    end
  end

end

Response = Struct.new(:success?, :data)
