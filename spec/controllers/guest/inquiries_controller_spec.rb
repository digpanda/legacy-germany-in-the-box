describe Guest::InquiriesController, type: :controller do
  render_views

  let(:service) { FactoryGirl.create(:service) }

  describe '#create' do
    subject { post :create, inquiry: fake_inquiry_params }
    it { is_expected.to have_http_status(302) }
  end

end

def fake_inquiry_params
  { service_id: service.id, email: 'fake@email.com', mobile: '+49000000', scheduled_for: '2017-08-10', comment: 'Fake comment' }
end
