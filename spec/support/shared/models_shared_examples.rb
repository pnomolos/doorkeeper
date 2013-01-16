shared_examples "an accessible token" do
  describe :accessible? do
    it "is accessible if token is not expired" do
      subject.stub :expired? => false
      should be_accessible
    end

    it "is not accessible if token is expired" do
      subject.stub :expired? => true
      should_not be_accessible
    end
  end
end

shared_examples "a revocable token" do
  describe :accessible? do
    before do 
      method = case DOORKEEPER_ORM
        when :data_mapper then :save
        else :save!
      end
      subject.send(method)
    end

    it "is accessible if token is not revoked" do
      subject.should be_accessible
    end

    it "is not accessible if token is revoked" do
      subject.revoke
      subject.should_not be_accessible
    end
  end
end

shared_examples "an unique token" do
  describe :token do
    it "is unique" do
      tokens = []
      3.times do
        token = FactoryGirl.create(factory_name).token
        tokens.should_not include(token)
      end
    end

    it "is generated before validation" do
      expect { subject.valid? }.to change { subject.token }.from(nil)
    end

    it "is not valid if token exists" do
      token1 = FactoryGirl.create factory_name
      token2 = FactoryGirl.create factory_name
      token2.token = token1.token
      token2.should_not be_valid
    end

    it 'expects database to throw an error when tokens are the same' do
      token1 = FactoryGirl.create factory_name
      token2 = FactoryGirl.create factory_name
      token2.token = token1.token
      expect {
        method = case DOORKEEPER_ORM
          when :data_mapper then :save
          else :save!
        end
        token2.send(method, :validate => false)
      }.to raise_error
    end
  end
end
