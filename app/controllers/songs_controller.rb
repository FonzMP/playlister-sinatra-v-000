require 'sinatra/base'
require 'rack-flash'

class SongsController < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  enable :sessions
  use Rack::Flash

  get '/songs/new' do
    erb :"/songs/new"
  end

  post '/songs' do

    if !params[:artist][:name].empty?
      @artist = Artist.create(name: params[:artist][:name])
      @song = Song.create(name: params[:song][:name])
      binding.pry
      @artist.songs << @song
      @song.artist_id = @artist.id
      params[:genres].each do |genre|
        @song.genres << Genre.find(genre)
      end
      @artist.save
    end

    flash[:message] = "Successfully created song."
    redirect to("/songs/#{@song.slug}")
  end


  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])

    erb :"/songs/show"
  end
end
