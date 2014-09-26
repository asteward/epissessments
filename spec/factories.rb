FactoryGirl.define do
  factory :bank_account do
    user

    after(:build) do |bank_account|
      balanced_bank_account = create_balanced_bank_account
      bank_account.account_uri = balanced_bank_account.href
    end

    factory :verified_bank_account do
      after(:create) do |verified_bank_account|
        verification = Verification.new(bank_account: verified_bank_account,
                                        first_deposit: 1,
                                        second_deposit: 1)
        verification.confirm
      end
      verified true
    end
  end

  factory :payment do
    association :bank_account, factory: :verified_bank_account
    amount 1
  end

  factory :user do
    name "Jane Doe"
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
    password_confirmation "password"

    factory :user_with_unverified_bank_account do
      association :bank_account
    end

    factory :user_with_verified_bank_account do
      association :bank_account, factory: :verified_bank_account
    end

    factory :user_with_admin do
      admin true
    end
  end

  # factory :assessment do
  #   title "Test Assessment"
  #   section "Javascript"
  #   url "www.something.com"
  # end

  factory :submission do
    link "www.githuburl.com"
    note "Good Work!"
    graded "false"
  end
end
