class CheckoutController < ApplicationController
  before_action :bag

  def bag
    @bag ||= []
  end

  def create
    return if nil?(Creature.find(params[:creature_id]))

    if current_user
      add_bag_items_to_checkout(session[:shopping_cart])
      add_taxes_to_checkout(User.includes(:province).find(current_user.id))
    end

    respond_to do |format|
      format.js
    end
  end

  def create_order(user)
    o = Order.create(
      pst_rate:       user.province.pst_rate.to_f,
      gst_rate:       user.province.gst_rate.to_f,
      hst_rate:       user.province.hst_rate.to_f,
      total_cost:     @session.amount_total.to_i,
      payment_status: @session.payment_status,
      payment_intent: @session.payment_intent,
      user_id:        user.id
    )
    validate_order(o)
  end

  def validate_order(order)
    redirect_to checkout_cancel_url unless order.persisted?
    create_creature_order(session[:shopping_cart], order)
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    return unless current_user && @session.payment_status == "paid"

    order_user = User.includes(:province).find(current_user.id)
    create_order(order_user)
  end

  def cancel; end

  def nil?(creature)
    redirect_to root_path if creature.nil?
  end

  def add_bag_items_to_checkout(cart)
    cart.each do |id, qty|
      creature = Creature.find(id)
      create_bag(creature, qty)
    end
  end

  def create_bag(creature, qty)
    creature = {
      price_data: {
        currency: "cad",
        unit_amount: creature.price_cents,
        product_data: {
          name:        creature.species.titleize,
          description: creature.description,
        },
      },
      quantity: qty.to_i
    }
    @bag.push(creature)
  end

  def add_taxes_to_checkout(user)
    province = user.province.name
    pst_total = create_tax(province, "PST or QST (Quebec) @ #{user.province.pst_rate}%", "Provincial Sales", user.province.pst_rate,
                           calculate_total_cost)
    gst_total = create_tax(province, "GST @ #{user.province.gst_rate}%", "Goods and Services", user.province.gst_rate,
                           calculate_total_cost)
    hst_total = create_tax(province, "HST @ #{user.province.hst_rate}%", "Harmonized Sales", user.province.hst_rate, calculate_total_cost)

    @bag.push(pst_total, gst_total, hst_total)
    start_stripe_session
  end

  def create_tax(province, tax_name, desc, rate, total)
    amount = (total * (rate / 100)).to_i
    {
      price_data: {
        currency:    "cad",
        unit_amount: amount,
        product_data: {
          name:        tax_name,
          description: "#{desc} Tax",
        },
      },
      quantity: 1,
    }
  end

  def calculate_total_cost
    total_cost = 0
    @bag.each do |k|
      creature_amount = k.dig(:price_data, :unit_amount).to_i
      total_cost += creature_amount
    end
    total_cost
  end

  def start_stripe_session
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      success_url:          "#{checkout_success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url:           checkout_cancel_url,
      line_items:           @bag,
      mode:                 "payment"
    )
  end

  def create_creature_order(cart, order)
    cart.each do |id, qty|
      creature = Creature.find(id)
      CreatureOrder.create(
        creature_id:    creature.id,
        order_id:       order.id,
        quantity:       qty,
        purchase_price: creature.price_cents
      )
    end
  end
end
