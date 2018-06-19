class SongsController < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }



  get '/songs/new' do
    erb :"/songs/new"
  end

  post '/songs' do

    if !params[:artist][:name].empty?
      @artist = Artist.create(name: params[:artist][:name])
      @song = Song.create(name: params[:song][:name])
      @artist.songs << @song
      params[:genres].each do |genre|
        @song.genres << Genre.find(genre)
      end
      @artist.save

      flash[:message] = "Successfully created song."
      redirect to("/songs/#{@song.slug}")
    end


  end


  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])

    erb :"/songs/show"
  end
end
