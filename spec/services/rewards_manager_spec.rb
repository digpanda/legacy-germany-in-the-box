describe RewardManager  do

  context '#start' do

    subject(:subject) { described_class.new(user, task: :sample_task) }
    let(:user) { FactoryGirl.create(:customer, :from_wechat) }

    it 'starts a reward' do

      reward = subject.start
      expect(user.rewards.count).to eq(1)
      expect(reward.started_at).to be_kind_of(Time)

    end

  end

  context '#end' do

    subject(:subject) { described_class.new(user, task: :invalid_task) }
    let(:user) { FactoryGirl.create(:customer, :from_wechat) }

    it 'fails to end an unexisting reward' do
      expect(subject.end).to eq(nil)
    end

    context 'with valid task' do

      subject(:subject) { described_class.new(user, task: :sample_task) }

      it 'starts and end a reward immediatly' do
        expect(subject.end.success?).to eq(true)
        expect(user.rewards.count).to eq(1)
        expect(user.rewards.first.ended_at).to be_kind_of(Time)

        expect(subject.end.success?).to eq(false) # can't achieve twice the same reward
        expect(user.notifications.count).to eq(1) # notification dispatched ?
      end

      it 'starts and end a reward afterwards' do
        reward = subject.start
        expect(user.rewards.count).to eq(1)
        subject.end
        expect(user.rewards.count).to eq(1)

        expect(reward.started_at).to be_kind_of(Time)
        expect(reward.ended_at).to be_kind_of(Time)
      end

    end


  end

end
