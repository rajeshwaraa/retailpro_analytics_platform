select
    stock_code,
    description,
    quantity,
    unit_price,
    line_total,
    invoice_no,
    is_cancelled
from {{ ref('stg_online_retail') }}
where stock_code = '20713'
order by description