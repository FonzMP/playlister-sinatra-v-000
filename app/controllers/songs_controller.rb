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

    @artist = Artist.find_by(name: params[:artist][:name])

    if !@artist
      @artist = Artist.create(name: params[:artist][:name])
      @song = Song.create(name: params[:song][:name])
      @artist.songs << @song
      @song.artist_id = @artist.id
      @song.genres << Genre.find(params[:genres])
      @artist.save
    else
      @song = Song.create(name: params[:song][:name])
      @artist.songs << @song
      @song.artist_id = @artist.id
      @song.genres << Genre.find(params[:genres])
      @artist.save
    end
    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  end


  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])

    erb :"/songs/show"
  end

  get '/songs/:slug/edit'
end
