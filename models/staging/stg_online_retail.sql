with source as (

    select * from {{ source('raw', 'online_retail') }}

),

renamed as (

    select
        "Invoice"                          as invoice_no,
        "StockCode"                        as stock_code,
        trim("Description")                as description,
        "Quantity"                         as quantity,
        "InvoiceDate"                      as invoice_date,
        "Price"                            as unit_price,
        "Customer ID"                      as customer_id,
        "Country"                          as country,

        -- derived flags
        case
            when "Invoice" like 'C%' then true
            else false
        end                                 as is_cancelled,

        case
            when "Customer ID" is null then true
            else false
        end                                 as is_missing_customer,

        case
            when "Price" <= 0 then true
            else false
        end                                 as is_zero_value,
        
        -- cleaned business metric
        round("Quantity" * "Price", 2)      as line_total

    from source

)

select * from renamed