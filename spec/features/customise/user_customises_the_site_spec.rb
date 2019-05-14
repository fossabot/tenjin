RSpec.describe 'User customises the site', type: :feature, js: true, default_creates: true do
  before do
    setup_subject_database
    sign_in student
  end

  context 'when visiting the customisation page from the navbar' do
    it 'visits from the customise link' do
      visit(dashboard_path)
      find('a', text: 'Customise').click
      expect(page).to have_current_path(customise_path)
    end

    it 'visits from the challenge star' do
      visit(dashboard_path)
      find('i.fa-star').click
      expect(page).to have_current_path(customise_path)
    end

    it 'visits from the number of points' do
      visit(dashboard_path)
      find('#challenge-points').click
      expect(page).to have_current_path(customise_path)
    end
  end

  context 'when looking at available dashboard styles' do
    let(:dashboard_customisation) { create(:customisation, cost: 6) }
    let(:dashboard_customisation_expensive) { create(:customisation, cost: 20) }
    let(:second_customisation) { create(:customisation, cost: 2) }
    let(:student) { create(:user, school: school, challenge_points: 10) }

    before do
      dashboard_customisation
      visit(customise_path)
    end

    it 'shows available dashboard customisations' do
      expect(page).to have_content(dashboard_customisation.name.upcase)
    end

    it 'allows you to buy a dashbord style' do
      find('button#buy-dashboard-' + dashboard_customisation.value).click
      expect(page).to have_css('section#homework-' + dashboard_customisation.value)
    end

    it 'deducts the required amount of challenge points' do
      find('button#buy-dashboard-' + dashboard_customisation.value).click
      expect { student.reload }.to change(student, :challenge_points).by(-dashboard_customisation.cost)
    end

    it 'gives a notice if you do not have the required number of points' do
      dashboard_customisation_expensive
      visit(customise_path)
      find('button#buy-dashboard-' + dashboard_customisation_expensive.value).click
      expect(page).to have_css('.alert', text: 'You do not have enough points')
    end

    it 'shows the cost of the customisation' do
      expect(page).to have_css('#cost', text: dashboard_customisation.cost)
    end

    context 'when repurchasing a customisation already unlocked' do
      before do
        find('button#buy-dashboard-' + dashboard_customisation.value).click
        second_customisation
        visit(customise_path)
        find('button#buy-dashboard-' + second_customisation.value).click
        student.reload
      end

      it 'allows you to buy a previously bought customisation at no cost' do
        visit(customise_path)
        find('button#buy-dashboard-' + dashboard_customisation.value).click
        expect { student.reload }.to change(student, :challenge_points).by(0)
      end

      it 'sets the price of unlocked customisations to zero' do
        visit(customise_path)
        expect(page).to have_css('#cost', text: '0')
      end
    end
  end
end
