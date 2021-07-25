class SongsController < ApplicationController
    
    def index
        @songs = Song.order('LOWER(name)')
        if params[:view]        
            if params[:view] == "owned"
                @songs = @songs.owned(current_user).page(params[:page])
            else 
                if params[:view] == "unowned"
                    @songs = @songs.unowned(current_user).page(params[:page])
                end
            end
        end
        if params[:sort]
            # @songs = Song.sorted(params[:sort]).order("#{params[:page]}")
            @songs = Song.joins(:"#{params[:sort]}").order("#{params[:sort]}s.name").page(params[:page])
        else
            @songs = @songs.page(params[:page])
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
        if params[:artist_id]
            @song = Song.new
            @song.artist = Artist.friendly.find(params[:artist_id])
            @song.build_genre
        else
            @song = Song.new
            # params[:artist_id] ? @song.artist = Artist.friendly.find(params[:artist_id]) : @song.build_artist
            @song.build_artist
            # binding.pry
            @song.build_genre
        end
    end

    def create
        @song = Song.new(song_params)
        if params[:song][:artist_id].empty?
            @song.artist = Artist.find_or_create_by(name: params[:song][:artist_attributes][:name])
        # else
        #     song.artist = Artist.find(params[:song][:artist_id])
        end
        if @song.valid?
            @song.save
            flash[:notice] = "#{@song.full_title} has been successfully added to database!"
            redirect_to songs_path
        else
            @song.destroy
            render 'songs/new'
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
        params.require(:song).permit(:name, :artist_id, :genre_id, :year, :vocal_parts, :artist_attributes => [:name])#, :genre_attributes => [:name])
    end

    def update_song_params
        params.require(:song).permit(:name, :artist_id, :genre_id, :year, :vocal_parts)
    end

end