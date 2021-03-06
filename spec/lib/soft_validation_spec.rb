require 'rails_helper'

# See bottom of this file for the Softy class stub.

# SoftValidation extends ActiveRecord.
describe 'SoftValidation' do
  context 'class methods' do
    specify 'soft_validations' do
      expect(Softy.soft_validation_methods).to eq('Softy' => {all: []})
    end

    context 'accessing soft_validations' do
      specify 'soft_validators() returns individual methods from soft_validation_methods' do
        expect(Softy.soft_validators).to eq([])
      end

    end

    context 'adding soft validations' do
      # reset the hash for each test
      before(:each) {Softy.soft_validation_methods = {'Softy' => {all: []}} }


      specify 'basic use: soft_validate(:method)' do
        expect(Softy.soft_validate(:haz_cheezburgers?)).to be_truthy
        expect(Softy.soft_validation_methods['Softy'][:all]).to eq([:haz_cheezburgers?])
      end

      specify 'assigment to a named set of validations: soft_validate(:method, set: :set_name)' do
        expect(Softy.soft_validate(:needs_moar_cheez?, set: :cheezy)).to be_truthy
        expect(Softy.soft_validation_methods['Softy'][:all]).to eq([:needs_moar_cheez?])
        expect(Softy.soft_validation_methods['Softy'][:cheezy]).to eq([:needs_moar_cheez?])
      end
    end

    context 'soft_validations between classes' do
      before(:each) {
        Softy.soft_validation_methods['Softy'] = {all: []}
        OtherSofty.soft_validation_methods['OtherSofty'] = {all: []}
      }

      specify 'methods assigned to parent are available to child' do
        Softy.soft_validate(:yucky_cheezburgers?)
        expect(OtherSofty.soft_validators).to include(:yucky_cheezburgers?)
      end

      specify 'methods assigned to child are not merged with parents' do
        OtherSofty.soft_validate(:haz_cheezburgers?)
        expect(Softy.soft_validation_methods['Softy'][:all]).to eq([])
      end

      context 'accessed via soft_validators' do
        specify 'soft_validator returns a single instance of the method when method assigned to parent' do
          Softy.soft_validate(:haz_cheezburgers?)
          expect(Softy.soft_validators).to eq([:haz_cheezburgers?])
          expect(OtherSofty.soft_validators).to eq([:haz_cheezburgers?])
        end

        specify 'soft_validator returns a single instance of the method when method assigned to child' do
          OtherSofty.soft_validate(:haz_cheezburgers?)
          expect(Softy.soft_validators).to eq([])
          expect(OtherSofty.soft_validators).to eq([:haz_cheezburgers?])
        end
      end

    # specify 'methods assigned to one class are not available to another' do
    #   expect(Softy.soft_validate(:haz_cheezburgers?)).to be_truthy
    #   expect(Softy.soft_validation_methods[:all]).to eq([:haz_cheezburgers?])
    #   expect(OtherSofty.soft_validation_methods[:all]).to eq([])
    #   expect(OtherSofty.soft_validate(:foo)).to be_truthy
    #   expect(OtherSofty.soft_validation_methods[:all]).to eq([:foo])
    #   expect(Softy.soft_validation_methods[:all]).to eq([:haz_cheezburgers?])
    # end
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

  context 'example usage' do
    before(:each) do 
      # Stub the validation methods 
      Softy.soft_validation_methods = {'Softy' => {all: []}}
      Softy.soft_validate(:needs_moar_cheez?, set: :cheezy)
      Softy.soft_validate(:haz_cheezburgers?)
    end 

    let(:softy) {Softy.new}

    specify 'softy.soft_valid?' do
      expect(softy.soft_valid?).to be_falsey
    end

    specify 'softy.soft_validated?' do
      expect(softy.soft_validated?).to be_falsey
      softy.soft_validate
      expect(softy.soft_validated?).to be_truthy
    end

    context 'after soft_validate' do
      before(:each) {
        @softy = Softy.new
        @softy.soft_validate
      }

      specify 'softy.soft_validate' do
        expect(@softy.soft_validations.class).to eq(SoftValidation::SoftValidations)
        expect(@softy.soft_validations.fixes_run?).to be_falsey
      end

      specify 'softy.fix_soft_validations(:some_bad_value)' do
        expect{@softy.fix_soft_validations(:some_bad_value)}.to raise_error
      end

      specify 'softy.fix_soft_validations' do
        expect(@softy.soft_validations.on(:mohr).size).to eq(1)
        expect(@softy.fix_soft_validations).to be_truthy
        expect(@softy.soft_validations.fixes_run?).to eq(:automatic) # be_true 
        expect(@softy.soft_validations.fix_messages).to eq(base: ['no longer hungry, cooked a cheezeburger'], mohr: ["fix not run, no fix available"])

        # TODO: Move out  
        expect(@softy.soft_validations.on(:mohr).size).to eq(1)
        expect(@softy.soft_validations.messages).to eq(["hungry (for cheez)!", "hungry!"] ) 
        expect(@softy.soft_validations.messages_on(:mohr)).to eq(['hungry (for cheez)!'] ) 
      end

      specify 'softy.fix_soft_validations(:requested)' do
        expect(@softy.soft_validations.on(:mohr).size).to eq(1)
        expect(@softy.fix_soft_validations(:requested)).to be_truthy
        expect(@softy.soft_validations.fixes_run?).to eq(:requested) 
        expect(@softy.soft_validations.fix_messages).to eq(mohr: ["fix not run, no fix available"], base: ['fix available, but not triggered'])
      end
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
    expect(soft_validations.add(:base, 'no cheezburgahz!')).to be_truthy
    expect(soft_validations.soft_validations.count).to eq(1)
  end

  specify 'add(:attribute, "message", fix: :method)' do
    expect(soft_validations.add(:base, 'no cheezburgahz!', fix: 'cook_a_burgah')).to be_truthy
    expect(soft_validations.soft_validations.count).to eq(1)
  end

  specify 'add(:attribute, "message", fix: :method, fix_trigger: :automatic)' do
    expect(soft_validations.add(:base, 'no cheezburgahz!', fix: 'cook_a_burgah', fix_trigger: :automatic)).to be_truthy
    expect(soft_validations.soft_validations.count).to eq(1)
  end

  specify 'add with success/fail message without fix returns false' do
    expect(soft_validations.add(:base,'no cheezburgahz!', success_message: 'cook_a_burgah')).to be_falsey
  end

  specify 'add(:attribute, "message", fix: :method, success_message: "win",  failure_message: "fail")' do
    expect(soft_validations.add(:base, 'no cheezburgahz!', fix: 'cook_a_burgah', success_message: 'haz cheezburger', failure_message: 'no cheezburger')).to be_truthy
  end

  specify 'complete?' do
    soft_validations.validated = true 
    expect(soft_validations.complete?).to be_truthy
  end

  specify 'on' do
    expect(soft_validations).to respond_to(:on)
    expect(soft_validations.on(:base)).to eq([])
  end

  specify 'messages' do
    expect(soft_validations).to respond_to(:messages)
  end

  specify 'messages_on' do
    expect(soft_validations).to respond_to(:messages)
  end
