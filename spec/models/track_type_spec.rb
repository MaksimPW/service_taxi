require 'rails_helper'

RSpec.describe TrackType, type: :model do
  it { should have_many(:orders) }
  it { should have_many(:tracks) }
end
