require 'rails_helper'

RSpec.describe Track, type: :model do
  it { should belong_to(:track_type) }
  it { should belong_to(:order) }
  it { should belong_to(:car) }
  it { should have_many(:status_cars) }
end
