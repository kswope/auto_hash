require 'test_helper'

# Note: all these test depend on "autotest :password" being in the User model

class UserTest < ActiveSupport::TestCase

  test "simple instantiation" do

    @user = User.new(:email => "me@example.com", :password => "asdf")
    assert @user

  end

  test "password touched" do

    original_password = "asdf"
    @user = User.new(:email => "me@example.com", :password => original_password)

    assert_equal "me@example.com", @user.email # make sure other fields untouched
    assert_not_equal nil, @user.password
    assert_not_equal "", @user.password
    assert_not_equal original_password, @user.password

  end

  # Finally test the comparer method
  test "matching" do

    original_password = "asdf"

    @user = User.new(:email => "me@example.com", :password => original_password)

    assert @user.password == original_password
    assert ! (@user.password == "banana")
    assert ! (@user.password == "")
    assert ! (@user.password == nil)

  end

  # Test whole circuit, including writing and reading from database.
  test "write, find, match" do

    original_password = "asdf"

    @user = User.create(:email => "me@example.com",
                        :password => original_password)

    user = User.find_by_email("me@example.com")

    assert user.password == original_password
    assert ! (user.password == "banana")
    assert ! (user.password == "")
    assert ! (user.password == nil)

  end

end
