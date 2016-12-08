# Germany In The Box

![alt text](https://www.germanyinthebox.com/images/logo-half.png "Germany In The Box")

## Getting Started

### Ecosystem

#### Front-end
- Brunch 2.7
- SASS / CSStyle / BEM conventions
- Homemade MVC JavaScript framework

#### Back-end
- Ruby 2.3
- Ruby on Rails 4.2
- MongoID

#### Testing
- RSpec 3.4
- FactoryGirl
- VCR

#### Deployment
- Capistrano 3.5

### Setup your application

- Use `git clone git@github.com:digpanda/germany-in-the-box.git`
- Use `bundle install`
- Install MongoDB on your machine and create a new user you will use for the project. Set it up in the configuration.
- Add the `secrets.yml` and `application.yml` that was previously given to you.
- Populate the sample data with `rake digpanda:remove_and_create_complete_sample_data`

### Start your application

### Back-end

Go to the project directory and type `rails s`
### Front-end

As we don't use the assets pipeline, you must compile from somewhere else. Go to the `app_front/` directory and type `brunch watch` ; the pages will automatically reload when you change a file within this folder.

### Code conventions

We primarly respect [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) mixed with DigPanda Ruby Guideline

### More

To know more about the project, please check our [Wiki](https://github.com/digpanda/germany-in-the-box/wiki)
