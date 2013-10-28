require 'spec_helper'
require 'soft_validation'

# Stub class for testing
class Softy 
  include SoftValidation

  # Stub the columns 
  def self.column_names
   ['mohr']
  end 

  # This is called via the tests:
  # soft_validate :has_cheezburgers?

  $hungry = true
  def haz_cheezburgers?
    soft_validations.add(:base, 'hungry!', fix: :cook_cheezburgers, success_message: 'no longer hungry, cooked a cheezeburger') if $hungry 
  end

  def needs_moar_cheez? 
    soft_validations.add(:mohr, 'hungry (for cheez)!') if $hungry 
  end

  def cook_cheezburgers
    $hungry = false
  end 
end


describe 'SoftValidation' do

  context 'class methods' do
    specify 'soft_validations' do
      expect(Softy.soft_validation_methods).to eq({all: []})
    end

    context 'add a method' do
      # reset the hash for each test
      before(:each) {Softy.soft_validation_methods = {all: []} }

      specify 'soft_validate :set' do
        expect(Softy.soft_validate(:haz_cheezburgers?)).to be_true
        expect(Softy.soft_validation_methods[:all]).to eq([:haz_cheezburgers?])
      end

      specify 'soft_validate :method, set: :set_name' do
        expect(Softy.soft_validate(:needs_moar_cheez?, set: :cheezy)).to be_true
        expect(Softy.soft_validation_methods[:all]).to eq([:needs_moar_cheez?])
        expect(Softy.soft_validation_methods[:cheezy]).to eq([:needs_moar_cheez?])
      end
    end

  end
  context 'instance methods' do
    let(:softy) {Softy.new}

    specify 'soft_validate' do
      expect(softy).to respond_to(:soft_validate)
    end

    specify 'soft_valid?' do
      expect(softy).to respond_to(:soft_valid?)
    end

    specify 'clear_soft_validations' do
      expect(softy).to respond_to(:clear_soft_validations)
    end

    specify 'fix_soft_validations' do
      expect(softy).to respond_to(:fix_soft_validations)
    end
  end

  context 'instance usage' do

    before(:all) do 
      # Stub the validation methods 
      Softy.soft_validation_methods = {all: []}
      Softy.soft_validate(:needs_moar_cheez?, set: :cheezy)
      Softy.soft_validate(:haz_cheezburgers?)
    end 

    let(:softy) {Softy.new}

    specify 'softy.soft_valid?' do
      expect(softy.soft_valid?).to be_false
    end

    specify 'softy.soft_validate' do
      expect(softy.soft_validate).to be_true
      expect(softy.soft_validations.class).to eq(SoftValidation::SoftValidations)
      expect(softy.soft_validations.fixed?).to be_false
    end

    specify 'softy.fix_soft_validations' do
      expect(softy.soft_validate).to be_true             # you must validated before you fix
      expect(softy.fix_soft_validations).to be_true      
      expect(softy.soft_validations.fixed?).to be_true 
      expect(softy.soft_validations.fix_messages).to eq(base: ['no longer hungry, cooked a cheezeburger'], mohr: ["was fixed (no message provided)"])
    end

    specify 'softy.soft_validated?' do
      expect(softy.soft_validated?).to be_false
      softy.soft_validate
      expect(softy.soft_validated?).to be_true
    end
  end

end

describe 'SoftValidations' do
  let(:soft_validations) {SoftValidation::SoftValidations.new(Softy.new)}

  specify 'add' do
    expect(soft_validations).to respond_to(:add) 
  end

  specify 'add(:invalid_attribute, "message") raises' do
    expect{soft_validations.add(:foo, 'no cheezburgahz!')}.to raise_error(RuntimeError, /not a column name/)
  end

  specify 'add(:attribute, "message")' do
    expect(soft_validations.add(:base, 'no cheezburgahz!')).to be_true
    expect(soft_validations.soft_validations).to have(1).things
  end

  specify 'add(:attribute, "message", fix: :method)' do
    expect(soft_validations.add(:base, 'no cheezburgahz!', fix: 'cook_a_burgah')).to be_true
    expect(soft_validations.soft_validations).to have(1).things
  end

  specify 'add with success/fail message without fix returns false' do
    expect(soft_validations.add(:base,'no cheezburgahz!', success_message: 'cook_a_burgah')).to be_false
  end

  specify 'add(:attribute, "message", fix: :method, success_message: "win",  failure_message: "fail")' do
    expect(soft_validations.add(:base, 'no cheezburgahz!', fix: 'cook_a_burgah', success_message: 'haz cheezburger', failure_message: 'no cheezburger')).to be_true
  end

  specify 'complete?' do
    soft_validations.validated = true 
    soft_validations.fixed = true 
    expect(soft_validations.complete?).to be_true
  end

end


describe 'SoftValidation' do
  let(:soft_validation) {SoftValidation::SoftValidation.new}

  context 'attributes' do
    specify 'attribute' do
    end

    specify 'message' do
    end

    specify 'fix' do
    end

    specify 'success_message' do
    end

    specify 'failure_message' do
    end

    specify 'result' do
    end
  end

  context 'methods' do

    # Call it locally
    specify 'run_fix' do
      pending
      # {true => :message} # returns an individual SoftValidationResult
    end

    specify 'fixed?' do
      pending
      # result.fixed?
    end

  end
end
