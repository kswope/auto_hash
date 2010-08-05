require 'test_helper'

# Note: all these test depend on "autotest :password" being in the User model

class UserTest < ActiveSupport::TestCase

  test "simple instantiation" do

    @user = User.new(:username => "kevin", :password => "asdf")
    assert @user

  end

  # We can't exactly test if the new password is a correctly hashed
  # password until running the comparer method, but we can check if
  # its nil or blank, or its not still the clear text password - which
  # would be quite a bug.
  test "password hashed" do

    original_password = "asdf"
    @user = User.new(:username => "kevin", :password => original_password)

    assert_equal "kevin", @user.username # make sure other fields untouched
    assert_not_equal nil, @user.password
    assert_not_equal "", @user.password
    assert_not_equal original_password, @user.password

  end

  # Finally test the comparer method
  test "matching" do

    original_password = "asdf"
    @user = User.new(:username => "kevin", :password => original_password)

    assert @user.password_autohash_match?(original_password)
    assert ! @user.password_autohash_match?("banana")
    assert ! @user.password_autohash_match?("")
    assert ! @user.password_autohash_match?(nil)

  end

  # Test whole circuit, including writing and reading from database.
  test "write, find, match" do

    original_password = "asdf"
    @user = User.new(:username => "kevin", :password => original_password)
    @user.save

    user = User.find_by_username("kevin")

    assert user.password_autohash_match?(original_password)
    assert ! user.password_autohash_match?("banana")
    assert ! user.password_autohash_match?("")
    assert ! user.password_autohash_match?(nil)

  end

end
