class RubyGemsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  
  PAGE_SIZE = 30

  def index
    if search_params[:q].present?
      @current_page = (search_params[:page] || 1).to_i
      @total_pages = (RubyGem.count / PAGE_SIZE.to_f).ceil

      page_offset = (@current_page - 1) * PAGE_SIZE

      @search_results = RubyGem.order(:created_at).limit(PAGE_SIZE).offset(page_offset)
    end
  end

  def search
    require "uri"
    require "net/http"
    require "json"

    url = URI("https://h72ashmv3j.execute-api.ap-northeast-1.amazonaws.com/dev/v1/licensed_sponsors/query")

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "text/plain"
    request.body = "{\"name\":\""+search_params[:q]+"\"}"

    response = https.request(request)
    # puts response.read_body
    @results = JSON.parse(response.read_body)['result']
    

    # @selected = Item.where(:category_id => params[:cat_id])
    respond_to do |format|
        format.js
    end
  end

  def show
    @rubygem = RubyGem.find(params[:id])
  end

  private

  def search_params
    params.permit(:q, :page)
  end
end
