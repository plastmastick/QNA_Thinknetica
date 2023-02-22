# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples "Linkable" do
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for :links }
end
