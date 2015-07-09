require 'spec_helper'

describe Project do

  describe "engagement_types" do
    it 'Has Project Delivery Type ' do
  	  Project.engagement_types[:project_delivery].should eq(1)
  	end
    it 'Has Rate Card Type' do
  	  Project.engagement_types[:rate_card].should eq(2)
  	end
    it 'Has Service Only Type' do
  	  Project.engagement_types[:service_only].should eq(3)
  	end  	
  end

  describe "conversion_status" do 
    it 'Has Pending Status' do
      Project.conversion_status[:pending].should eq(0)
    end
    it 'Has Won Status' do
      Project.conversion_status[:won].should eq(1)
    end
    it 'Has Lost Status' do
      Project.conversion_status[:lost].should eq(2)
    end   
  end

  describe "#is_lost?" do
    let (:proj) do 
      stub_model Project, :random_attribute => true
    end
    context "when project is lost" do
      before do
        proj.converted = Project.conversion_status[:lost]
      end
      it "shows that it is lost" do
        proj.is_lost?.should be_truthy
      end
    end

    context "when project is lost" do
      before do
        proj.converted = Project.conversion_status[:won]
      end
      it "shows that it is lost" do
        proj.is_lost?.should be_falsey
      end
    end
  end

  describe "Validating comments" do
    before(:each) do
      @proj = FactoryGirl.build(:project, status_comment: '')
    end

    context "when project is not lost" do
      before do
        @proj.converted = Project.conversion_status[:won]
        @proj.save
      end
      it "allows saving with empty comments on saving" do
        @proj.should have(0).error_on(:status_comment)
      end
    end

    context "when project is lost" do
      before do
        @proj.converted = Project.conversion_status[:lost]
        @proj.save
      end      
      it "doesn't allow saving without comment" do
        @proj.should have(1).error_on(:status_comment)  
      end
    end
  end

  describe "#get_conversion_rate" do 
     
    before(:all) do
      FactoryGirl.create :service_type, :ws
      @issa = FactoryGirl.create :user, :issa
      @max = FactoryGirl.create :user, :max

      FabricateServices.new(@issa, 30).with_project_statuses
      FabricateServices.new(@max, 30).with_project_statuses 
    end

    let(:total) { 60 }
    let(:won) { 20 }
    let(:pending) { 20 }
    let(:lost) { 20 }

    def calc_conversion_date (won, lost)
      "#{((won*100)/(won+lost)).round}%"
    end

    shared_examples_for "get conversion rate" do
      
      it "returns all projects" do
        project_counts[:total][1].should eq(total/divisor)
      end

      it "returns the expected number of won projects" do
        project_counts[:converted][1].should eq(won/divisor)
      end 

      it "returns the expected number of lost projects" do
        project_counts[:lost][1].should eq(lost/divisor)
      end

      it "returns the expected number of pending projects" do
        project_counts[:pending][1].should eq(pending/divisor)
      end

      it "returns the expected conversion rate (won*100/won+lost) " do
        project_counts[:conversion_rate][1].should eq(calc_conversion_date(won/divisor, lost/divisor))
      end
    end

    context "when no consultant or year are given" do
      it_should_behave_like "get conversion rate" do
        let(:project_counts) { Project.new.get_projects_conversion_rate() }
        let(:divisor) { 1 }
      end
    end

    context "when consultant is given by no year" do
      it_should_behave_like "get conversion rate" do
        let(:project_counts) { Project.new.get_projects_conversion_rate(2011) }
        let(:divisor) { 2 }
      end
    end

    context "when no consultant is given but year is" do
      it_should_behave_like "get conversion rate" do
        let(:project_counts) { Project.new.get_projects_conversion_rate(0, @max) }
        let(:divisor) { 2 }
      end
    end

    context "when both consultant and year are given" do
      it_should_behave_like "get conversion rate" do
        let(:project_counts) { Project.new.get_projects_conversion_rate(2012, @max) }
        let(:divisor) { 4 }
      end
    end
  end
end