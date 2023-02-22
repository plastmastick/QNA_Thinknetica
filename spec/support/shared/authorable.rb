# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples "Authorable" do
  it { is_expected.to belong_to :author }
end
