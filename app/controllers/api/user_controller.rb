class Api::UserController < ApplicationController
	def create
    #binding.pry
    render json: User.create(user_params)  
  end

  def index
    render json: User.paginate(:page => params[:page])
  end
  
  def update
  	#binding.pry
    user = User.find_by_id(params[:id])
    user.update(user_params) if user
    render json: user
  end

  def show
    render json: User.find_by_id(params[:id])
  end

   def destroy
     User.delete(params[:id])
     render json: []
   end

  def typeahead
    matches = []
    input_str = params[:input]
    User.type_matches(input_str).each do |user|
      matches << user.firstName + ' ' + user.lastName
    end
     results = matches.present? ? matches.join(' and ') : ''
     render json: results
  end

  private

  def user_params
   params.permit(:firstName, :lastName, :email)
  end
end
