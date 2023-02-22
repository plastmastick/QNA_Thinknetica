# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if @user
      @user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can %i[update destroy], [Answer, Question, Comment], author_id: user.id
    can %i[create create_comment], [Answer, Question]
    can :best, Answer do |answer|
      answer.question.author.id == user.id
    end
    can :me, User, user_id: user.id
    can [:upvote, :downvote, :unvote], [Answer, Question] do |votable|
      votable.author_id != user.id
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
