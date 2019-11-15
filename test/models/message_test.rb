require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  def test_validate_email_presence
    message = Message.new(name: 'Joe Schmoe', message: 'Test message', phone_number: '12122222222')
    assert_not message.save, "Message requires an email"
  end

  def test_validate_name_presence
    message = Message.new(message: 'Test message', phone_number: '12122222222', email: 'test@test.com')
    assert_not message.save, "Message requires a name"
  end

  def test_validate_message_presence
    message = Message.new(phone_number: '12122222222', email: 'test@test.com', name: 'Joe Schmoe')
    assert_not message.save, "Message requires a message"
  end

  def test_validate_phone_presence
    message = Message.new(message: 'Test message', email: 'test@test.com', name: 'Joe Schmoe')
    assert_not message.save, "Message requires a phone number"
  end

  def test_validate_email_format_correct
    message = Message.new(message: 'Test message', email: 'test@test.com', name: 'Joe Schmoe', phone_number: '12122222222')
    assert message.save
  end

  def test_validate_email_format_incorrect
    message = Message.new(message: 'Test message', email: 'not correct format', name: 'Joe Schmoe', phone_number: '12122222222')
    assert_not message.save, "Email must be in correct format"
  end

  def test_parse_sms_class_method_with_one_word_name
    params = "msisdn=972587889999&to=972587889999&messageId=160000028ACCEB69&text=Joe+--+Twitter+--+test%40test.com+--+this+is+a+great+idea&type=text&keyword=JOE&api-key=999999&message-timestamp=2019-11-01+13%3A02%3A29"
    expected_hash = {
      :name => 'Joe', 
      :twitter => 'Twitter', 
      :email => 'test@test.com', 
      :phone_number => '972587889999',
      :message => 'this is a great idea'
    }
    actual_hash = Message.parse_sms(params)
    assert_equal expected_hash, actual_hash
  end

  def test_parse_sms_class_method_with_two_word_name
    params = "msisdn=972587889999&to=972587889999&messageId=160000028ACCEB69&text=Joe+Schmoe+--+Twitter+--+test%40test.com+--+this+is+a+great+idea&type=text&keyword=JOE&api-key=999999&message-timestamp=2019-11-01+13%3A02%3A29"
    expected_hash = {
      :name => 'Joe Schmoe', 
      :twitter => 'Twitter', 
      :email => 'test@test.com', 
      :phone_number => '972587889999',
      :message => 'this is a great idea'
    }
    actual_hash = Message.parse_sms(params)
    assert_equal expected_hash, actual_hash
  end

  def test_parse_sms_class_method_with_twitter_no_at_symbol
    params = "msisdn=972587889999&to=972587889999&messageId=160000028ACCEB69&text=Joe+Schmoe+--+Twitter+--+test%40test.com+--+this+is+a+great+idea&type=text&keyword=JOE&api-key=999999&message-timestamp=2019-11-01+13%3A02%3A29"
    expected_hash = {
      :name => 'Joe Schmoe', 
      :twitter => 'Twitter', 
      :email => 'test@test.com', 
      :phone_number => '972587889999',
      :message => 'this is a great idea'
    }
    actual_hash = Message.parse_sms(params)
    assert_equal expected_hash, actual_hash
  end

  def test_parse_sms_class_method_with_twitter_at_symbol
    params = "msisdn=972587889999&to=972587889999&messageId=160000028ACCEB69&text=Joe+Schmoe+--+%40Twitter+--+test%40test.com+--+this+is+a+great+idea&type=text&keyword=JOE&api-key=999999&message-timestamp=2019-11-01+13%3A02%3A29"
    expected_hash = {
      :name => 'Joe Schmoe', 
      :twitter => '@Twitter', 
      :email => 'test@test.com', 
      :phone_number => '972587889999',
      :message => 'this is a great idea'
    }
    actual_hash = Message.parse_sms(params)
    assert_equal expected_hash, actual_hash
  end

  def test_parse_sms_class_method_with_no_twitter_value
    params = "msisdn=972587889999&to=972587889999&messageId=160000028ACCEB69&text=Joe+Schmoe+--+test%40test.com+--+this+is+a+great+idea&type=text&keyword=JOE&api-key=999999&message-timestamp=2019-11-01+13%3A02%3A29"
    expected_hash = {
      :name => 'Joe Schmoe', 
      :twitter => '', 
      :email => 'test@test.com', 
      :phone_number => '972587889999',
      :message => 'this is a great idea'
    }
    actual_hash = Message.parse_sms(params)
    assert_equal expected_hash, actual_hash
  end
end
