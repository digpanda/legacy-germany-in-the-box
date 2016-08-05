describe NavigationHistory do

  #include Rails.application.routes.url_helpers

  context "#store" do

    it "should not store if it is not a GET request" do

      request = double(:get? => false)
      expect(NavigationHistory.new(request, {}).store).to eql(false)

    end

    it "should not store if it is an AJAX call" do

      request = double(:get? => true, :xhr? => true)
      expect(NavigationHistory.new(request, {}).store).to eql(false)

    end

    it "should store the successive paths and return the correct one" do

      request = double(:get? => true, :xhr? => false, :path => 'ONE_PATH', :fullpath => 'ONE_FULL_PATH')
      expect(NavigationHistory.new(request, {}).store.count).to eql(1)

    end

  end

  context "#back" do

    it "should go back to the previous URL" do

      request = double(:get? => true, :xhr? => false)
      session = {:previous_urls => ['1', '2', '3', '4', '5']}

      nav = NavigationHistory.new(request, session)
      expect(nav.back(1)).to eql('1')

    end

    it "should go back to several URLs before it" do

      request = double(:get? => true, :xhr? => false)
      session = {:previous_urls => ['1', '2', '3', '4', '5']}

      nav = NavigationHistory.new(request, session)
      expect(nav.back(3)).to eql('3')

    end

    it "should not find the URL back so redirect to root_url" do

      request = double(:get? => true, :xhr? => false)
      session = {:previous_urls => ['1', '2', '3', '4', '5']}

      nav = NavigationHistory.new(request, session)
      expect(nav.back(10)).to eql(root_url)

    end

  end

end