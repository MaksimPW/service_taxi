require 'rails_helper'

RSpec.describe PlaceType, type: :model do
  it { should have_many(:places) }
end
