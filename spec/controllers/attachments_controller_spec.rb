# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  describe "DELETE #destroy" do
    let!(:file) { fixture_file_upload('test_xml.xml', 'text/xml') }
    let!(:resource) { create(:question, files: [file]) }
    let!(:resource_file) { resource.files.last }
    let(:delete_file) do
      delete :destroy,
             params: { id: resource_file },
             format: :js
    end

    it "returns http success" do
      delete_file
      expect(response).to have_http_status(:success)
    end

    it "assign resource to @resource" do
      delete_file
      expect(assigns(:record)).to eq resource
    end

    describe 'Author of resource' do
      before { login(resource.author) }

      it 'delete attached file' do
        expect { delete_file }.to change(resource.files, :count).by(-1)
      end

      it 'render destroy' do
        expect(delete_file).to render_template :destroy
      end
    end

    describe 'Not author of resource' do
      before { login(user) }

      it "can't delete this resource" do
        expect { delete_file }.not_to change(resource.files, :count)
      end

      it "render destroy" do
        expect(delete_file).to render_template :destroy
      end
    end
  end
end
