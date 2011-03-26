require 'spec_helper'

describe DataLoader::Inspector, "data typer" do
  before(:each) do
    @loader = DataLoader::Inspector
  end

  it "should use :integer for Fixnum" do
    @loader.dbtype(3).should == :integer
  end

  it "should use :datetime for DateTime" do
    @loader.dbtype(DateTime.new).should == :datetime
  end

  it "should use :string for String under 255 characters" do
    @loader.dbtype('s' * 255).should == :string
    @loader.dbtype('s').should == :string
  end

  it "should use :text for larger Strings" do
    @loader.dbtype('s' * 256).should == :text
    @loader.dbtype('s' * 4096).should == :text
  end

  it "should use nil for nil" do
    @loader.dbtype(nil).should be_nil
  end

  it "should use nil for empty strings" do
    @loader.dbtype('').should be_nil
  end

  it "should use nil for empty looking strings" do
    @loader.dbtype('  ').should be_nil
  end

  it "should raise an error for unknown types" do
    lambda { @loader.dbtype(Float) }.should raise_exception
  end
end


describe DataLoader::Inspector, "promoter" do
  before(:each) do
    @loader = DataLoader::Inspector
  end

  it "should choose :text over :string, :datetime, or :integer" do
    [:string, :datetime, :integer].each do |t|
      @loader.promote_type(:text, t).should == :text
    end
  end

  it "should choose :string over :datetime or :integer" do
    @loader.promote_type(:string, :integer).should == :string
    @loader.promote_type(:string, :datetime).should == :string
  end

  it "should choose :string for :datetime and :integer" do
    @loader.promote_type(:datetime, :integer).should == :string
  end

  it "should choose keep the type if both the same" do
    [:text, :string, :datetime, :integer].each do |t|
      @loader.promote_type(t, t).should == t
    end
  end

  it "should ignore nils" do
    @loader.promote_type(:integer, nil).should == :integer
  end

  it "should return nil if everything is nil" do
    @loader.promote_type(nil).should be_nil
    @loader.promote_type(nil, nil).should be_nil
  end

  it "should raise an error for unknown types" do
    lambda { @loader.promote_type(:string, :blarg) }.should raise_exception
  end
end
