require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'logs the user in and redirects to the dashboard' do
        post :create, params: { email: user.email, password: user.password }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:notice]).to eq('Login successful!')
      end
    end

    context 'with invalid credentials' do
      it 'renders the new template with an alert' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq('Invalid email or password')
      end
    end
  end
end
