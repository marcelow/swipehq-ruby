require File.expand_path('../spec_helper', __FILE__)

describe SwipeHQ::Transaction do

  let(:successful_create_request){ SwipeHQ.stub(:request) }

  describe '#initialize' do
    context 'sets parameters correctly' do
      let(:params){
        {
          item: 'Item',
          description: 'Description for Item',
          amount: 100.00,
          default_quantity: 1,
          user_data: 'Data for user',
          currency: 'NZD'
        }
      }
      let(:transaction){ SwipeHQ::Transaction.new(params) }

      it { transaction.attributes =~ params }
    end
  end

  describe '#create' do

    let(:transaction){ FactoryGirl.build(:transaction) }

    context 'valid params' do
      let(:response){ { 'response_code' => 200, 'message' => 'OK', 'data' => {'identifier' => 'XXXX'} } }

      before(:each) do
        SwipeHQ.stubs(:request).returns(response)
        transaction.create
      end

      it{ transaction.identifier.should eq response['data']['identifier'] }
    end

  end

  describe '#verify' do

    let(:transaction){ FactoryGirl.build(:transaction, identifier: 'XXXX') }

    context 'pending' do
      let(:response){ { 'response_code' => 200, 'message' => 'OK', 'data' => { 'transaction_id' => 'YYYY', 'status' => nil, 'transaction_approved' => 'no' } } }

      before(:each) do
        SwipeHQ.stubs(:request).returns(response)
        transaction.verify
      end

      it { transaction.id.should eq(response['data']['transaction_id']) }
      it { transaction.status.should eq('pending') }
      it { transaction.approved.should eq(false) }
    end

    context 'approved' do
      let(:response){ { 'response_code' => 200, 'message' => 'OK', 'data' => { 'transaction_id' => nil, 'status' => 'approved', 'transaction_approved' => 'yes' } } }

      before(:each) do
        SwipeHQ.stubs(:request).returns(response)
        transaction.verify
      end

      it { transaction.id.should eq(nil) }
      it { transaction.status.should eq('approved') }
      it { transaction.approved.should eq(true) }
    end

    context 'declined' do
      let(:response){ { 'response_code' => 200, 'message' => 'OK', 'data' => { 'transaction_id' => 'YYYY', 'status' => 'declined', 'transaction_approved' => 'no' } } }

      before(:each) do
        SwipeHQ.stubs(:request).returns(response)
        transaction.verify
      end

      it { transaction.id.should eq(response['data']['transaction_id']) }
      it { transaction.status.should eq('declined') }
      it { transaction.approved.should eq(false) }
    end

  end

  describe '#payment_url' do

    context 'with transaction identifier' do
      let(:identifier) { 'XXXX' }
      let(:transaction) { FactoryGirl.build(:transaction, identifier: identifier) }

      it { transaction.payment_url.should eq("https://payment.swipehq.com/?identifier_id=#{identifier}") }
    end

    context 'without transaction identifier' do
      let(:identifier) { nil }
      let(:transaction) { FactoryGirl.build(:transaction, identifier: identifier) }

      it { transaction.payment_url.should eq(nil) }
    end

  end

end
