# frozen_string_literal: true

class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.includes(regions: :quests).order(:name)
  end

  def show
    @campaign = Campaign.includes(regions: :quests).find(params[:id])
    @regions = @campaign.regions.sort_by { |region| [region.position || Float::INFINITY, region.name.to_s] }
  end
end
