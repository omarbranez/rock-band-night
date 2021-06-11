
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






