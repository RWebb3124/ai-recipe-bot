class MessagesController < ApplicationController
  before_action :set_chat

  def create
    content = params[:content].to_s.strip

    if content.blank?
      redirect_to @chat, alert: "Tell me what you'd like to change."
    else
      RecipeGenerator.new(@chat).refine(content)
      redirect_to @chat
    end
  rescue RubyLLM::Error, Faraday::Error => e
    redirect_to @chat, alert: "Couldn't reach the recipe helper (#{e.class})."
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end
end
