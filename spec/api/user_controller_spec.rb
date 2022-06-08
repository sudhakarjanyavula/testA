require 'rails_helper'

RSpec.describe Api::UserController do
	let(:params)  { { :user => { :firstName => "sudhakar", :lastName => "janyavula", 
		:email => "sudhakar@gmail.com" } } }
    describe 'POST #create' do    	
    	context 'when params are correct' do
	    it 'is expected to create user successfully' do
	    	post '/api/user/', params: params    	
	    	body = JSON.parse(response.body, object_class: User)
	    	expect(body).to be_instance_of(User)
	    end

	    it 'is expected to have params assigned to it' do
	    	expect(params[:user][:firstName]).to eq('sudhakar')
	    	expect(params[:user][:lastName]).to eq('janyavula')
	    	expect(params[:user][:email]).to eq('sudhakar@gmail.com')
	    end 
	  end    	
    end

    describe 'PATCH #update' do
    	context 'when user exist in database' do
    	let(:user) {FactoryBot.create :user}
    	let(:params) { { id: user.id, user: { firstName: 'firstName', lastName: 'lastName',
    	email: 'email' } } }

    	#context 'when data is provided is vaild' do
    	it 'is expected to update user' do
    		patch "/api/user/#{user.id}"
	    	expect(params[:user][:firstName]).to eq('firstName')
		    expect(params[:user][:lastName]).to eq('lastName')
		    expect(params[:user][:email]).to eq('email')
		end
	 end
	end

	describe 'DELETE #destroy' do
		context 'when user exist in database' do
		let(:user) {FactoryBot.create :user}
		let(:params) { { id: user.id } } 
    	it 'is expected to destroy' do
    		delete "/api/user/#{user.id}"  #, params: { id: user.id}
    		expect(User.find_by_id(user.id)).to eq(nil)
    	end
       end
    end

    describe "Get #show" do
    	context 'is expected to show user by id' do
    	let(:user) {FactoryBot.create :user}
		let(:params) { { id: user.id } } 
		context 'when user is provided' do
		it 'show user' do
    	#binding.pry
			get "/api/user/#{user.id}"
			body = JSON.parse(response.body)
			expect(user.as_json).to eq(body)
		end
	   end
      end
    end

    describe "GET #index" do
    	it 'is expected to assign user instance variable' do
    		get "/api/users", params: params
    		body = JSON.parse(response.body)
    		expect(body).to eq(User.paginate(page:1).as_json)
    	end
    end

    describe "GET #typeahead" do
    	let(:params) {{input: "jan"}}
    	context 'is expected to match user with input' do

    	let(:user1) {FactoryBot.create(:user,{:firstName =>"sudhakar", :lastName =>"janyavula", :email =>"sudhakar@gmail.com"})}
    	
    	let(:user2) {FactoryBot.create(:user,{:firstName =>"dhanvik", :lastName =>"janyavula", :email =>"dhanvik@gmail.com"})}
    	
    	context 'when user is provided' do
    	it 'is expected to match user with input' do
    		FactoryBot.create(:user,{:firstName =>"sudhakar", :lastName =>"janyavula", :email =>"sudhakar@gmail.com"})
    		FactoryBot.create(:user,{:firstName =>"dhanvik", :lastName =>"janyavula", :email =>"dhanvik@gmail.com"})
    		get "/api/typeahead/#{params[:input]}", params: params
    		#binding.pry
    		body = response.body.split(' and ')
    		expect(body.length).to eq(2)
    	end
       end
      end
    end
end