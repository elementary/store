defmodule Printful.MockServer do
  @moduledoc """
  A set of mock HTTP endpoints for Printful
  """

  use Plug.Router

  @valid_order %{
    "id" => 13,
    "external_id" => "4235234213",
    "store" => 10,
    "status" => "draft",
    "shipping" => "STANDARD",
    "shipping_service_name" => "Flat Rate (3-4 business days after fulfillment)",
    "created" => 1_602_607_640,
    "updated" => 1_602_607_640,
    "recipient" => %{
      "name" => "John Smith",
      "company" => "John Smith Inc",
      "address1" => "19749 Dearborn St",
      "address2" => "string",
      "city" => "Chatsworth",
      "state_code" => "CA",
      "state_name" => "California",
      "country_code" => "US",
      "country_name" => "United States",
      "zip" => "91311",
      "phone" => "string",
      "email" => "string",
      "tax_number" => "123.456.789-10"
    },
    "items" => [
      %{
        "id" => 1,
        "external_id" => "item-1",
        "variant_id" => 1,
        "sync_variant_id" => 1,
        "external_variant_id" => "variant-1",
        "warehouse_product_variant_id" => 1,
        "product_template_id" => 1,
        "quantity" => 1,
        "price" => "13.00",
        "retail_price" => "13.00",
        "name" => "Enhanced Matte Paper Poster 18×24",
        "product" => %{
          "variant_id" => 3001,
          "product_id" => 301,
          "image" => "https://files.cdn.printful.com/products/71/5309_1581412541.jpg",
          "name" =>
            "Bella + Canvas 3001 Unisex Short Sleeve Jersey T-Shirt with Tear Away Label (White / 4XL)"
        },
        "files" => [
          %{
            "type" => "default",
            "id" => 10,
            "url" => "https://www.example.com/files/tshirts/example.png",
            "options" => [
              %{
                "id" => "template_type",
                "value" => "native"
              }
            ],
            "hash" => "ea44330b887dfec278dbc4626a759547",
            "filename" => "shirt1.png",
            "mime_type" => "image/png",
            "size" => 45_582_633,
            "width" => 1000,
            "height" => 1000,
            "dpi" => 300,
            "status" => "ok",
            "created" => 1_590_051_937,
            "thumbnail_url" =>
              "https://files.cdn.printful.com/files/ea4/ea44330b887dfec278dbc4626a759547_thumb.png",
            "preview_url" =>
              "https://files.cdn.printful.com/files/ea4/ea44330b887dfec278dbc4626a759547_thumb.png",
            "visible" => true,
            "is_temporary" => false
          }
        ],
        "options" => [
          %{
            "id" => "OptionKey",
            "value" => "OptionValue"
          }
        ],
        "sku" => nil,
        "discontinued" => true,
        "out_of_stock" => true
      }
    ],
    "branding_items" => [
      %{
        "id" => 1,
        "external_id" => "item-1",
        "variant_id" => 1,
        "sync_variant_id" => 1,
        "external_variant_id" => "variant-1",
        "warehouse_product_variant_id" => 1,
        "product_template_id" => 1,
        "quantity" => 1,
        "price" => "13.00",
        "retail_price" => "13.00",
        "name" => "Enhanced Matte Paper Poster 18×24",
        "product" => %{
          "variant_id" => 3001,
          "product_id" => 301,
          "image" => "https://files.cdn.printful.com/products/71/5309_1581412541.jpg",
          "name" =>
            "Bella + Canvas 3001 Unisex Short Sleeve Jersey T-Shirt with Tear Away Label (White / 4XL)"
        },
        "files" => [
          %{
            "type" => "default",
            "id" => 10,
            "url" => "https://www.example.com/files/tshirts/example.png",
            "options" => [
              %{
                "id" => "template_type",
                "value" => "native"
              }
            ],
            "hash" => "ea44330b887dfec278dbc4626a759547",
            "filename" => "shirt1.png",
            "mime_type" => "image/png",
            "size" => 45_582_633,
            "width" => 1000,
            "height" => 1000,
            "dpi" => 300,
            "status" => "ok",
            "created" => 1_590_051_937,
            "thumbnail_url" =>
              "https://files.cdn.printful.com/files/ea4/ea44330b887dfec278dbc4626a759547_thumb.png",
            "preview_url" =>
              "https://files.cdn.printful.com/files/ea4/ea44330b887dfec278dbc4626a759547_thumb.png",
            "visible" => true,
            "is_temporary" => false
          }
        ],
        "options" => [
          %{
            "id" => "OptionKey",
            "value" => "OptionValue"
          }
        ],
        "sku" => nil,
        "discontinued" => true,
        "out_of_stock" => true
      }
    ],
    "incomplete_items" => [
      %{
        "name" => "Red T-Shirt",
        "quantity" => 1,
        "sync_variant_id" => 70,
        "external_variant_id" => "external-id",
        "external_line_item_id" => "external-line-item-id"
      }
    ],
    "costs" => %{
      "currency" => "USD",
      "subtotal" => "10.00",
      "discount" => "0.00",
      "shipping" => "5.00",
      "digitization" => "0.00",
      "additional_fee" => "0.00",
      "fulfillment_fee" => "0.00",
      "retail_delivery_fee" => "0.00",
      "tax" => "0.00",
      "vat" => "0.00",
      "total" => "15.00"
    },
    "retail_costs" => %{
      "currency" => "USD",
      "subtotal" => "10.00",
      "discount" => "0.00",
      "shipping" => "5.00",
      "tax" => "0.00",
      "vat" => "0.00",
      "total" => "15.00"
    },
    "pricing_breakdown" => [
      %{
        "customer_pays" => "3.75",
        "printful_price" => "6",
        "profit" => "-2.25",
        "currency_symbol" => "USD"
      }
    ],
    "shipments" => [
      %{
        "id" => 10,
        "carrier" => "FEDEX",
        "service" => "FedEx SmartPost",
        "tracking_number" => 0,
        "tracking_url" => "https://www.fedex.com/fedextrack/?tracknumbers=0000000000",
        "created" => 1_588_716_060,
        "ship_date" => "2020-05-05",
        "shipped_at" => 1_588_716_060,
        "reshipment" => false,
        "items" => [
          %{
            "item_id" => 1,
            "quantity" => 1,
            "picked" => 1,
            "printed" => 1
          }
        ]
      }
    ],
    "gift" => %{
      "subject" => "To John",
      "message" => "Have a nice day"
    },
    "packing_slip" => %{}
  }

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: {Jason, :decode!, [[keys: :atoms]]}
  )

  plug(:dispatch)

  get "/countries" do
    success(conn, [
      %{
        code: "Australia",
        name: "AU",
        states: [
          %{
            code: "ACT",
            name: "Australian Capital Territory"
          }
        ],
        region: "oceania"
      }
    ])
  end

  post "/shipping/rates" do
    case conn.body_params do
      %{
        recipient: %{
          address1: _address1,
          city: _city,
          country_code: _country_code,
          state_code: _state_code,
          zip: _zip
        },
        items: [%{variant_id: _variant_id, quantity: _quantity}]
      } ->
        success(conn, [
          %{
            "id" => "STANDARD",
            "name" => "Flat Rate (Estimated delivery: May 19–24) ",
            "rate" => "13.60",
            "currency" => "EUR",
            "minDeliveryDays" => 4,
            "maxDeliveryDays" => 7,
            "minDeliveryDate" => "2022-10-17",
            "maxDeliveryDate" => "2022-10-20"
          }
        ])

      _ ->
        error(conn, %{
          code: 400,
          result: "Missing required parameters",
          error: %{"reason" => "BadRequest", "message" => "Missing required parameters"}
        })
    end
  end

  get "/orders" do
    success(conn, [@valid_order])
  end

  get "/orders/:id" do
    success(conn, @valid_order)
  end

  post "/orders" do
    case conn.body_params do
      %{
        recipient: %{
          address1: _,
          city: _,
          country_code: _,
          state_code: _,
          zip: _
        },
        items: [_]
      } ->
        success(conn, @valid_order)

      _ ->
        error(conn, %{
          code: 400,
          result: "Missing required parameters",
          error: %{"reason" => "BadRequest", "message" => "Missing required parameters"}
        })
    end
  end

  post "/orders/estimate-costs" do
    case conn.body_params do
      %{
        recipient: %{
          address1: _,
          city: _,
          country_code: _,
          state_code: _,
          zip: _
        },
        items: [_]
      } ->
        success(
          conn,
          %{
            "costs" => %{
              "currency" => "USD",
              "subtotal" => 10,
              "discount" => 0,
              "shipping" => 5,
              "digitization" => 0,
              "additional_fee" => 0,
              "fulfillment_fee" => 0,
              "tax" => 0,
              "vat" => 0,
              "total" => 15
            },
            "retail_costs" => %{
              "currency" => "USD",
              "subtotal" => 10,
              "discount" => 0,
              "shipping" => 5,
              "tax" => 0,
              "vat" => 0,
              "total" => 15
            }
          }
        )

      _ ->
        error(conn, %{
          code: 400,
          result: "Missing required parameters",
          error: %{"reason" => "BadRequest", "message" => "Missing required parameters"}
        })
    end
  end

  delete "/orders/:id" do
    if id != nil do
      success(conn, @valid_order)
    else
      error(conn, %{
        code: 400,
        result: "Missing required parameters",
        error: %{"reason" => "BadRequest", "message" => "Missing required parameters"}
      })
    end
  end

  post "/orders/:id/confirm" do
    success(conn, @valid_order)
  end

  get "/store/products" do
    success(conn, [
      %{
        "id" => 264_672_898,
        "external_id" => "61f18e1c46a349",
        "name" => "Wallpaper Mouse pad – Odin",
        "variants" => 1,
        "synced" => 1,
        "thumbnail_url" =>
          "https://files.cdn.printful.com/files/918/918b50a99813353b2679076a4f7d1ac5_preview.png",
        "is_ignored" => false
      },
      %{
        "id" => 262_642_254,
        "external_id" => "61db4279e45988",
        "name" => "Wallpaper Tote – Odin",
        "variants" => 1,
        "synced" => 1,
        "thumbnail_url" =>
          "https://files.cdn.printful.com/files/a27/a279115d1f9df080a0f9b7401ba7ddc8_preview.png",
        "is_ignored" => false
      }
    ])
  end

  get "/store/products/:id" do
    success(conn, %{
      "sync_product" => %{
        "id" => 264_672_898,
        "external_id" => "61f18e1c46a349",
        "name" => "Wallpaper Mouse pad – Odin",
        "variants" => 1,
        "synced" => 1,
        "thumbnail_url" =>
          "https://files.cdn.printful.com/files/918/918b50a99813353b2679076a4f7d1ac5_preview.png",
        "is_ignored" => false
      },
      "sync_variants" => [
        %{
          "id" => 3_107_467_079,
          "external_id" => "61f18e1c46a417",
          "sync_product_id" => 264_672_898,
          "name" => "Wallpaper Mouse pad – Odin",
          "synced" => true,
          "variant_id" => 13_097,
          "main_category_id" => 251,
          "warehouse_product_variant_id" => nil,
          "retail_price" => "16.00",
          "sku" => "61F18E1C450D8",
          "currency" => "USD",
          "product" => %{
            "variant_id" => 13_097,
            "product_id" => 518,
            "image" => "https://files.cdn.printful.com/products/518/13097_1629286642.jpg",
            "name" => "Mouse Pad (White / 8.7\"x7.1\")"
          },
          "files" => [
            %{
              "id" => 379_883_352,
              "type" => "default",
              "hash" => "f09b80832a336b57097193095c72da91",
              "url" => nil,
              "filename" => "odin-mouse-pad.pdf",
              "mime_type" => "application/pdf",
              "size" => 17_160_461,
              "width" => 800,
              "height" => 667,
              "dpi" => 89,
              "status" => "ok",
              "created" => 1_637_791_070,
              "thumbnail_url" =>
                "https://files.cdn.printful.com/files/f09/f09b80832a336b57097193095c72da91_thumb.png",
              "preview_url" =>
                "https://files.cdn.printful.com/files/f09/f09b80832a336b57097193095c72da91_preview.png",
              "visible" => true,
              "is_temporary" => false
            },
            %{
              "id" => 398_711_765,
              "type" => "preview",
              "hash" => "918b50a99813353b2679076a4f7d1ac5",
              "url" => nil,
              "filename" => "mouse-pad-white-front-61f18e1a39bb0.png",
              "mime_type" => "image/png",
              "size" => 1_375_893,
              "width" => 1000,
              "height" => 1000,
              "dpi" => nil,
              "status" => "ok",
              "created" => 1_643_220_508,
              "thumbnail_url" =>
                "https://files.cdn.printful.com/files/918/918b50a99813353b2679076a4f7d1ac5_thumb.png",
              "preview_url" =>
                "https://files.cdn.printful.com/files/918/918b50a99813353b2679076a4f7d1ac5_preview.png",
              "visible" => false,
              "is_temporary" => false
            }
          ],
          "options" => [],
          "is_ignored" => false
        }
      ]
    })
  end

  get "/store/variants/:id" do
    success(
      conn,
      %{
        "id" => 3_107_467_079,
        "external_id" => "61f18e1c46a417",
        "sync_product_id" => 264_672_898,
        "name" => "Wallpaper Mouse pad – Odin",
        "synced" => true,
        "variant_id" => 13_097,
        "main_category_id" => 251,
        "warehouse_product_variant_id" => nil,
        "retail_price" => "16.00",
        "sku" => "61F18E1C450D8",
        "currency" => "USD",
        "product" => %{
          "variant_id" => 13_097,
          "product_id" => 518,
          "image" => "https://files.cdn.printful.com/products/518/13097_1629286642.jpg",
          "name" => "Mouse Pad (White / 8.7\"x7.1\")"
        },
        "files" => [
          %{
            "id" => 379_883_352,
            "type" => "default",
            "hash" => "f09b80832a336b57097193095c72da91",
            "url" => nil,
            "filename" => "odin-mouse-pad.pdf",
            "mime_type" => "application/pdf",
            "size" => 17_160_461,
            "width" => 800,
            "height" => 667,
            "dpi" => 89,
            "status" => "ok",
            "created" => 1_637_791_070,
            "thumbnail_url" =>
              "https://files.cdn.printful.com/files/f09/f09b80832a336b57097193095c72da91_thumb.png",
            "preview_url" =>
              "https://files.cdn.printful.com/files/f09/f09b80832a336b57097193095c72da91_preview.png",
            "visible" => true,
            "is_temporary" => false
          },
          %{
            "id" => 398_711_765,
            "type" => "preview",
            "hash" => "918b50a99813353b2679076a4f7d1ac5",
            "url" => nil,
            "filename" => "mouse-pad-white-front-61f18e1a39bb0.png",
            "mime_type" => "image/png",
            "size" => 1_375_893,
            "width" => 1000,
            "height" => 1000,
            "dpi" => nil,
            "status" => "ok",
            "created" => 1_643_220_508,
            "thumbnail_url" =>
              "https://files.cdn.printful.com/files/918/918b50a99813353b2679076a4f7d1ac5_thumb.png",
            "preview_url" =>
              "https://files.cdn.printful.com/files/918/918b50a99813353b2679076a4f7d1ac5_preview.png",
            "visible" => false,
            "is_temporary" => false
          }
        ],
        "options" => [],
        "is_ignored" => false
      }
    )
  end

  post "/tax/rates" do
    case conn.body_params do
      %{
        recipient: %{
          address1: _,
          city: _,
          country_code: _,
          state_code: _,
          zip: _
        }
      } ->
        success(conn, %{required: true, rate: 0.095, shipping_taxable: false})

      _ ->
        error(conn, %{
          code: 400,
          result: "Missing required parameters",
          error: %{"reason" => "BadRequest", "message" => "Missing required parameters"}
        })
    end
  end

  get "/products/variant/:id" do
    success(conn, %{
      "variant" => %{
        "id" => 13_097,
        "product_id" => 518,
        "display_name" => "Mouse Pad (White / 8.7\"x7.1\")",
        "image_url" => "https://files.cdn.printful.com/products/518/13097_1629286642.jpg",
        "color" => %{"color_codes" => ["#ffffff"], "color_name" => "White"},
        "size" => "8.7\"x7.1\"",
        "currency" => "GBP",
        "price" => 6.95,
        "available_as_sample" => true
      }
    })
  end

  defp success(conn, body) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Plug.Conn.send_resp(200, Jason.encode!(%{code: 200, result: body}))
  end

  defp error(conn, body) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Plug.Conn.send_resp(body.code, Jason.encode!(body))
  end
end
