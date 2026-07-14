with sales as (

    select * from {{ ref('stg_online_retail') }}

),

customers as (

    select * from {{ ref('dim_customer') }}

),

products as (

    select * from {{ ref('dim_product') }}

),

dates as (

    select * from {{ ref('dim_date') }}

),

final as (

    select

        -- surrogate keys (foreign keys to dimensions)
        coalesce(c.customer_key, 'UNKNOWN')    as customer_key,
        coalesce(p.product_key, 'UNKNOWN')     as product_key,
        d.date_key,

        -- degenerate dimension (invoice-level detail with no separate dim table)
        s.invoice_no,
        s.country,

        -- facts
        s.quantity,
        s.unit_price,
        s.line_total,

        case
            when s.is_cancelled = false and s.is_zero_value = false
                then s.line_total
            else 0
        end                                     as net_revenue,

        -- flags carried through for transparency / flexible downstream analysis
        s.is_cancelled,
        s.is_missing_customer,
        s.is_zero_value

    from sales s
    left join customers c
        on s.customer_id = c.customer_id
    left join products p
        on s.stock_code = p.stock_code
    left join dates d
        on cast(s.invoice_date as date) = d.date_day

)

select * from final