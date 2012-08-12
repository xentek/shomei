require 'spec_helper'

describe 'Shomei' do

  def app
    Sinatra::Application
  end

  it "works!" do
    get '/'
    last_response.should be_ok
  end

end
