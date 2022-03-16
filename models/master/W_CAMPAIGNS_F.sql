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
  {{ref('V_CAMPAIGNS_STG')}} AS C