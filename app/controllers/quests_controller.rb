# frozen_string_literal: true

class QuestsController < ApplicationController
  def index
    @campaigns = Campaign.order(:name)
    @selected_campaign = @campaigns.find_by(id: params[:campaign_id]) if params[:campaign_id].present?
    @quests = Quest.includes(region: :campaign).order(:name)
    @quests = @quests.where(region: @selected_campaign.regions) if @selected_campaign
  end
end
