require 'spec_helper'
require 'guard/compat/test/helper'

describe Guard::ConsistencyFail do
  subject(:guard) { Guard::ConsistencyFail.new(options) }
  let(:options) { {} }

  describe '#options' do
    subject { super().options }

    context 'by default' do
      let(:options) { {} }

      describe 'run_on_start' do
        subject { super()[:run_on_start] }
        it { should be true }
      end

      describe 'environment' do
        subject { super()[:environment] }
        it { should be_nil }
      end
    end
  end

  describe '#start' do
    context 'when :run_on_start option is enabled' do
      let(:options) { { run_on_start: true } }

      it 'runs all' do
        expect(guard).to receive(:run_all)
        guard.start
      end
    end

    context 'when :run_on_start option is disabled' do
      let(:options) { { run_on_start: false } }

      it 'does nothing' do
        expect(guard).not_to receive(:run_all)
        guard.start
      end
    end
  end

  describe "when passing an environment option" do

    let(:consistency_fail) {Guard::ConsistencyFail.new({watchers:[], environment: 'test'})}

    before do
      allow(Guard::Compat::UI).to receive(:notify)
      allow(Guard::Compat::UI).to receive(:info)
      allow(Guard::Compat::UI).to receive(:error)
    end

    it "calls system with 'export RAILS_ENV=test;' call first" do

      expect(consistency_fail).to receive(:system).with("export RAILS_ENV=test; consistency_fail").and_return(true)
      consistency_fail.start
    end
  end

  describe "with the run_on_start option" do

    let(:consistency_fail) {Guard::ConsistencyFail.new({watchers:[], run_on_start: false })}

    before do
      allow(Guard::Compat::UI).to receive(:notify)
      allow(Guard::Compat::UI).to receive(:info)
      allow(Guard::Compat::UI).to receive(:error)
    end

    it "does not call system" do
      expect(consistency_fail).not_to receive(:system)
      consistency_fail.start
    end
  end
end
