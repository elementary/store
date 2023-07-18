defmodule PrintfulTest do
  use ExUnit.Case

  @valid_recipient %{
    address1: "19749 Dearborn St",
    city: "Chatsworth",
    country_code: "US",
    state_code: "CA",
    zip: "91311",
    phone: "string"
  }
  @valid_order %{
    recipient: @valid_recipient,
    items: [
      %{
        variant_id: "202",
        external_variant_id: "1001",
        warehouse_product_variant_id: "2",
        quantity: 10,
        value: "2.99"
      }
    ]
  }

  # Missing the required recipient object
  @invalid_order %{
    items: [
      %{
        variant_id: "202",
        external_variant_id: "1001",
        warehouse_product_variant_id: "2",
        quantity: 10,
        value: "2.99"
      }
    ]
  }

  test "get countries" do
    countries = Printful.Shipping.countries()
    assert length(countries) > 0
  end

  test "get shipping rates" do
    # Use dummy input from the API examples and ensure an array of objects
    # containing at least a `rate` key is returned
    [%{rate: _rate} | _] =
      @valid_order
      |> Printful.Shipping.rates()
  end

  test "invalid shipping rates request" do
    assert_raise Printful.ApiError, fn -> Printful.Shipping.rates(@invalid_order) end
  end

  test "lists products" do
    products = Printful.Store.products()
    assert length(products) > 0
  end

  test "get single product" do
    %{sync_product: %{id: 264_672_898}} = Printful.Store.product(264_672_898)
  end

  test "get single variant" do
    %{id: 3_107_467_079} = Printful.Store.variant(3_107_467_079)
  end

  test "get orders" do
    orders = Printful.Order.list()
    assert length(orders) > 0
  end

  test "get single order" do
    %{id: 13} = Printful.Order.get(13)
  end

  test "create an order" do
    %{id: _} =
      @valid_order
      |> Printful.Order.create()
  end

  test "create an invalid order" do
    assert_raise Printful.ApiError, fn -> Printful.Order.create(@invalid_order) end
  end

  test "estimate order cost" do
    %{costs: _} =
      @valid_order
      |> Printful.Order.estimate()
  end

  test "estimate invalid order cost" do
    assert_raise Printful.ApiError, fn -> Printful.Order.estimate(@invalid_order) end
  end

  test "delete an order" do
    %{id: _} = Printful.Order.delete(13)
  end

  test "confirm an order" do
    %{id: _} = Printful.Order.confirm(13)
  end

  test "get tax rates" do
    %{required: _} = Printful.Tax.get(@valid_order)
  end

  test "invalid tax rates request" do
    assert_raise Printful.ApiError, fn -> Printful.Tax.get(@invalid_order) end
  end

  test "get catalog variant" do
    {:ok, %{variant: %{id: 13097}}} = Printful.Catalog.variant(13097)
  end
end
