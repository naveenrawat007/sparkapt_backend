class SubscriptionService
  DEFAULT_CURRENCY = 'usd'.freeze

  def initialize(params, user)
    @card_token = params[:token] if params[:token].present?
    @plan = Plan.find_by(stripe_plan_id: params[:plan_id]) if params[:plan_id].present?
    @user = user
  end

  def call
    begin
      smartapt_plan = Stripe::Plan.retrieve(@plan&.stripe_plan_id)
    rescue Exception => e
    end
    if smartapt_plan
      create_subscription(find_customer)
    else
      OpenStruct.new(message: 'Invalid Plan', status: 400)
    end
  end


  private

  attr_accessor :card_token, :user, :plan

  def find_customer
    if user.stripe_customer_id
      retrieve_customer(user&.stripe_customer_id)
    else
      create_customer
    end
  end

  def retrieve_customer(stripe_customer_id)
    Stripe::Customer.retrieve(stripe_customer_id)
  end

  def create_customer
    customer = Stripe::Customer.create(
      email: user&.email,
      source: card_token
    )
    user.update(stripe_customer_id: customer.id)
    customer
  end

  def create_subscription(customer)
    result = Stripe::Subscription.create({
      customer: customer,
      items: [
        {price: plan&.stripe_plan_id},
      ],
    })
    if result.status == "active"
      user.update(is_trial: false, trial_end: nil)
      subscription = user.subscriptions.new(plan_id: plan.id, status: 'active', active: true, current_start_datetime: Time.at(result.current_period_start), current_end_datetime: Time.at(result.current_period_end), stripe_subscription_id: result.id)
      if subscription.save
        OpenStruct.new(status: 200, message: "Thanks for subscribing us.")
      else
        OpenStruct.new(status: 200, message: 'Subscription not saved successfully.')
      end
    else
      OpenStruct.new(status: 400, message: 'Subscription failed please try again.')
    end
  end


end
