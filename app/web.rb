class Web < Sinatra::Base

  set :raise_errors, false
  set :show_exceptions, false

  before do
    content_type :json
  end

  error do
    exception = env['sinatra.error']
    status 500
    { :error => { :message => exception.message } }.to_json
  end

  get '/search' do
    Article.first(:url => params['url']).to_json(:except => [:id, :article_index_id, :type])
  end

end