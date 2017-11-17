feature 'login process', js: true do

  let(:customer) { FactoryGirl.create(:customer) }
  let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }
  let(:friend) { FactoryGirl.create(:customer) }

  scenario 'login with a label' do
    visit root_path(label: 'test-label')
    process_login(customer)
    customer.reload
    expect(customer.label).to eq('test-label')
  end

  scenario 'login and assign a referrer to the account' do
    visit root_path(reference_id: referrer.reference_id)
    process_login(customer)
    customer.reload
    expect(customer.parent_referrer).not_to eq(nil)
  end

  scenario 'login and assign a friend to the account' do
    visit root_path(introducer: introducer.id)
    process_login(customer)
    customer.reload
    expect(customer.introduced.count).to eq(1)
  end

end
