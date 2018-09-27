module DashboardHelper

  def icon(story)
    case story.story_type
    when 'feature' then 'fa fa-star orange'
    when 'bug'     then 'fa fa-bug red'
    when 'chore'   then 'fa fa-cog'
    when 'release' then 'fa fa-flag-checkered green'
    else
      story.story_type
    end 
  end

  def bar_icons(size)
    '<span class="icon-bar"></span>' * size
  end

  def show_estimation_icons?(story)
    story.estimate.to_i <= 5
  end

  def small_strong_text(text)
    "<small><strong>#{text}</strong></small>"
  end


  def estimation(story)
    if estimated?(story)
      show_estimation_icons?(story) ? bar_icons(story.estimate) : small_strong_text(story.estimate)
    end
  end

  def estimation_class(story)
    if type_chore?(story) or type_release?(story)
      'unestimateable'
    else
      (story.estimate and story.estimate.to_i >= 0) ? 'estimated' : 'unestimated'
    end
  end

  def state(story)
    case story.current_state
    when 'accepted'    then "label label-success #{story.current_state}"
    when 'delivered'   then "label label-warning #{story.current_state}"
    when 'started'     then "label label-info #{story.current_state}"
    when 'rejected'    then "label label-danger #{story.current_state}"
    else
      "label label-default #{story.current_state}"
    end
  end

  def card_class(vote, reveal)
    if vote.nil?
      'card card-blank'
    elsif vote.is_a?(FalseClass)
      'card card-hidden'
    elsif reveal
      'card card-revealed'
    else
      'card'
    end
  end

  # This method is used to check story state or type
  #   state_accepted? - returns true if story current state is accepted
  #   type_chore? - returns true if story type is chore
  #   - etc -
  #
  def method_missing(meth_id, *args)
    if meth_id =~ /state_([a-z_]+)?/
      args.first.current_state == meth_id.to_s.chop.split('state_').last
    elsif meth_id =~ /type_([a-z_]+)?/
      args.first.story_type == meth_id.to_s.chop.split('type_').last
    else
      super
    end
  end

  def unestimateable?(story)
    estimate_not_applicable?(story) or not estimateable?(story)
  end

  def estimateable?(story)
    story.estimate.nil? or story.estimate.to_i < 0
  end

  def estimated?(story)
    story.estimate and story.estimate.to_i > 0
  end

  def estimate(story)
    estimate_not_applicable?(story) ? t('na') : story.estimate
  end

  def estimate_not_applicable?(story)
    type_chore?(story) or
    type_bug?(story)
  end

  def voting(vote)
    (vote.user == current_user['username']) ? vote.vote : false
  end

  def nickname(user)
    user.split('@').first.split('.').first
  end

  def current_user_has_voted?(story)
    Vote.where(story_id: story.id, user: current_user['username']).present?
  end

  def get_initial_display(story)
    if estimation_class(story) == "unestimated"
      return "block"
    else
      return "none"
    end
  end

end