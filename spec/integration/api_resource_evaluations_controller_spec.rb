require 'swagger_helper'
require 'rails_helper'

describe ApiResourceEvaluationsController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  path '/api/resources/{resource_id}/resource_evaluation' do
    get 'Retrieves a resource' do
      tags 'Resource Evaluations'
      operationId 'getResourceEvaluation'
      produces 'application/json'
      parameter name: :resource_id, in: :path, type: :string

      response '200', 'Success' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 evaluation: { type: :integer },
                 resource_id: { type: :integer },
                 user_id: { type: :integer }
               }
        let(:resource_id) { create(:resource_evaluation, user:).resource_id }
        run_test!
      end

      response '404', 'Resource does not exist' do
        schema type: :object, properties: {
          'code': { type: :integer },
          'message': { type: :string },
          'status': { type: :string }
        }
        context 'when resource does not exist' do
          let(:resource_id) { 'invalid' }

          run_test!
        end

        context 'when resource exist, but evaluation not exist' do
          let(:resource_id) { create(:resource).id }

          run_test!
        end
      end
    end
  end

  path '/api/resources/{resource_id}/resource_evaluation' do
    put 'Creates or modifies the evaluation of a resource' do
      tags 'Resource Evaluations'
      operationId 'setResourceEvaluation'
      consumes 'application/json'
      parameter name: :resource_id, in: :path, type: :string
      parameter name: :evaluation, in: :body, schema: {
        type: :object,
        properties: {
          evaluation: { type: :integer, minimum: 1, maximum: 5 }
        },
        required: ['evaluation']
      }
      produces 'application/json'

      response '200', 'Success' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 evaluation: { type: :integer },
                 resource_id: { type: :integer },
                 user_id: { type: :integer }
               }
        let(:resource_id) { create(:resource).id }
        let(:evaluation) { { evaluation: 5 } }
        run_test!
      end

      response 404, 'Resource does not exist' do
        schema type: :object, properties: {
          'code': { type: :integer },
          'message': { type: :string },
          'status': { type: :string }
        }
        context 'when resource does not exist' do
          let(:resource_id) { 'invalid' }
          let(:evaluation) { { evaluation: 2 } }

          run_test!
        end
      end

      response 400, 'Invalid parameters' do
        schema type: :object, properties: {
          'code': { type: :integer },
          'message': { type: :string },
          'status': { type: :string }
        }

        context 'when evaluation is out of range' do
          let(:resource_id) { create(:resource).id }
          let(:evaluation) { { 'evaluation': -5 } }

          run_test!
        end

        context 'when evaluation param does not exist in the body' do
          let(:resource_id) { create(:resource).id }
          let(:evaluation) { { 'cat': 5 } }

          run_test!
        end
      end
    end
  end
end
