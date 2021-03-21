# frozen_string_literal: true

require 'rails_helper'

describe ProductTag, type: :model do
  it { is_expected.to belong_to(:product).class_name('Product') }
  it { is_expected.to belong_to(:tag).class_name('Tag') }

  it { is_expected.to validate_presence_of(:product) }
  it { is_expected.to validate_presence_of(:tag) }
end
