class MessageController < ApplicationController
  def create
    data = Message.direct_data(request.env['QUERY_STRING'])
    @message = Message.find_or_initialize_by(
      phone_number: data[:phone_number]
    )

    if @message.persisted?
      @message.message = "#{@message.message} #{data[:message]}"
    else
      @message.name = data[:name]
      @message.email = data[:email]
      @message.twitter = data[:twitter]
      @message.message = data[:message]
    end

    if @message.save
      send_sms(@message.phone_number, @message.success_message)
    else
      puts "Message not saved successfully."
    end
  end

  private

  def send_sms(recipient, text)
    Nexmo.sms.send(
      from: ENV['NEXMO_NUMBER'],
      to: recipient,
      text: text      
    )
  end

end
