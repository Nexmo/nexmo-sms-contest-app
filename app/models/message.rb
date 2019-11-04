class Message < ApplicationRecord
  include ActiveModel::Validations

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, on: :create }
  validates :message, presence: true
  validates :phone_number, presence: true
  validates_uniqueness_of :phone_number

  def self.parse_sms(params)
    parsed_message = params.split('&text=')
    phone_number = parsed_message[0].split('=')[1].gsub('&to', '')
    parsed_message_contents = parsed_message[1].split('+--+')
    parsed_message_contents = twitter_present?(parsed_message_contents)
    parsed_message_contents = clean_data(parsed_message_contents)
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

  def self.clean_data(contents)
    contents[0] = contents[0].gsub('+', ' ')
    contents[1] = contents[1].sub('%C2%A1', '@')
    contents[2] = contents[2].sub('%C2%A1', '@')
    contents[3] = contents[3].split('&')[0].gsub('+', ' ')

    contents
  end

  def self.twitter_present?(data)
    if data[1].sub('%C2%A1', '@').match?(URI::MailTo::EMAIL_REGEXP)
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
