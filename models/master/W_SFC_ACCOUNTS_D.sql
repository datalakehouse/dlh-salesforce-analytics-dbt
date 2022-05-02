{{ config (
  materialized= 'table',
  schema= var('target_schema'),
  tags= ["master", "daily"],
  transient=false
)
}}

SELECT
  *
FROM
  {{ref('V_SFC_ACCOUNTS_STG')}} AS C