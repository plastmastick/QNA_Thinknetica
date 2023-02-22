# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples "Attachable" do
  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
