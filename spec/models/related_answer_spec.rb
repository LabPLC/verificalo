require 'spec_helper'

describe RelatedAnswer do
  before do
    @related_answer = FactoryGirl.build(:related_answer)
  end

  subject { @related_answer }

  it { should belong_to(:answer) }
  it { should belong_to(:related) }

  it { should be_valid }
end
