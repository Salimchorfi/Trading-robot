# require "facebook/messenger"
# include Facebook::Messenger
# Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])
# # message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
# # message.sender      # => { 'id' => '1008372609250235' }
# # message.sent_at     # => 2016-04-22 21:30:36 +0200
# # message.text        # => 'Hello, bot!'

# def trading_notification
#   Bot.on :message do |message|
#     command = message.text.downcase.split(" ")

#       Bot.deliver({
#         recipient: message.sender,
#         message: {
#           text: "Sorry, I'm not program to do this"
#         }
#       }, access_token: ENV["ACCESS_TOKEN"])
#   end
# end

# def sending_trade(information)
#   action = information[0]
#   Bot.deliver({
#   recipient: {
#     id: '45123'
#   },
#   message: {
#     text: "#{action} #{volume} #{currency} at #{price}"
#   },
#   message_type: Facebook::Messenger::Bot::MessageType::UPDATE
#   }, access_token: ENV["ACCESS_TOKEN"])

# end
