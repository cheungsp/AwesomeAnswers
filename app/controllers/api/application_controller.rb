class Api::ApplicationController < ApplicationController
  # this will not throw an exception if an authenticity token is not passed.
  # in other words, this will aloow post requests to be made
  # from toolds other than a form rendered by rails
  skip_before_action :verify_authenticity_token

  def current_user
    @user ||= User.find_by(api_key: params[:api_key]) unless params[:api_key].nil?
  end

  private
  def api_key
    # this grabs the api_key from the `Authorization` headers
    # in the http request. It expects it to be in this format:
    # "Apikey <the-api-key>"
    match = request.headers['AUTHORIZATION'].match(/^Apikey (.+)/)
    match.length == 2 ? match[1] : nil
  end
end
