class SongsController < ApplicationController
    
    def index
        @songs = Song.order(:name).page(params[:page])
        @user_song = current_user.user_songs.build(user_id: current_user.id)
        # if someone is logged in, initialize a new song for that user
    end

    def show
        @song = Song.friendly.find(params[:id])
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
        song = Song.new(new_song_params)
        binding.pry
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
            redirect_to songs_path
        end
    end

    def edit
        @song = Song.friendly.find(params[:id])
        @artists = Artist.all
    end

    def update
        @song = Song.friendly.find(params[:id])
        @song.update(song_params)
        redirect_to @song
    end

    def song_artist_search
        if !params[:query].empty?
            @artists = Artist.where("name LIKE ?", "%#{params[:query]}")
            binding.pry
        end
    end

    private

    # def song_params 
    #     params.require(:song).permit(:artist_id) # this is temporary so i can fix the mismatched artists
    # end
    # we can build just patch them now
    
    def new_song_params
        params.require(:song).permit(:name, :artist_id, :genre_id, :artist_attributes => [:name], :genre_attributes => [:name])
    end

end