# frozen_string_literal: true

require 'rails_helper'

describe Product, type: :model do
  subject(:product) { described_class.new }

  it { is_expected.to have_many(:product_tags).class_name('ProductTag') }
  it { is_expected.to have_many(:tags).class_name('Tag') }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price) }

  describe '#tag_product' do
    let(:tags) { ['Calorie Free', 'No Sugar'] }

    it 'tags product', :aggregate_failures do
      product.tag_product(tags)

      expect(product.tags).to all(be_an(Tag))
      expect(product.tags.map(&:title)).to eq(tags)
    end
  end
end
