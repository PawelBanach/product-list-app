# frozen_string_literal: true

require 'rails_helper'

describe Tag, type: :model do
  it { is_expected.to have_many(:product_tags).class_name('ProductTag') }
  it { is_expected.to have_many(:products).class_name('Product') }

  it { is_expected.to validate_presence_of(:title) }
end
