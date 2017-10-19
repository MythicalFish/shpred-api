module ApiResponse
  
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :handle_exception
  end

  def handle_exception e
    log_error e, e.class.to_s
    render error_response(e)
  end

  def render_success message, payload = nil
    render json: {
      message: message,
      payload: payload
    }
  end

  def render_warning message
    raise CustomException::UserWarning.new(message)
  end

  def render_error object
    raise CustomException::UserError.new(object)
  end

  def render_denied object
    raise CustomException::PermissionError.new(object)
  end

  def render_fatal data
    raise Exception.new(data)
  end

  def log_error e, title = "ERROR"
    msg = "\n\n\n\n"
    msg << "<!--- #{title} --->\n\n"
    msg << e.message
    msg << "\n\n"
    msg << e.backtrace.join("\n")
    msg << "\n\n\n\n"
    logger.error msg
    if defined? NewRelic
      NewRelic::Agent.notice_error(e)
    end
  end

  def error_response e
    
    msg = "Something went wrong, we'll look into it!"
    trace = nil

    if expose_error? e
      if e.try(:errors)
        msg = e.errors.full_messages.join("\n")
      elsif e.try(:message)
        msg = e.message
      end
    end

    if log_exception? e
      if Rails.env.development?
        if e.backtrace
          trace = "API says no: \n\n"
          trace += " " + e.message + "\n" + e.backtrace.take(10).join("\n")
          trace += "\n..." if e.backtrace.size > 10
        end
      end
    end

    if error_type(e) == 'auth'
      msg = "Unauthorized"
    end

    if error_type(e) == 'warning'
      return {
        json: {
          message: msg,
          response: nil
        }
      }
    end

    {
       json: {
        error: {
          message: msg,
          fields: error_fields(e),
          backtrace: trace,
          type: error_type(e)
        },
        status: :unprocessable_entity
      }
    }

  end

  def expose_error? e
    [
      CustomException::UserError, 
      CustomException::PermissionError, 
      CustomException::UserWarning, 
      ActiveRecord::RecordInvalid
    ].include? e.class
  end

  def log_exception? e
    !expose_error?(e)
  end

  def error_type e
    return 'warning' if e.class == CustomException::UserWarning
    'bug'
  end

  def error_fields e
    return {} unless e.try(:record).try(:errors)
    e.record.errors.messages
  end

end