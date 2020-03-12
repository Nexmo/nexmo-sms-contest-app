# frozen_string_literal: true

class Message < ApplicationRecord
  include ActiveModel::Validations
  
  validates :message, presence: true
  
  validates :message_id, presence: true
  validates_uniqueness_of :message_id


  def self.direct_data(params)
    escaped_data = decode_data(params)
    parsed_params = CGI.parse(escaped_data)
    data = {}
    
    data[:phone_number] = parsed_params["msisdn"][0]

    data[:message_id] = parsed_params["messageId"][0]
    data[:message] = parsed_params["text"][0]
    
    if parsed_params.key?("concat")
      if parsed_params["concat"]
        data[:concat] = true
        data[:concat_ref] = parsed_params["concat-ref"][0]
        data[:concat_part] = parsed_params["concat-part"][0]
        data[:concat_total] = parsed_params["concat-total"][0]
      end    
    end
    data
  end

  def self.decode_data(params)
    CGI.unescape(params)
  end

  def self.parse_phone_number(parsed_message)
    parsed_message[0].split('=')[1].gsub('&to', '')
  end

  def self.parse_message_id(parsed_message)
    parsed_message[0].split('=')[3]
  end

  def self.parse_sms(parsed_message)
    parsed_message = parsed_message.gsub('¡', '@')
    parsed_message = parsed_message.split('&text=')
    phone_number = parse_phone_number(parsed_message)
    message_id = parse_message_id(parsed_message)
    parsed_message_contents = parsed_message[1].split('&')[0].split(' -- ')
    parsed_message_contents = twitter_present?(parsed_message_contents)
    assign_data(parsed_message_contents, phone_number, message_id)
  end

  def self.assign_data(contents, phone_number, message_id)
    data = {}
    data[:name] = contents[0]
    data[:twitter] = contents[1]
    data[:email] = contents[2]
    data[:message] = contents[3]
    data[:phone_number] = phone_number
    data[:message_id] = message_id

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
      Thank you for contatacing us, unfortunately the raffle has closed. You can still use coupon code #{coupon_code} by #{end_of_coupon_code_date} to get 10 euro worth of credit.
    HEREDOC
  end

  def event_name
    'DevNexus 2020'
  end

  def end_of_contest_time
    'March 20th'
  end
    
  def coupon_code
    'DEVNEX20'
  end
  
  def end_of_coupon_code_date
    'March 20th'
  end
end
