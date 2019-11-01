# Nexmo SMS Contest App

An app to run booth contests by SMS.

* [Dependencies](#requirements)
* [Installation and Usage](#installation-and-usage)
* [Contributing](#contributing)
* [License](#license)

## Dependencies

## Installation and Usage

In order to properly use this application you need to create a free [Nexmo account](https://dashboard.nexmo.com), and provision a Nexmo virtual number. Once you have done so, you then need to assign an inbound SMS webhook URL to that number in your Nexmo Dashboard. This webhook URL must be externally accessible. Many people find using [ngrok](https://ngrok.io) helpful for making their local server externally available during development. The application has the route `/webhooks/receive` already defined in [routes.rb](/config/routes.rb) configuration, as such it is easiest to provide that path with your externally accessible URL as your webhook to receive text messages.

Next you need to create the database schema by running `rake db:migrate` from your command line, and also installing all the dependencies outlined in the [Gemfile](Gemfile) by running `bundle install`.

Lastly, you need to provide your API credentials for Nexmo and your Nexmo number in your application. You can do so by executing `EDITOR="code --wait" rails credentials:edit` from your command line. Your credentials are put in the following format:

```ruby
nexmo:
  api_key:
  api_secret:
  nexmo_number:
```

Once that is finished you can start your Rails server by running `rails s` from your terminal. 

You can now text your application by sending a message to your Nexmo number.

Text messages are to be sent in the following format to be considered valid:

```
{name} -- {twitter handle} -- {email} -- {message}
```

## Contributing

We ❤️ contributions from everyone! [Bug reports](https://github.com/Nexmo/nexmo-sms-contest-app/issues), [bug fixes](https://github.com/Nexmo/nexmo-sms-contest-app/pulls) and feedback on the library is always appreciated. Look at the [Contributor Guidelines](https://github.com/Nexmo/nexmo-sms-contest-app/blob/master/CONTRIBUTING.md) for more information and please follow the [GitHub Flow](https://guides.github.com/introduction/flow/index.html).


## LICENSE

This project is under the [MIT License](LICENSE.txt)
