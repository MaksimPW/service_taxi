require 'rails_helper'

RSpec.describe Car, type: :model do
  it { should have_many(:orders) }
  it { should have_many(:status_cars) }
  it { should have_many(:tracks) }
end
