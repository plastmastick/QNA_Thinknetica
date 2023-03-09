# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "Commentable"
  it_behaves_like "Votable"
  it_behaves_like 'Authorable'
  it_behaves_like 'Linkable'
  it_behaves_like 'Attachable'

  it { is_expected.to have_one(:reward).dependent(:destroy) }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  it { is_expected.to have_many(:subscribers).through(:subscriptions).source(:user).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :reward }
end
