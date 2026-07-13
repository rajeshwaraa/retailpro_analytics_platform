with customers as (

    select distinct
        customer_id
    from {{ ref('stg_online_retail') }}
    where customer_id is not null

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
        customer_id
    from customers

    union all

    select
        'UNKNOWN'   as customer_key,
        null        as customer_id

)

select * from final