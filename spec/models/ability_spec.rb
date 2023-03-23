# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }

    it { is_expected.not_to be_able_to :menage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    it { is_expected.not_to be_able_to :menage, :all }
    it { is_expected.to be_able_to :read, :all }
    it { is_expected.to be_able_to %i[create destroy], Subscription }

    context 'when Answer' do
      it { is_expected.to be_able_to :create, Answer }
      it { is_expected.to be_able_to :create_comment, Answer }
      it { is_expected.to be_able_to %i[update destroy], create(:answer, author: user) }
      it { is_expected.to be_able_to :best, create(:answer, question: create(:question, author: user)) }

      it { is_expected.not_to be_able_to %i[update destroy], create(:answer, author: other_user) }
      it { is_expected.not_to be_able_to :best, create(:answer, question: create(:question, author: other_user)) }
    end

    context 'when Question' do
      it { is_expected.to be_able_to :create, Question }
      it { is_expected.to be_able_to :create_comment, Question }
      it { is_expected.to be_able_to %i[update destroy], create(:question, author: user) }

      it { is_expected.not_to be_able_to %i[update destroy], create(:question, author: other_user) }
    end

    context 'when vote' do
      it { is_expected.to be_able_to %i[upvote downvote unvote], create(:answer, author: other_user) }
      it { is_expected.not_to be_able_to %i[upvote downvote unvote], create(:answer, author: user) }

      it { is_expected.to be_able_to %i[upvote downvote unvote], create(:question, author: other_user) }
      it { is_expected.not_to be_able_to %i[upvote downvote unvote], create(:question, author: user) }
    end
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { is_expected.to be_able_to :menage, :all }
  end
end
