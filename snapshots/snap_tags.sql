{% snapshot snap_tags %}
{{ config(
    target_schema='snapshots',
        strategy='timestamp',
        unique_key=['user_id', 'movie_id', 'tag'],
        updated_at='tag_timestamp',
        invalidation_hard_deletes=True,
        check_cols=['tag', 'movie_id']
    ) 
}}

SELECT {{dbt.utils.generate_surrogate_key(['user_id', 'movie_id', 'tag'])}} AS snapshot_id,
    user_id,
    movie_id,
    tag,
    CAST(tag_timestamp AS TIMESTAMP_NTZ) AS tag_timestamp
FROM {{ ref('src_tags') }}
LIMIT 100
{% endsnapshot %}