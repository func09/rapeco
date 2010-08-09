require File.expand_path("../ar_test_helper", __FILE__)

module FriendlyId
  module Test

    class ScopedModelTest < ::Test::Unit::TestCase

      include FriendlyId::Test::Generic
      include FriendlyId::Test::Slugged
      include FriendlyId::Test::ActiveRecordAdapter::Slugged
      include FriendlyId::Test::ActiveRecordAdapter::Core

      def setup
        @user = User.create!(:name => "john")
        @house = House.create!(:name => "123 Main", :user => @user)
        @usa = Country.create!(:name => "USA")
        @canada = Country.create!(:name => "Canada")
        @resident = Resident.create!(:name => "John Smith", :country => @usa)
        @resident2 = Resident.create!(:name => "John Smith", :country => @canada)
        @owner = Company.create!(:name => "Acme Events")
        @site = Site.create!(:name => "Downtown Venue", :owner => @owner)
      end

      def teardown
        Resident.delete_all
        Country.delete_all
        User.delete_all
        House.delete_all
        Slug.delete_all
      end

      test "a slugged model should auto-detect that it is being used as a parent scope" do
        assert_equal [Resident], Country.friendly_id_config.child_scopes
      end

      test "a slugged model should update its child model's scopes when its friendly_id changes" do
        @usa.update_attributes(:name => "United States")
        assert_equal "united-states", @usa.to_param
        assert_equal "united-states", @resident.slugs(true).first.scope
      end

      test "a non-slugged model should auto-detect that it is being used as a parent scope" do
        assert_equal [House], User.friendly_id_config.child_scopes
      end

      test "should update the slug when the scope changes" do
        @resident.update_attributes! :country => Country.create!(:name => "Argentina")
        assert_equal "argentina", @resident.slugs(true).first.scope
      end

      test "updating only the scope should not append sequence to friendly_id" do
        old_friendly_id = @resident.friendly_id
        @resident.update_attributes! :country => Country.create!(:name => "Argentina")
        assert_equal old_friendly_id, @resident.friendly_id
      end

      test "updating the scope should increment sequence to avoid conflicts" do
        old_friendly_id = @resident.friendly_id
        @resident.update_attributes! :country => @canada
        assert_equal "#{old_friendly_id}--2", @resident.friendly_id
        assert_equal "canada", @resident.slugs(true).first.scope
      end

      test "a non-slugged model should update its child model's scopes when its friendly_id changes" do
        @user.update_attributes(:name => "jack")
        assert_equal "jack", @user.to_param
        assert_equal "jack", @house.slugs(true).first.scope
      end

      test "should should not show the scope in the friendly_id" do
        assert_equal "john-smith", @resident.friendly_id
        assert_equal "john-smith", @resident2.friendly_id
      end

      test "should find all scoped records without scope" do
        assert_equal 2, Resident.find(:all, @resident.friendly_id).size
      end

      test "should find a single scoped record with a scope as a string" do
        assert Resident.find(@resident.friendly_id, :scope => @resident.country)
      end

      test "should find a single scoped record with a scope" do
        assert Resident.find(@resident.friendly_id, :scope => @resident.country)
      end

      test "should raise an error when finding a single scoped record with no scope" do
        assert_raises ActiveRecord::RecordNotFound do
          Resident.find(@resident.friendly_id)
        end
      end

      test "should append scope error info when missing scope causes a find to fail" do
        begin
          Resident.find(@resident.friendly_id)
          fail "The find should not have succeeded"
        rescue ActiveRecord::RecordNotFound => e
          assert_match(/scope: expected/, e.message)
        end
      end

      test "should append scope error info when the scope value causes a find to fail" do
        begin
          Resident.find(@resident.friendly_id, :scope => "badscope")
          fail "The find should not have succeeded"
        rescue ActiveRecord::RecordNotFound => e
          assert_match(/scope: badscope/, e.message)
        end
      end
      
      test "should update the sluggable field when a polymorphic relationship exists" do
        @site.update_attributes(:name => "Uptown Venue")
        assert_equal "Uptown Venue", @site.name
      end

    end
  end
end
