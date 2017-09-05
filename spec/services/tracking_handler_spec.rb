describe TrackingHandler do

    context '#refresh!' do

      subject(:subject) { described_class.new(order_tracking) }
      let(:order_tracking) { FactoryGirl.create(:order_tracking, :with_old_refresh) }

      before(:each) do
        # automatic true from the API call
        allow_any_instance_of(described_class).to receive(:kuaidi_api).and_return(kuaidi_valid_response)
      end

      it 'update the tracking successfully' do

        refreshed = subject.refresh!
        expect(refreshed.success?).to eq(true)
        expect(order_tracking.refreshed_at).to be > 1.minute.ago
        expect(order_tracking.state).to eq(:signature_received)

      end

      it 'returns a wrong API result' do

        allow_any_instance_of(described_class).to receive(:kuaidi_api).and_return(kuaidi_wrong_response)
        refreshed = subject.refresh!
        expect(refreshed.success?).to eq(false)

      end

      context 'with recent refresh' do

        let(:order_tracking) { FactoryGirl.create(:order_tracking, :with_recent_refresh) }

        it 'use the cached version' do
          
          refreshed = subject.refresh!
          expect(refreshed.success?).to eq(true)
          expect(order_tracking.refreshed_at).to be < 1.minute.ago # it did not really refresh

        end

      end

    end

end
