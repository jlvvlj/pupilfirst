require 'rails_helper'

feature 'Applicantion Process' do
  # Things that are assumed to exist.
  let!(:batch) { create :batch }
  let!(:application_stage_1) { create :application_stage, number: 1 }
  let!(:application_stage_2) { create :application_stage, number: 2 }
  let!(:application_stage_3) { create :application_stage, number: 3 }
  let!(:application_stage_4) { create :application_stage, number: 4 }
  let!(:application_stage_5) { create :application_stage, number: 5 }

  context 'apply page' do
    context 'when no batches are open' do
      it 'does not contain apply button' do
        visit apply_index_path
        expect(page).to_not have_link('Start Application')
      end
    end

    context 'when a batch is open for applications' do
      it 'contains apply button' do
        batch.update application_stage: application_stage_1, application_stage_deadline: 15.days.from_now
        visit apply_index_path
        expect(page).to have_link('Start Application', href: apply_batch_path(batch: batch.batch_number))
      end
    end
  end
end
