# Silph Co. PokeMart

## Requirements & Setup

Ruby (v3.0.0)

Rails: (v3.1.2)

Yarn

Node

First, you'll want to run:

```
yarn install
bundle install
```

This will grab all the dependancies.

## Usage

You'll need to migrate the db for the project to work by running the following:

```
rake db:migrate
```

After migrating, you need to seed the database with data (if you want the creatures to load in the store):

```
rake db:seed
```

You will see the output of the seeding live in the terminal window. This may take some time.

After the db migration and seed are complete, you can start the app by running the following:

```
rake assets:precompile
```

This will allow the image assets and CSS to load properly.

Then, you can run the following to get the two servers for the application up:

```
rails s
./bin/webpack-dev-server
```

I prefer running these two commands above in individual terminal instances, but you can do as you please at this point.

Once everything is running, you can navigate to the link below to view the live app:

```
http://localhost:3000
```
