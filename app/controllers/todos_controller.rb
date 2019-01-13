class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @todos = Todo.all.order(:created_at)
    render json: @todos
  end

  # GET /todos/1
  def show
    render json: @todo
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy
  end

  def scraper
    url = "https://blockwork.cc/"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    jobs = []
    job_listings = parsed_page.css('div.listingCard')
    
    page = 1
    per_page = job_listings.count
    total = parsed_page.css('div.job-count').text.split(' ')[1].gsub(',','').to_i
    last_page = (total.to_f / per_page.to_f).round
    while page <= last_page
      pagination_url = "https://blockwork.cc/listings?page=#{page}"
      puts pagination_url
      puts "Page: #{page}"
      puts ""

      pagination_unparsed_page = HTTParty.get(pagination_url)
      pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
      pagination_job_listings = pagination_parsed_page.css('div.listingCard')
      
      pagination_job_listings.each do |job_listing|
        job = {
          title: job_listing.css('span.job-title').text,
          company: job_listing.css('span.company').text,
          location: job_listing.css('span.location').text,
          url: "https://blockwork.cc" + job_listing.css('a')[0].attributes["href"].value
        }
        jobs << job
        puts ">>>>>> Added #{job[:title]}"
        puts ""
      end
      page += 1
    end
     render json: jobs
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def todo_params
      params.require(:todo).permit(:label, :is_done)
    end
end
