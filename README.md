# Nexmo SMS Contest App

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

An app to run booth contests by SMS.

* [Dependencies](#requirements)
* [Installation and Usage](#installation-and-usage)
    * [Deploying to Heroku](#deploying-to-heroku)
* [Administration](#administration)
* [Contributing](#contributing)
* [License](#license)

## Dependencies

* [PostgreSQL](http://www.postgresql.org/)
* [dotenv](https://github.com/bkeepers/dotenv)
* [nexmo_rails](https://github.com/Nexmo/nexmo-rails)

## Installation and Usage

In order to properly use this application you need to create a free [Nexmo account](https://dashboard.nexmo.com), and provision a Nexmo virtual number. Once you have done so, you then need to assign an inbound SMS webhook URL to that number in your Nexmo Dashboard. This webhook URL must be externally accessible. Many people find using [ngrok](https://ngrok.io) helpful for making their local server externally available during development. The application has the route `/webhooks/receive` already defined in [routes.rb](/config/routes.rb) configuration, as such it is easiest to provide that path with your externally accessible URL as your webhook to receive text messages.

Next you need to create the database schema by running `rake db:migrate` from your command line, and also installing all the dependencies outlined in the [Gemfile](Gemfile) by running `bundle install`.

Then, you need to provide your API credentials for Nexmo and your Nexmo number in your application. Your credentials are stored in a `.env` file in the root folder of your project. You can rename the sample [.env.sample](.env.sample) file to `.env` and input your values for the keys or create a new `.env` file, whichever you prefer. 

The credentials you must provide are your Nexmo API Key, API Secret and your Nexmo provisioned phone number. Your credentials are stored in the following manner:

```ruby
NEXMO_API_KEY=
NEXMO_API_SECRET=
NEXMO_NUMBER=
```

Lastly, run the Nexmo generator to create your Nexmo client instance by running `rails generate nexmo_initializer` from the command line.

Once that is finished you can start your Rails server by running `rails s` from your terminal. 

You can now text your application by sending a message to your Nexmo number.

Text messages are to be sent in the following format to be considered valid (the Twitter handle field is optional):

```
{name} -- {twitter handle} -- {email} -- {message}
```

### Deploying to Heroku

You can deploy the application directly from this GitHub repository by clicking on the `Deploy to Heroku` button at the top of this README. Once you do that you still must set your Nexmo API credentials and information in Heroku. You can either do so at the time you are initializing your application after you have the clicked the `Deploy to Heroku` button above, or after from within the Heroku Dashboard.

After you have clicked the above `Deploy to Heroku` button, you will see three `config vars` in the Heroku deployment settings. Add your Nexmo API credentials and Nexmo phone number in the appropriate value box for each key before clicking the final `Deploy app` button. This will ensure your application is deployed to Heroku with your Nexmo API information.

Alternatively, you can do so from with your Heroku Dashboard's application settings by [managing the config vars](https://devcenter.heroku.com/articles/config-vars#using-the-heroku-dashboard) for your Nexmo SMS Contest app after deploying. You will need to add the three environment variables listed above in the [Installation and Usage](#installation-and-usage) section of this README: `NEXMO_API_KEY`, `NEXMO_API_SECRET`, `NEXMO_NUMBER`. 

## Administration

The app utilizes [Active Admin](https://github.com/activeadmin/activeadmin) to provide administrative functionality. To use the administrative tooling in order to view contest entries do the following:

After running `bundle install` as outlined in the Installation instructions, execute the following:

* `rails generate active_admin:install`
* `rake db:migrate`
* `rake db:seed`
* `rails generate active_admin:resource Message`

Doing the above will create the Active Admin infrastructure and provide you with an administrative account with a login of `admin@example.com` and a password of `changemerightaway`. You can navigate to `https://localhost:3000/admin/` and sign in with those credentials to access the administrative section.

It is recommended to change the password and the login email for this administrative account. The simplest way to do so is to go into the Rails Console and update it there:

```bash
$ rails c
```

```ruby
irb(main)::001:0> admin = AdminUser.find_by_email("admin@example.com")
irb(main)::002:0> admin.email = "PUT NEW EMAIL ADDRESS HERE"
irb(main)::003:0> admin.password = "PUT NEW PASSWROD HERE"
irb(main)::004:0> admin.save
```

## Contributing

We ❤️ contributions from everyone! [Bug reports](https://github.com/Nexmo/nexmo-sms-contest-app/issues), [bug fixes](https://github.com/Nexmo/nexmo-sms-contest-app/pulls) and feedback on the library is always appreciated. Look at the [Contributor Guidelines](https://github.com/Nexmo/nexmo-sms-contest-app/blob/master/CONTRIBUTING.md) for more information and please follow the [GitHub Flow](https://guides.github.com/introduction/flow/index.html).


## LICENSE

This project is under the [MIT License](LICENSE.txt)
