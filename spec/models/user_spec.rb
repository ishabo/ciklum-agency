require 'spec_helper'

describe User do

  let(:correct_pass) { '123' }
  let(:wrong_password) { '1234' }
  let(:alternative_pass) { '123' }

  describe "#encrypt_password" do

    context "when explicitly invoked" do

      before do
        @user = FactoryGirl.build(:user, :issa, password: correct_pass) 
      end

      it "encrypts given string when less than 40 chars" do
        @user.password = correct_pass
        @user.encrypt_password
        @user.password.should eq(Digest::SHA1.hexdigest correct_pass)
      end

      it "does not encrypt given string when equal to or more than 40 chars" do
        @user.password = Digest::SHA1.hexdigest correct_pass
        @user.encrypt_password
        @user.password.should eq(Digest::SHA1.hexdigest correct_pass) #nothing changes
      end
    end

    context "when user object is saved" do
      subject(:user) { FactoryGirl.build(:user, :issa, password: correct_pass ) }

      it "encrypts password on saving the object" do
        user.save
        user.password.should eq(Digest::SHA1.hexdigest correct_pass)
      end

      it "encrypts password on updating the object" do
        user.password = alternative_pass
        user.save!
        user.password.should eq(Digest::SHA1.hexdigest alternative_pass)
      end
    end
  end

  describe "#authenticate" do
    
    before do
      @issa = FactoryGirl.create(:user, :issa) 
      @max = FactoryGirl.create(:user, :max, :unemployed) 
    end

    context "when email initials are entered" do

      it "authenticates user with correct email initials and the correct password " do
        auth_user = User.authenticate('issa', correct_pass)
        auth_user.should eq(@issa)
      end

      it "rejects user with wrong email initials " do
        auth_user = User.authenticate('blabla', correct_pass)
        auth_user.should eq('wrong_email')
      end

      it "rejects user with correct email initials and wrong password" do
        auth_user = User.authenticate('issa', wrong_password)
        auth_user.should eq('wrong_password')
      end

      it "rejects unemployed user with correct email initials and correct password " do
        auth_user = User.authenticate('maev', correct_pass)
        auth_user.should eq('unemployed')
      end

    end

    context "when full email is entered" do
      it "authenticates user with correct full email and the correct password " do
        auth_user = User.authenticate('issa@ciklum.com', correct_pass)
        auth_user.should eq(@issa)
      end

      it "rejects user with wrong full email" do
        auth_user = User.authenticate('blabla@ciklum.com', correct_pass)
        auth_user.should eq('wrong_email')
      end

      it "rejects user with correct full email and wrong password" do
        auth_user = User.authenticate('issa@ciklum.com', wrong_password)
        auth_user.should eq('wrong_password')
      end

      it "rejects unemployed user with correct full email and correct password " do
        auth_user = User.authenticate('maev@ciklum.com', correct_pass)
        auth_user.should eq('unemployed')
      end
      
    end


  end  

  # it "Authenticates user" do
  # 	user_authenticated = User.authenticate(@email, @password)
  # 	user_authenticated.should be_a(User)
  # end

  # it "Encrypts Password" do
  # 	@user.password.should eq(Digest::SHA1.hexdigest @password)
  # end
 
  # it "Validates password on create" do
  # 	initials = SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")
  # 	FactoryGirl.build(:user, email: "#{initials}@ciklum.com", password: nil).should have(1).error_on(:password)
  # end
  	
  # it "Validates that email is unique" do
  # 	FactoryGirl.build(:user, email: @email, password: @password).should have(1).error_on(:email)
  # end
end