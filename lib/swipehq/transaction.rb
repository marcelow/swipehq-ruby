module SwipeHQ
  class Transaction

    attr_accessor :identifier, :item, :description, :amount, :default_quantity, :user_data, :currency,
                  :status

    attr_reader :id, :status, :approved

    def initialize(params = nil)
      if params
        params.each do |k,v|
          self.send("#{k}=",v)
        end
      end
    end

    def attributes
      a = {}
      %w{ identifier id item description amount default_quantity user_data currency }.each do |att|
        a[att.to_sym] = self.send(att)
      end
      return a
    end

    def create
      params = {
        api_key: SwipeHQ.api_key,
        merchant_id: SwipeHQ.merchant_id
      }
      attributes.each do |k,v|
        params["td_#{k}".to_sym] = v
      end
      res = SwipeHQ.request(
        :get,
        'https://api.swipehq.com/createTransactionIdentifier.php',
        params
      )
      if res['response_code'] and res['response_code'] == 200
        @identifier = res['data']['identifier']
      else
        @identifier = nil
      end
    end

    def verify
      return nil unless @identifier
      params = {
        api_key: SwipeHQ.api_key,
        merchant_id: SwipeHQ.merchant_id,
        transaction_id: @identifier
      }
      res = SwipeHQ.request(
        :get,
        'https://api.swipehq.com/verifyTransaction.php',
        params
      )
      if res['response_code'] and res['response_code'] == 200
        @id = res['data']['transaction_id']
        @status = res['data']['status'] || 'pending'
        @approved = res['data']['transaction_approved'] == 'yes'
      else
        @status = nil
      end
    end

    def payment_url
      return nil unless @identifier
      "https://payment.swipehq.com/?identifier_id=#{@identifier}"
    end

  end
end
