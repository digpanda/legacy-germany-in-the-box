class BaseService

  def return_with(state, message=nil)
    case state
    when :error
      Response.new(false, message)
    when :success
      Response.new(true)
    else throw "Bad state."
    end
  end
  
end

Response = Struct.new(:success?, :message)