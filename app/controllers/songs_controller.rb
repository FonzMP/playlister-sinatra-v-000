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
      binding.pry

      song = Song.create(params[:song][:name])
      song.slug
      binding.pry

      @artist.songs << song
      @artist.save
      binding.pry

      redirect "/songs/#{song.slug_name}"
    else
      @artist = Artist.find(params[:song][:artist][:id])
      @artist.songs << @song
    end
    @artist.save

      # if !params[:genre][:name].empty?
      #   @genre = Genre.create(name: params[:genre][:name])
      #   @artist.genres << @genre
      # else
      #   params[:genre].each do |genre|
      #     @artist.genres << genre
      #   end
      # end
    redirect "/songs/#{@song.slug_name}"
  end


  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])

    erb :"/songs/show"
  end
end
