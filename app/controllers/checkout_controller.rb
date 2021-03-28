class CheckoutController < ApplicationController
  def create
    creature = Creature.find(params[:creature_id])
    cart_items ||= []
    total_cost = 0

    if current_user
      session[:shopping_cart].each do |id|
        creature = Creature.find(id)
        cart_hash = {
          name:        creature.species.titleize,
          description: creature.description,
          amount:      creature.price_cents,
          currency:    "cad",
          quantity:    1
        }
        cart_items.push(cart_hash)
        total_cost += creature.price_cents
      end

      cart_user = User.includes(:province).find(current_user.id)

      pst_or_qst_rate = "PST"
      pst_or_qst_description = "Provincial"

      if cart_user.province.id == 11
        pst_or_qst_rate = "QST"
        pst_or_qst_description = "Quebec"
      end

      pst_total = {
        name:        pst_or_qst_rate,
        description: "#{pst_or_qst_description} Sales Tax",
        amount:      (total_cost * (cart_user.province.pst_rate / 100)).to_i,
        currency:    "cad",
        quantity:    1
      }
      gst_total = {
        name:        "GST",
        description: "Goods and Services Tax",
        amount:      (total_cost * (cart_user.province.gst_rate / 100)).to_i,
        currency:    "cad",
        quantity:    1
      }
      hst_total = {
        name:        "HST",
        description: "Harmonized Sales Tax",
        amount:      (total_cost * (cart_user.province.hst_rate / 100)).to_i,
        currency:    "cad",
        quantity:    1
      }

      cart_items.push(pst_total)
      cart_items.push(gst_total)
      cart_items.push(hst_total)
    end

    if creature.nil?
      redirect_to root_path
      return
    end

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      success_url:          "#{checkout_success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url:           checkout_cancel_url,
      line_items:           cart_items
    )

    respond_to do |format|
      format.js
    end
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    return unless current_user && @session.payment_status == "paid"

    order_user = User.includes(:province).find(current_user.id)
    @order_details = Order.create(
      pst_rate:       order_user.province.pst_rate.to_f,
      gst_rate:       order_user.province.gst_rate.to_f,
      hst_rate:       order_user.province.hst_rate.to_f,
      total_cost:     @session.amount_total.to_f,
      payment_status: @session.payment_status,
      payment_intent: @session.payment_intent,
      user_id:        order_user.id
    )

    if @order_details.persisted?
      puts "Created new Order #{@order_details.id}"
    else
      puts "FAILED to create Order #{@order_details.id}"
      @order_details.errors.messages.each do |column, errors|
        errors.each do |error|
          puts "The #{column} property #{error}"
        end
      end
    end

    session[:shopping_cart].each do |id|
      creature = Creature.find(id)

      co = CreatureOrder.create(
        creature_id:    creature.id,
        order_id:       @order_details.id,
        quantity:       1,
        purchase_price: creature.price_cents
      )

      if co.persisted?
        puts "Created CreatureOrder for Order #{co.order_id} with Creature #{co.creature_id}"
      else
        puts "FAILED to create CreatureOrder for Order: #{co.order_id}"
        co.errors.messages.each do |column, errors|
          errors.each do |error|
            puts "The #{column} property #{error}"
          end
        end
      end
    end
  end

  def cancel
    # do more stuff
  end
end