end

describe 'SoftValidation' do
  let(:soft_validation) {SoftValidation::SoftValidation.new}
  context 'attributes' do
    specify 'attribute' do
      expect(soft_validation).to respond_to(:attribute) 
    end

    specify 'message' do
      expect(soft_validation).to respond_to(:message)
    end

    specify 'fix' do
      expect(soft_validation).to respond_to(:fix)
    end

    specify 'success_message' do
      expect(soft_validation).to respond_to(:success_message)
    end

    specify 'failure_message' do
      expect(soft_validation).to respond_to(:failure_message)
    end

    specify 'fixed' do
      expect(soft_validation).to respond_to(:fixed) 
      soft_validation.fixed = :fixed
      expect(soft_validation.fixed?).to be_truthy
    end
  end

  specify 'result_message()' do
    soft_validation.failure_message = 'a'
    soft_validation.success_message = 'a'
    expect(soft_validation).to respond_to(:result_message) 
  end

end


# Stub class for testing. Mimics only
# the ActiveRecord Model methods we need to test, but see also FakeTable for
# future refactoring.
class Softy 
  include SoftValidation

  # stub AR ancestors method
  def self.ancestors
    []
  end

  def self.column_names
    ['mohr']
  end 

  attr_accessor :hungry
  # This is called in test
  # soft_validate :has_cheezburgers?

  def initialize
    @hungry = true
  end

  def haz_cheezburgers?
    soft_validations.add(:base, 'hungry!', fix: :cook_cheezburgers, success_message: 'no longer hungry, cooked a cheezeburger') if @hungry
  end

  def needs_moar_cheez? 
    soft_validations.add(:mohr, 'hungry (for cheez)!') if @hungry 
  end

  def cook_cheezburgers
    @hungry = false
    true
  end 
end

# Stub class for testing, used to ensure that soft validation
# methods are specific to a class
class OtherSofty < Softy
  # soft_validate(:bar)
  def self.column_names
    ['lezz']
  end

  # Stub ancestors method
  def self.ancestors
   [Softy]
  end 
end


