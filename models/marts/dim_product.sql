with products as (

    select
        stock_code,
        description
    from {{ ref('stg_online_retail') }}
    where is_zero_value = false
    group by stock_code, description

),

-- pick the most frequent description per stock_code as canonical
ranked as (

    select
        stock_code,
        description,
        count(*) as description_frequency,
        row_number() over (
            partition by stock_code
            order by count(*) desc
        ) as rn
    from {{ ref('stg_online_retail') }}
    where is_zero_value = false
    group by stock_code, description

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['stock_code']) }} as product_key,
        stock_code,
        description
    from ranked
    where rn = 1

    union all

    select
        'UNKNOWN'   as product_key,
        null        as stock_code,
        null        as description

)

select * from final