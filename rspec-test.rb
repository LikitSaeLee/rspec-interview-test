feature 'editor' do
  let(:user) { FactoryGirl.create(:pro_user, infographic_count: 5)
  before { Capybara.current_driver = :selenium }

  context 'free user' do
    before { sign_in user }

    # Question 1 and 2
    describe 'publish an infographic', js: true do
      visit '/infographics'
      infographic = choose_a_random_infographic
      infographic.hover
      infographic.click_link 'edit'
      # wait for editor to load, it could takes 5-30s depend on network connection
      sleep 40
      # make sure the editor finish loaded by checking the presency loading icon
      expect(page).not_to have_css('img.pikto-loading-lg') 
      find('i.icon-publish').click
      click_link 'Publish Now'
      # wait for ajax call to publish infographic, usually 5-10s
      sleep 20
      expect(page).to have_content 'Your infographic is now published.'
    end

    # Question 4
    describe 'subscribe a monthly pro membership', js: true do
      visit '/pricing'
      expect(page.title).to eq('Pricing | Piktochart')
      click_button("pro-monthly")
      fill_in 'credit-card-number', with: 'assume_this_is_correct' # fails from here
      fill_in 'expiration', with: 'assume_this_is_correct'
      fill_in 'cvv', with: 'assume_this_is_correct'
      click_button('make-payment-button')
      sleep 50 # wait paypal to complete payment
      expect(page).to have_content('Payment Completed | Piktochart')
    end
  end

  def choose_a_random_infographic
    page.all("li.infographic-items").to_a.shuffle.first
  end

  def sign_in
    #TODO
  end
end

# Question 1. (Warm up)
# Oh no! Likit has eated the code in sign_in method! 
# By looking at our login page, complete the sign in method by looking at our login page.
# Assuming you can get the user email and password through user.email and user.password

# Question 2. 
# The test took more than 1min to run, what is the concerns and how can we optimize it.
# Answers: 1. Wait for event

# Question 3.
# During the test, there's a 5sec get request to www.s3.com to verify infographic's presency. 
# Which expect a status code 200. Assuming this request is unimportant, how could we speed up the test.
# Answers: 1. Use web mock the stub the request

# Question 4.
# By referring to our pricing page. Explain why the test fails and fix the test.
# Answers: 1. Use iframe