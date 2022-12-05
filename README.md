# TabiNow

A travel itinerary generator build with Ruby on Rails.

<div align="center">
<img width="640" alt="TabiNow01" src="https://user-images.githubusercontent.com/109743083/205537183-9d299cf9-fe7e-4ed0-87e1-f26755c8421d.png">
<img width="640" alt="TabiNow02" src="https://user-images.githubusercontent.com/109743083/205537107-030a5d65-fba0-4110-a3ae-4f051e6de371.png">
</div>

<br>
👉 App home: https://tabinow.tours/
<br>

## Getting Started
### Setup

Install gems
```
bundle install
```
Install JS packages
```
yarn install
```

### ENV Variables
Create `.env` file
```
touch .env
```
Inside `.env`, set these variables.
```
CLOUDINARY_URL=your_own_cloudinary_url_key
HOTELS_API_KEY=your_own_hotels_api_key
YELP_API_KEY=your_own_yelp_api_key
MAPBOX_API_KEY=your_own_yelp_api_key
host_name="http://localhost:3000"
```

### DB Setup
```
rails db:create
rails db:migrate
rails db:seed
```

### Run a server
```
rails s
```

## Built With
- [Rails 7](https://guides.rubyonrails.org/) - Backend / Front-end
- [Stimulus JS](https://stimulus.hotwired.dev/) - Front-end JS
- [Heroku](https://heroku.com/) - Deployment
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Bootstrap](https://getbootstrap.com/) — Styling
- [Figma](https://www.figma.com) — Prototyping

## Team Members
- [Joyce Chan](https://www.linkedin.com/in/joycehwchan/)
- [Fredrik Kawahara Faeger](https://www.linkedin.com/in/fredfaeger/)
- [Christopher Crespo](https://www.linkedin.com/in/christopher-ikaika-crespo/)
- [Hafid Qarchi](https://www.linkedin.com/in/hafid-qa/)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License
