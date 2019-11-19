# frozen_string_literal: true

class Message < ApplicationRecord
  include ActiveModel::Validations

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, on: :create }
  validates :message, presence: true
  validates :phone_number, presence: true
  validates_uniqueness_of :phone_number

  def self.direct_data(params)
    escaped_data = decode_data(params)

    if escaped_data.include?('&concat=true')
      parse_concat_sms(escaped_data)
    else
      parse_sms(escaped_data)
    end
  end

  def self.decode_data(params)
    CGI.unescape(params)
  end

  def self.parse_phone_number(parsed_message)
    parsed_message[0].split('=')[1].gsub('&to', '')
  end

  def self.parse_concat_sms(parsed_message)
    phone_number = parse_phone_number(parsed_message)
    parsed_message = parsed_message.split('&text=')
    concat_string = parsed_message[/concat-ref=[0-9](.*?)&text=/m, 1]
    parsed_message_contents = parsed_message[1].split('&')[0].split(' -- ')
    parsed_message_contents = twitter_present?(parsed_message_contents)
    parsed_message_contents[3] = "#{concat_string}: #{parsed_message_contents[3]}"
    assign_data(parsed_message_contents, phone_number)
  end

  def self.parse_sms(parsed_message)
    phone_number = parse_phone_number(parsed_message)
    parsed_message = parsed_message.split('&text=')
    parsed_message_contents = parsed_message[1].split('&')[0].split(' -- ')
    parsed_message_contents = twitter_present?(parsed_message_contents)
    assign_data(parsed_message_contents, phone_number)
  end

  def self.assign_data(contents, phone_number)
    data = {}
    data[:name] = contents[0]
    data[:twitter] = contents[1]
    data[:email] = contents[2]
    data[:message] = contents[3]
    data[:phone_number] = phone_number

    data
  end

  def self.twitter_present?(data)
    if data[1].match?(URI::MailTo::EMAIL_REGEXP)
      data[3] = data[2]
      data[2] = data[1]
      data[1] = ''
    end
    data
  end

  def success_message
    <<~HEREDOC
      Thank you for entering the Nexmo #{event_name} contest!
      All entries will be evaluated and the winner will be notified by the
      #{end_of_contest_time}. Good luck!
    HEREDOC
  end

  def event_name
    'RubyConf 2019'
  end

  def end_of_contest_time
    'afternoon break on November 20th'
  end
end
