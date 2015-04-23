require 'spec_helper'

describe "Client/Default Tests" do
  include_examples 'services::portmap'
  include_examples 'services::statd'
end
