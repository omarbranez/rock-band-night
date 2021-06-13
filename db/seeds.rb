
    agent_1 = Mechanize.new
    artist_data = agent_1.get("https://rbdb.io/v3/artists")
    artist_data = JSON.parse(artist_data.body)
    artist_data.flatten[3].each do |artist|
        # binding.pry
        artist_hash = {}
        artist_hash[:article] = artist["article"]
        artist_hash[:name] = artist["name"]
        Artist.where(artist_hash).first_or_create
    end

    get the song data, get the artist id, get name of artist, reconcile with local DB
    do same with genre # actually need to do genres first
    agent_3 = Mechanize.new
    genre_data = agent_3.get("https://rbdb.io/v3/genres")
    genre_data = JSON.parse(genre_data.body)
    genre_data["collection"].each do |genre|
        genre_hash = {}
        genre_hash[:name] = genre["name"]
        Genre.where(genre_hash).first_or_create
    end

    agent_2 = Mechanize.new
    song_data = agent_2.get("https://rbdb.io/v3/songs")
    song_data = JSON.parse(song_data.body)
    song_data["collection"].each do |song| 
        song_hash = {}
        song_hash[:article] = song["article"]        
        song_hash[:name] = song["name"]
        song_artist = song["artist"]
            song_artist_data = Mechanize.new.get("https://rbdb.io/v3/artists/#{song_artist}")
            song_hash[:artist_id] = Artist.find_by(name: (JSON.parse(song_artist_data.body)["collection"].first["name"])).id
        song_genre = song["genre"]
            if song_genre > 23
                song_hash[:genre_id] = Genre.find(song_genre - 1).id # AND 24
            elsif song_genre > 13
                song_hash[:genre_id] = Genre.find(song_genre).id # FOR WHATEVER REASON, IT SKIPS 14
            else
                song_hash[:genre_id] = Genre.find(song_genre + 1).id
            end
        song_hash[:year] = song["year"]
        song_hash[:gender] = song["gender"]
        song_hash[:vocal_parts] = song["vocalParts"]
        song_hash[:vocal_percussion] = song["vocalPercussion"]
        song_hash[:band_tier] = song["tiers"]["band"]
        song_hash[:bass_tier] = song["tiers"]["bass"]
        song_hash[:drums_tier] = song["tiers"]["drums"]
        song_hash[:guitar_tier] = song["tiers"]["guitar"]
        song_hash[:vocals_tier] = song["tiers"]["vocals"]
        song_hash[:cover] = song["cover"]
        song_hash[:duration] = song["duration"] # in milliseconds, need method to convert
        song_hash[:bpm] = song["bpm"]
        song_hash[:availability] = song["availability"] # be able to explain what "4" does
        song_hash[:source] = song["sources"].first # is it DLC, or is it on-disc? helps with mass adding
        song_hash[:spotify_id] = song["spotifyId"] # for 30 second song previews
        song_hash[:psn_link] = song["links"]["psn"]
        song_hash[:xbox_link] = song["links"]["xbox"]
        song_hash[:amazon_link] = song["links"]["amazon"]
        song_hash[:itunes_link] = song["links"]["itunes"]
        song_hash[:google_link] = song["links"]["google"]
        Song.where(song_hash).first_or_create
    end






