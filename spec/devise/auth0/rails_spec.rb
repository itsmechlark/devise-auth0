# frozen_string_literal: true

require 'spec_helper'
require 'devise/auth0/rails'

RSpec.describe Devise::Engine do
  subject(:initializer) do
    described_class.initializers.detect do |initializer|
      initializer.name == 'devise.auth0'
    end 
  end 

  describe 'initializer position' do
    context 'before initializer' do
      it { expect(initializer.before).to(eq(:build_middleware_stack)) }
    end

    context 'after initializer' do
      it { expect(initializer.after).to(eq(:load_config_initializers)) }
    end
  end

  describe 'auth0 provider initialization' do
    subject(:config) { Devise.omniauth_configs[:auth0] }

    context 'when devise auth0 omniauth is true' do
      pending 'adds auth0 provider to omniauth from configuration' do
        expect(true).to be(false)
      end
    end
  end
end