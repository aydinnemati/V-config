# creating tables for logs
# TIP
```bash
 CREATE TABLE IF NOT EXISTS test_table (
    event_date  Date,
    event_type  Int32,
    article_id  Int32,
    title       String
) ENGINE = Log
```
## cisco_3750_%LINK-3-UPDOWN
```bash
 CREATE TABLE IF NOT EXISTS test_table01 (
    description  String,
    host  IPv4,
    interface  String,
    message   String,
    mnemonic  String,
    pri_facility Int32,
    pri_facility_detail  String,
    pri_severity  Int32,
    pri_severity_detail  String,
    pri_severity_state  String,
    record_id  Int32,
    source_ip  IPv4,
    source_type String,
    timestamp  
) ENGINE = MergeTree()
ORDER BY host # must change on what we're looking for in logs
```