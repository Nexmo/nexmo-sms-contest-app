class Message < ApplicationRecord
  include ActiveModel::Validations

  validates :name, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :message, presence: true
  validates :phone_number, presence: true
  validates_uniqueness_of :phone_number

  def self.parse_sms(params)
    parsed_message = params.split('&text=')
    parsed_message_contents = parsed_message[1].split('+--+')
    data = {}
    data[:name] = parsed_message_contents[0]
    data[:twitter] = parsed_message_contents[1].sub('%C2%A1', '@')
    data[:email] = parsed_message_contents[2].sub('%C2%A1', '@')
    data[:message] = parsed_message_contents[3].split('&')[0].gsub('+', ' ')
    data[:phone_number] = parsed_message[0].split('=')[1].gsub('&to', '')
    
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
