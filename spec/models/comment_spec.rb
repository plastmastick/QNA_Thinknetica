# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'Authorable'

  it { is_expected.to belong_to :commentable }

  it { is_expected.to validate_presence_of :body }
end
