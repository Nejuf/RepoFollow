require 'rails_helper'

RSpec.describe GithubController, :type => :controller do

  describe "GET 'public_repos'" do
    it "returns http success" do
      get 'public_repos'
      expect(response).to be_success
    end
  end

end
