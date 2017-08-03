# describe Shop, type: :model do
#   context 'validations' do
#     context 'presence' do
#       context 'true' do
#         it { is_expected.to validate_presence_of(:name) }
#         it { is_expected.to validate_presence_of(:sms) }
#         #it { is_expected.to validate_presence_of(:sms_mobile) }
#         it { is_expected.to validate_presence_of(:status) }
#         it { is_expected.to validate_presence_of(:min_total) }
#         it { is_expected.to validate_presence_of(:shopkeeper) }
#         it { is_expected.to validate_presence_of(:currency) }
#         it { is_expected.to validate_presence_of(:founding_year) }
#         #it { is_expected.to validate_presence_of(:desc) }
#         #it { is_expected.to validate_presence_of(:philosophy) }
#         #it { is_expected.to validate_presence_of(:ustid) }
#       end
#
#       context 'false' do
#         it { is_expected.not_to validate_presence_of(:fname) }
#         it { is_expected.not_to validate_presence_of(:lname) }
#         it { is_expected.not_to validate_presence_of(:tel) }
#         it { is_expected.not_to validate_presence_of(:mail) }
#       end
#     end
#
#     context 'length' do
#       it { is_expected.to validate_length_of(:name) }
#       it { is_expected.to validate_length_of(:founding_year) }
#       it { is_expected.to validate_length_of(:desc) }
#       it { is_expected.to validate_length_of(:philosophy) }
#       it { is_expected.to validate_length_of(:ustid) }
#       it { is_expected.to validate_length_of(:register) }
#       it { is_expected.to validate_length_of(:stories) }
#       it { is_expected.to validate_length_of(:website) }
#       it { is_expected.to validate_length_of(:eroi) }
#       it { is_expected.to validate_length_of(:uniqueness) }
#       it { is_expected.to validate_length_of(:german_essence) }
#       it { is_expected.to validate_length_of(:shopname) }
#       it { is_expected.to validate_length_of(:fname) }
#       it { is_expected.to validate_length_of(:lname) }
#       it { is_expected.to validate_length_of(:tel) }
#       it { is_expected.to validate_length_of(:mail) }
#       it { is_expected.to validate_length_of(:mobile) }
#       it { is_expected.to validate_length_of(:function) }
#     end
#
#     context 'numericality' do
#       it { is_expected.to validate_length_of(:min_total) }
#     end
#   end
#
#
#   context 'methods' do
#
#   end
# end