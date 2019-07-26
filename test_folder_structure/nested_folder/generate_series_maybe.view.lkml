#      SELECT
#           date_trunc('day', '2014-01-01'+ SEQUENCE.day) as day
#       FROM GENERATE_SERIES (0,4000) AS SEQUENCE (day)
#       where date_trunc('day', '2014-01-01'::date+ SEQUENCE.day )::timestamp <= current_date
#       GROUP BY SEQUENCE.day
