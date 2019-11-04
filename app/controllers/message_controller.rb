require 'pry'
class MessageController < ApplicationController

  def create
    data = Message.parse_sms(request.env['QUERY_STRING'])
    @message = Message.new(
      name: data[:name], 
      email: data[:email], 
      phone_number: data[:phone_number], 
      twitter: data[:twitter], 
      message: data[:message]
    )
    if @message.save
      send_sms(@message.phone_number, @message.success_message)
    else
      puts "Message not saved successfully."
    end
  end

  private

  def send_sms(recipient, text)
    Nexmo.sms.send(
      from: Rails.application.credentials.nexmo[:nexmo_number],
      to: recipient,
      text: text      
    )
  end

end
