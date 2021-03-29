require "rest-client"

Province.destroy_all
Creature.destroy_all
Type.destroy_all

pokemon = []
description = []
province = CS.states(:ca)

tax_rates = [[0, 5, 0], # ab
             [7, 5, 0], # bc
             [7, 5, 0], # mb
             [0, 0, 15], # nb
             [0, 0, 15], # nfl&l
             [0, 5, 0], # ns
             [0, 0, 15], # nwt
             [0, 5, 0], # nvt
             [0, 0, 13], # ont
             [0, 0, 15], # pei
             [9.975, 5, 0], # qc
             [6, 5, 0], # sask
             [0, 5, 0]] # yuk

# limit the amount of Pokemon to 25 for now. End goal is to get the original 151.
(1..25).each do |i|
  data = RestClient.get("https://pokeapi.co/api/v2/pokemon/#{i}")
  json_data = JSON.parse(data)
  pokemon.push(json_data)
  puts "GET data for Pokemon id #{i}"

  desc = RestClient.get("https://pokeapi.co/api/v2/pokemon-species/#{i}")
  json_desc = JSON.parse(desc)
  description.push(json_desc)
end

pokemon.each do |creature|
  type = Type.find_or_create_by(name: creature["types"][0]["type"]["name"])

  if type && type.valid?
    p = type.creatures.create(
      pokedex_id:  creature["id"],
      species:     creature["name"],
      description: description[creature["id"] - 1]["flavor_text_entries"][1]["flavor_text"],
      price_cents: rand(5000..100_000).to_i
    )
    puts "Creating #{p.species} with type #{p.type.name}"

    downloaded_image = URI.open("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{p.pokedex_id}.png")
    p.image.attach(io: downloaded_image, filename: "m-#{p.pokedex_id}.png")
    puts "Downloaded image for #{p.species}" if downloaded_image
  else
    puts "Invalid type #{p['type']} for pokemon #{p['species']}"
  end
end

province.each do |k, v|
  # turn the province hash into an array and grab the index
  # this will allow grabbing the correct tax rate from the tax_rates array
  i = province.to_a.index { |key,| key == k }

  p = Province.create(
    name:     v,
    pst_rate: tax_rates[i][0].to_f,
    gst_rate: tax_rates[i][1].to_f,
    hst_rate: tax_rates[i][2].to_f
  )

  next unless p.persisted?

  puts "Added the #{p.name} province with PST: #{p.pst_rate}, GST: #{p.gst_rate}, HST: #{p.hst_rate}"

  cities_by_province = CS.cities(k, :ca)

  cities_by_province.each do |city|
    c = p.cities.create(
      name: city
    )

    if c.persisted?
      puts "Added #{c.name} as a city for #{p.name}"
    else
      puts "FAILED to add #{c.name} as a city for #{p.name}"
      c.errors.messages.each do |column, errors|
        errors.each do |error|
          puts "The #{column} property #{error}"
        end
      end
    end
  end
end

puts "Created #{Type.count} Types"
puts "Created #{Creature.count} Creatures"
puts "Created #{Province.count} Provinces"
puts "Created #{City.count} Cities"

if Rails.env.development?
  AdminUser.create!(email: "admin@silph.co", password: "teamrocket",
  password_confirmation: "teamrocket")
end
