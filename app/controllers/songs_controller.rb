class SongsController < ApplicationController
    
    
    def index
        if params[:artist_id]
            @artist = Artist.find_by(id: params[:artist_id])
            if @artist.nil?
                redirect_to artists_path, flash[:alert] = "Artist not found"
            else
                @songs = @artist.songs
            end
        end
        # binding.pry
        if params[:view]
            # binding.pry
            if params[:view] == "owned"
                @songs = Song.owned(current_user).order('LOWER(name)').page(params[:page])
            else 
                if params[:view] == "unowned"
                    @songs = Song.unowned(current_user).order('LOWER(name)').page(params[:page])
                end
                # binding.pry
            end
        else
            @songs = Song.order('LOWER(name)').page(params[:page])
        end
        if current_user
            @user_song = current_user.user_songs.build(user_id: current_user.id)
        end
        session[:return_to] = request.referrer #keep track of what page they're on
        # if someone is logged in, initialize a new song for that user
    end

    def show
        @song = Song.friendly.find(params[:id])
        @user_song = UserSong.where(song_id: @song.id)
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
            redirect_to new_song_path
        end
    end

    def edit
        @song = Song.friendly.find(params[:id])
        @artist = @song.artist
    end

    def update
        @song = Song.friendly.find(params[:id])
        if @song.update(update_song_params)
            flash[:notice] = "#{@song.full_title} has been successfully updated"
            redirect_to artist_song_path(@song.artist, @song)
        else
            render 'songs/edit'
        end
    end

    private
    
    def song_params
        params.require(:song).permit(:name, :artist_id, :genre_id, :year, :vocal_parts, :artist_attributes => [:name], :genre_attributes => [:name])
    end

    def update_song_params
        params.require(:song).permit(:name, :artist_id, :genre_id, :year, :vocal_parts)
    end

    def view_params
        params.permit(:view)
    end
end