class Web < Sinatra::Base

  set :raise_errors, false
  set :show_exceptions, false

  before do
    content_type :json
  end

  error do
    exception = env['sinatra.error']
    if exception.class == MongoMapper::DocumentNotFound
      status 404
    else
      status 500
    end
    { :error => { :message => exception.message } }.to_json
  end

  get '/' do
    'hello'
  end

  get '/search' do
    Article.find_by_url!(params['url']).to_json(:except => [:id, :article_index_id, :type])
  end

end