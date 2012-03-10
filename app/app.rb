module Hopper
  class App < Sinatra::Base
    register Mustache::Sinatra

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/frontend/public"
    set :static, true
    set :mustache, {
      :namespace => Hopper,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }

    get '/' do
      mustache :index
    end

    get '/projects' do
      mustache :projects
    end
  end
end