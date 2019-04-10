# lbl-cpp-clickhouse
Public things related to LBL CPP's Clickhouse instance

schemas - These are schemas that can be imported to Clickhouse for various types of logs
example import: clickhouse-client --query="$(cat zeek_conn_log_full_nonoptimized.schema | tr -d "\n")"

ingest_scripts - These are scripts that can be used to re-format data to ingest them into schemas

sample_data - Sample data that should be importable with the schema and ingest_scripts provided

example_queries - Example queries that should work against the sample_data when imported with these schemas

IP addresses in these examples must follow RFC 5737 §3 Documentation Address Blocks.

MAC addresses in these examples must follow RFC 7042 §2.1.2 EUI-48 Documentation Values.

Domain names in these examples must follow RFC 2606 §3 Reserved Example Second Level Domain Names.
