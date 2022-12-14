require 'swagger_helper'
require 'rails_helper'

describe ApiResourcesController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  path '/api/resources/{resource_id}' do
    get 'Retrieves a resource' do
      tags 'Resources'
      operationId 'getResource'
      produces 'application/json'
      parameter name: :resource_id, in: :path, type: :string

      response '200', 'Success' do
        schema type: :object, properties: {
          'id': { type: :integer },
          'name': { type: :string },
          'url': { type: :string, nullable: true },
          'description': { type: :string, nullable: true },
          'average_evaluation': { type: :string, nullable: true }
        }

        let(:resource_id) { create(:resource).id }
        run_test!
      end

      response '404', 'Resource Not Found' do
        schema type: :object, properties: {
          'code': { type: :integer },
          'message': { type: :string },
          'status': { type: :string }
        }
        let(:resource_id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/learning_units/{learning_unit_id}/resources' do
    get 'List of all resources belonging to a learning unit' do
      tags 'Resources'
      operationId 'listResources'
      produces 'application/json'
      parameter name: :learning_unit_id, in: :path, type: :string

      response '200', 'Success' do
        schema type: :array, items: {
          properties: {
            id: { type: :integer },
            name: { type: :string },
            url: { type: :string },
            description: { type: :string, nullable: true },
            average_evaluation: { type: :string }
          }
        }
        let(:learning_unit_id) { create(:learning_unit).id }
        run_test!

        context 'when there are no resources' do
          before do |example|
            submit_request(example.metadata)
          end

          it 'returns an empty array' do
            data = JSON.parse(response.body)
            expect(data.length).to eq(0)
          end
        end

        context 'when there is one resource' do
          before do |example|
            create(
              :resource,
              learning_unit_id:
            )
            submit_request(example.metadata)
          end

          it 'returns an array with 1 element' do
            data = JSON.parse(response.body)
            expect(data.length).to eq(1)
          end
        end
      end

      response '404', 'Learning Unit Not Found' do
        schema type: :object, properties: {
          'code': { type: :integer },
          'message': { type: :string },
          'status': { type: :string }
        }
        let(:learning_unit_id) { 'invalid' }
        run_test!
      end
    end

    post 'Creates a new resource for the given learning unit' do
      tags 'Resources'
      consumes 'application/json'
      operationId 'createResource'
      produces 'application/json'
      parameter name: :learning_unit_id, in: :path, type: :string
      parameter name: :resource, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          url: { type: :string, default: 'http://example.com' },
          description: { type: :string }
        }
      }

      response '201', 'Created' do
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          url: { type: :string, default: 'http://example.com' },
          description: { type: :string, nullable: true }
        }
        let(:learning_unit_id) { create(:learning_unit).id }
        let(:resource) { { name: 'test_resource', url: 'http://test.io' } }
        run_test!
      end

      response '400', 'Invalid parameters' do
        schema type: :object, properties: {
          'code': { type: :integer },
          'message': { type: :string },
          'status': { type: :string }
        }
        let(:learning_unit_id) { create(:learning_unit).id }

        context 'when url is not valid' do
          let(:resource) { { name: 'test_resource', url: 'badurl.io' } }

          run_test!
        end
      end

      response '404', 'Learning Unit does not exist' do
        schema type: :object, properties: {
          'code': { type: :integer },
          'message': { type: :string },
          'status': { type: :string }
        }
        let(:learning_unit_id) { 'invalid' }
        let(:resource) { { name: 'test_resource', url: 'http://test.io' } }
        run_test!
      end
    end
  end
end
