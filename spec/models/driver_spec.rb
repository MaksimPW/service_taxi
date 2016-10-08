require 'rails_helper'

RSpec.describe Driver, type: :model do
  it { should have_many(:orders) }
end
