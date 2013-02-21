require File.expand_path('../../lib/swipehq', __FILE__)

puts "=== Starting SwipeHQ API test"
SwipeHQ.api_key = ENV['SWIPEHQ_API_KEY']
SwipeHQ.merchant_id = ENV['SWIPEHQ_MERCHANT_ID']
SwipeHQ.callback_url = ENV['SWIPEHQ_CALLBACK_URL']

puts "=== Setting up Callback URL"
SwipeHQ.set_callback_url

puts "=== Creating Transaction"
params = {
  item: 'Item',
  description: 'Description for Item',
  amount: 100.00,
  default_quantity: 1,
  user_data: 'Data for user',
  currency: 'NZD'
}
@transaction = SwipeHQ::Transaction.new(params)
@transaction.create
msg = <<-EOF

  Transaction Identifier: #{@transaction.identifier}
  Transaction ID: #{@transaction.id}
  Payment URL: #{@transaction.payment_url}

  EOF

puts msg

puts "=== Complete Transaction on browser and press enter to proceed"
proceed = gets
if !proceed.empty?
  puts "=== Verifying Transaction Status"
  @transaction.verify
  puts msg
end
