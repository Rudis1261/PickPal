class HeroesController < ApplicationController
  before_action :set_hero, only: [:show, :edit, :update, :destroy]
  before_action :set_heroes, only: [:index]
  before_action :validate_name, only: [:one]
  before_action :set_hero_by_name, only: [:one]

  def initialize
    @columns = :role, :stat, :ability, :heroic
    @column_array = ['role', 'stat', 'ability', 'heroic']
  end

  def index
    return render :json => @heroes,
                  include: @column_array
  end

  def show
    return render :json => @hero.first,
                  include: @column_array
  end

  def one
    return render :json => @hero.first,
                  include: @column_array
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_heroes
      @heroes = Hero.joins(:role).includes(@columns).order(:name).all
      return render :json => ApplicationHelper.http404,
                    status: 404 if @heroes.size == 0
    end

    def set_hero
      @hero = Hero.where(id: params[:id]).joins(:role).includes(@columns)
      return render :json => ApplicationHelper.http404,
                    status: 404 if @hero.size == 0
    end

    def set_hero_by_name
      @hero = Hero.where(slug: params[:name]).includes(@columns)
      return render :json => ApplicationHelper.http404,
                    status: 404 if @hero.size == 0
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hero_params
      params.require(:hero).permit(:title, :name, :slug, :poster_image, :role_id, :stat_id, :heroic_id)
    end

    def validate_name
      name_pattern = /^[a-zA-Z\-]+$/
      if !params[:name] || params[:name].scan(name_pattern) == [] || params[:name].scan(name_pattern).first != params[:name]
        return render :json => ApplicationHelper.error('Invalid name provided')
      end
    end
end
