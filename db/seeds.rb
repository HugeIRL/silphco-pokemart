Province.destroy_all
Creature.destroy_all
Type.destroy_all

logger = Rails.logger

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

(1..151).each do |i|
  pkmn = PokeApi.get(pokemon: i)
  sleep(1)
  logger.info "GET data for #{pkmn.name} pokedex_id #{pkmn.id}"
  type = Type.find_or_create_by(name: pkmn.types.first.type.name)
  logger.info "FOUND #{type.name} type for #{pkmn.name}"

  description = PokeApi.get(pokemon_species: i).flavor_text_entries.find do |text|
    text.flavor_text if text.language.name == "en"
  end
  logger.info "FOUND description for #{pkmn.name}" if description.present?

  if type&.valid?
    p = type.creatures.create(
      pokedex_id:  pkmn.id,
      species:     pkmn.name,
      description: description.flavor_text,
      price_cents: rand(5000..100_000).to_i
    )
    logger.info "CREATE #{p.species} with type #{p.type.name}" if p.valid?

    url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{pkmn.id}.png"
    downloaded_image = URI.parse(url).open
    p.image.attach(io: downloaded_image, filename: "m-#{p.pokedex_id}.png",
                   content_type: "image/png")
    logger.info "ATTACH image to #{p.species}" if downloaded_image
  else
    logger.info "INVALID type #{p['type']} for pokemon #{p['species']}"
  end
end

province.each do |k, v|
  i = province.to_a.index { |key,| key == k }

  p = Province.create(
    name:     v,
    pst_rate: tax_rates[i][0].to_f,
    gst_rate: tax_rates[i][1].to_f,
    hst_rate: tax_rates[i][2].to_f
  )

  next unless p.persisted?

  logger.info "Added #{p.name} with PST #{p.pst_rate} GST #{p.gst_rate} HST #{p.hst_rate}"

  cities_by_province = CS.cities(k, :ca)

  cities_by_province.each do |city|
    c = p.cities.create(
      name: city
    )

    if c.persisted?
      logger.info "Added #{c.name} as a city for #{p.name}"
    else
      logger.info "FAILED to add #{c.name} as a city for #{p.name}"
      c.errors.messages.each do |column, errors|
        errors.each do |error|
          logger.info "The #{column} property #{error}"
        end
      end
    end
  end
end

logger.info "Created #{Type.count} Types"
logger.info "Created #{Creature.count} Creatures"
logger.info "Created #{Province.count} Provinces"
logger.info "Created #{City.count} Cities"

if Rails.env.development?
  AdminUser.create!(email: "admin@silph.co", password: "teamrocket",
  password_confirmation: "teamrocket")
end
