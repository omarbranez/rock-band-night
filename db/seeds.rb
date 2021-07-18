    # artist_data = Mechanize.new.get("https://rbdb.io/v3/artists")
    # artist_data = JSON.parse(artist_data.body)
    # artist_data["collection"].each do |artist|
    #     artist_hash = {}
    #     artist_hash[:article] = artist["article"]
    #     artist_hash[:name] = artist["name"]
    #     Artist.where(artist_hash).first_or_create
    # end

    # genre_data = Mechanize.new.get("https://rbdb.io/v3/genres")
    # genre_data = JSON.parse(genre_data.body)
    # genre_data["collection"].each do |genre|
    #     genre_hash = {}
    #     genre_hash[:name] = genre["name"]
    #     Genre.where(genre_hash).first_or_create
    # end

    # song_data = Mechanize.new.get("https://rbdb.io/v3/songs")
    # song_data = JSON.parse(song_data.body)
    # song_data["collection"].each do |song| 
    #     song_hash = {}
    #     song_hash[:article] = song["article"]        
    #     song_hash[:name] = song["name"]
    #     song_artist = song["artist"]
    #         song_artist_data = Mechanize.new.get("https://rbdb.io/v3/artists/#{song_artist}")
    #         song_hash[:artist_id] = Artist.find_by(name: (JSON.parse(song_artist_data.body)["collection"].first["name"])).id
    #     song_genre = song["genre"]
    #         if song_genre > 23
    #             song_hash[:genre_id] = Genre.find(song_genre - 1).id # AND 24
    #         elsif song_genre > 13
    #             song_hash[:genre_id] = Genre.find(song_genre).id # FOR WHATEVER REASON, IT SKIPS 14
    #         else
    #             song_hash[:genre_id] = Genre.find(song_genre + 1).id
    #         end
    #     song_hash[:year] = song["year"]
    #     song_hash[:gender] = song["gender"]
    #     song_hash[:vocal_parts] = song["vocalParts"]
    #     song_hash[:vocal_percussion] = song["vocalPercussion"]
    #     song_hash[:band_tier] = song["tiers"]["band"]
    #     song_hash[:bass_tier] = song["tiers"]["bass"]
    #     song_hash[:drums_tier] = song["tiers"]["drums"]
    #     song_hash[:guitar_tier] = song["tiers"]["guitar"]
    #     song_hash[:vocals_tier] = song["tiers"]["vocals"]
    #     song_hash[:cover] = song["cover"]
    #     song_hash[:duration] = song["duration"] # in milliseconds, need method to convert
    #     song_hash[:bpm] = song["bpm"]
    #     song_hash[:availability] = song["availability"] # be able to explain what "4" does
    #     song_hash[:source] = song["sources"].first # is it DLC, or is it on-disc? helps with mass adding
    #     song_hash[:spotify_id] = song["spotifyId"] # for 30 second song previews
    #     song_hash[:psn_link] = song["links"]["psn"]
    #     song_hash[:xbox_link] = song["links"]["xbox"]
    #     song_hash[:amazon_link] = song["links"]["amazon"]
    #     song_hash[:itunes_link] = song["links"]["itunes"]
    #     song_hash[:google_link] = song["links"]["google"]
    #     Song.where(song_hash).first_or_create
    # end
    Song.connection
    # songs = Song.all[2824..2884]
    songs = Song.all[2811..2884]
    songs.each do |song|
        m = Mechanize.new
        m.user_agent_alias = 'Mac Safari'
        page = m.get("https://www.google.com")
        google_form = page.form('f') 
        google_form.q = "xbox live en-us #{song.name} #{song.artist.name} -rocksmith -dance"
        page = m.submit(google_form)
        # binding.pry
        pp = page.links_with :href => /microsoft.com\/en-us\/p/
        song.xbox_link = pp.first.href[32..-1].gsub(/\&sa(.*)/, "")
        song.save
    end   
        
        # song.xbox_link = page.links[17].href[32..-1].gsub(/\&sa(.*)/, "")
        # should i just copy the whole link, now that it's a string?

    # Song.connection
    # # songs = Song.all[2796..2884]
    # songs = Song.all[2824..2884]
    # songs.each do |song|
    #     page = Mechanize.new.get("https://www.microsoft.com/en-us/search")

    #     microsoft_form = page.form('searchForm') 
    #     microsoft_form.q = "#{song.name} #{song.artist.name}"
    #     binding.pry
    #     page = Mechanize.new.submit(microsoft_form)
    #     song.xbox_link = page.links[95].href
    #     song.save
    # end
    

