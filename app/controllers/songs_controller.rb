class SongsController < ApplicationController
    
    def index
        if params[:artist_id]
            @artist = Artist.find_by(id: params[:artist_id])
            if @artist.nil?
                redirect_to artists_path, flash[:alert] = "Artist not found"
            else
                @songs = @artist.songs
            end
        else
            @songs = Song.order('LOWER(name)').page(params[:page])
        # case insensitive
            @user_song = current_user.user_songs.build(user_id: current_user.id)
            session[:return_to] = request.referrer #keep track of what page they're on
        # if someone is logged in, initialize a new song for that user
        end
    end

    def show
        @song = Song.friendly.find(params[:id])
        # @song = Song.friendly.find(params[:slug ])
        if current_user.songs.exists?(@song.id)
            @user_song = current_user.user_songs.find_by(user_id: current_user.id, song_id: @song.id)
        end
        # will have to account for non-logged-in people
    end

    def new
        @song = Song.new
        @song.build_artist
        @song.build_genre
    end

    def create
        song = Song.new(song_params)
        if params[:song][:artist_id].empty?
            song.artist = Artist.find_or_create_by(name: params[:song][:artist_attributes][:name])
        else
            song.artist = Artist.find(params[:song][:artist_id])
        end
        if params[:song][:genre_id].empty?
            song.genre = Genre.find_or_create_by(name: params[:song][:genre_attributes][:name])
        else
            song.genre = Genre.find(params[:song][:genre_id])
        end
        if song.valid?
            song.save
            flash[:notice] = "#{song.full_title} has been successfully added to database!"
            redirect_to songs_path
        else
            flash[:notice] = "An error occurred during song creation"
            redirect_to new_song_path
        end
    end

    def edit
        @song = Song.friendly.find(params[:id])
        @artists = Artist.all
    end

    def update
        song = Song.friendly.find(params[:id])

        if params[:song][:artist_id].empty?
            song.artist = Artist.find_or_create_by(name: params[:song][:artist_attributes][:name])
        else
            song.artist = Artist.find(params[:song][:artist_id])
        end
        if params[:song][:genre_id].empty?
            song.genre = Genre.find_or_create_by(name: params[:song][:genre_attributes][:name])
        else
            song.genre = Genre.find(params[:song][:genre_id])
        end
        if song.valid?
            song.save
            flash[:notice] = "#{song.full_title} has been successfully updated"
            redirect_to artist_song_path
        else
            flash[:notice] = "An error occurred during song modification"
            redirect_to edit_artist_song_path
        end
    end

    private
    
    def song_params
        params.require(:song).permit(:name, :artist_id, :genre_id, :artist_attributes => [:name], :genre_attributes => [:name])
    end

end