# frozen_string_literal: true

class QuestsController < ApplicationController
  def index
    @quests = Quest.includes(region: :campaign).order(:name)
  end
end
