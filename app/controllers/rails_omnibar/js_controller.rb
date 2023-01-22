# This returns the pre-compiled JS for the frontend component.
# Yes, that is a hacky way to make the gem work without
# forcing users to install and integrate an npm package.
class RailsOmnibar::JsController < RailsOmnibar::BaseController
  JS_FILE = File.join(__dir__, '..', '..', '..', 'javascript', 'compiled.js')

  def show
    expires_in 1.day, public: true
    send_file JS_FILE, type: 'text/javascript', disposition: 'inline'
  end
end
