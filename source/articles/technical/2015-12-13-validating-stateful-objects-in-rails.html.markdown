---
title: Validating Stateful Objects In Rails
date: 2015-12-13 21:00 UTC
tags: rails, ruby, state, validation
---
Let's talk about state. Or actually, let's not talk about state. I think we have talked enough about state. Let me just say that it's very easy to think use state as a solution in OO programming. Especially when Rails give you tools such as `enum`.

There is a trap though. Things can become very messy, very quick. I have seen this in code bases I inherited as well as ones I helped create. While working at a project with a colleague we ran into state and wanted to curtail the increasing amount of code it started to bleed.

READMORE

A short example to explain what kind of state I am talking about:

```ruby
class Order
  enum status: %i(open paid delivered cancelled)
end
```

The initial thought was to have conditional validations, but as we worked on the project and reviewed eachothers code we knew this was not the way.

## Control Your Controllers

Instead we decided to return to a very RESTful way of doing things. Instead of having just one controller we implemented several controllers `OpenOrdersController`, `PaidOrdersController`, etc.

This was already a relief and helped us keep the controllers simple. But then the controller action, namely `create` started to expand. Both annoyed and grateful to [Rubocop](https://github.com/bbatsov/rubocop), we had to look for different solutions.

We came up with a `Finalizer` pattern. 

```ruby
class PaidOrdersController < ApplicationController
  def create
    begin
      @order.assign_attributes(order_params)
      FinalizeOrderPayment.new(@order).call
    rescue ActiveRecord::RecordInvalid
      render 'something'
    end
  end
end
```

There was a bit more going on, but you get the point. We delegate all the logic very specific to paying an order to a new item, a finalizer as we started to call it.

## Finally

The `Finalizer` in turn looks somewhat like this:

```ruby
class FinalizeOrderPayment
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def call
    unless OrderPaymentValidator.new(order).valid?
      fail ActiveRecord::RecordInvalid, order
    end
    order.paid_on = Date.current
    order.send_to_shipping
    order.save
  end
end
```

Again, the first iteration had the validations right in there, but it became clear fast that it was doing too much. So we created the custom validator. It is a very simple object:

```ruby
class OrderPaymentValidator
  include ActiveModel::Validations

  delegate(
    :buyer,
    :payment_confirmation,
    :product,
    :errors,
    to: :assessment
  )

  validates(
    :buyer,
    :payment_confirmation,
    :product,
    presence: true
  )

  validates :address, presence: true, if: :ship_order?

  attr_reader :order

  def initialize(order)
    @order = order
  end

  private

  def ship_order?
    # Something very specific
  end
end

```

This is it really. We did this for each type of `Order` we could have. It kept things very clear. Instead of filling the `Order` class with lots of different validations we make a clean cut selection of what we want to validate and when without having to resort to conditional callbacks.

I came to see the `Finalizer` and the `Validator` objects as guards for changing state. Of course I wrote plenty of specs to make sure this code was solid.

On a project with legacy code I inherited I found a great mess whent it came to state and conditional validations as well. The conditions were simpler, so I didn't make a `Finalizer` object, only a custom `Validator` which I call directly in the controller.

Something like the following. Note that I chose a different naming style here. It was another project and I am only using this as an example. I try to be consistent within a project though, just wanted to show another take

```ruby
class CancelledOrderController < ApplicationController
  def create
    @order.assign_attributes(order_params)
    if CancelledOrderValidator.new(@order).valid?
      @order.cancel
      flash[:notice] = 'Order cancelled'
      redirect_to orders_path
    else
      render :new
    end
  end
end
```

This is a more simple approach when you don't need to do do much else to transition an `Order` to another state, but it still allows you to treat each `Order` state as its own resource. I found it very helpful in cleaning things up.

Truth be told, in future projects I will probably avoid status altogether and go straight into creating different models for each state which may or may not point to the same database table. We'll see.

Only after we implemented it we were informed on changesets within the Phoenix framework for Elixir. My colleague [Tom Kruijsen wrote about it in his own blogpost](https://medium.com/@tomkr/three-things-i-m-liking-about-phoenix-a7688f03b6ef#.5o9gwg5qa). This seems a very similar approach, but isn't available as such in Rails.
