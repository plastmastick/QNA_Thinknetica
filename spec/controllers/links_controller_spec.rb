# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe "DELETE #destroy" do
    let!(:resource) { create(:answer) }
    let!(:link) { create(:link, linkable: resource) }
    let(:delete_link) do
      delete :destroy,
             params: { id: link },
             format: :js
    end

    it "returns http success" do
      delete_link
      expect(response).to have_http_status(:success)
    end

    it "assign link to @link" do
      delete_link
      expect(assigns(:link)).to eq link
    end

    it "assign resource to @resource" do
      delete_link
      expect(assigns(:resource)).to eq resource
    end

    describe 'Author of resource' do
      before { login(resource.author) }

      it 'delete resource link' do
        expect { delete_link }.to change(resource.links, :count).by(-1)
      end

      it 'render destroy' do
        expect(delete_link).to render_template :destroy
      end
    end

    describe 'Not author of resource' do
      before { login(user) }

      it "can't delete this resource" do
        expect { delete_link }.not_to change(resource.links, :count)
      end

      it "render destroy" do
        expect(delete_link).to render_template :destroy
      end
    end
  end
end
