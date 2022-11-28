module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote unvote]
  end

  def upvote
    respond_to do |format|
      vote(1)
      format.json { success_vote_json }
    rescue ActiveRecord::RecordInvalid
      format.json { error_vote_json(@vote.errors.full_messages) }
    end
  end

  def downvote
    respond_to do |format|
      vote(-1)
      format.json { success_vote_json }
    rescue ActiveRecord::RecordInvalid
      format.json { error_vote_json(@vote.errors.full_messages) }
    end
  end

  def unvote
    respond_to do |format|
      if @votable.author == current_user
        format.json { error_vote_json(['could not destroy vote']) }
      else
        @votable.votes.where(user: current_user).first.destroy
        format.json { success_vote_json }
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote(value)
    @votable.transaction do
      @votable.lock!
      @vote = @votable.votes.new(user: current_user, value: value)
      @vote.save!
    end
  end

  def success_vote_json
    @votable.reload

    render json: {
      resource: @votable.class.name&.downcase,
      id: @votable.id,
      rating: @votable.rating
    }
  end

  def error_vote_json(errors)
    render json: {
      errors: errors,
      resource: @votable.class.name&.downcase,
      id: @votable.id
    }, status: :unprocessable_entity
  end
end
