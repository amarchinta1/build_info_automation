require 'gmail_xoauth'
require 'pry'
imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
binding.pry
imap.authenticate('XOAUTH2', 'amar.chinta@zerebral.co.in', my_oauth2_token)
binding.pry
messages_count = imap.status('INBOX', ['MESSAGES'])['MESSAGES']
puts "Seeing #{messages_count} messages in INBOX"
