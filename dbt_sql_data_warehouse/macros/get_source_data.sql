{% macro get_source_data(source_name, table_name) %}
    {{ source(source_name, table_name) }}
{% endmacro %}
