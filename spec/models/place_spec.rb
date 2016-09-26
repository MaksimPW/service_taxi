require 'rails_helper'

RSpec.describe Place, type: :model do
  context '.geocode' do
    let(:subject) { FactoryGirl.create(:place, address: 'St. Petersburg', lon: nil, lat: nil) }

    it 'should receive if address' do
      expect(subject).to receive(:geocode)
      subject.save!
    end

    it 'should not receive if address empty' do
      subject.address = ''
      expect(subject).to_not receive(:geocode)
      subject.save!
    end
  end
end
