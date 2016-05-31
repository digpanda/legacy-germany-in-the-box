class ErrorsController < ActionController::Base # No application because it's a standalone service

    layout "errors/default"

    def page_not_found
    end
 
    def server_error
    end

end