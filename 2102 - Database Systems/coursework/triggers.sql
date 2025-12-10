CREATE TRIGGER service_immutable
BEFORE UPDATE ON service
BEGIN
  SELECT
	substr(CURRENT_DATE,3,2) || substr(CURRENT_DATE,6,2) || substr(CURRENT_DATE,9,2) AS yymmdd,
    CASE WHEN OLD.valid_until > yymmdd
	  CASE 
	    WHEN NEW.valid_until IS NOT NULL AND NEW.valid_until < OLD.valid_until
		  RAISE(ROLLBACK, "Cannot shorten validity of a service.")
		WHEN NEW.valid_from IS NOT NULL AND NEW.valid_from > OLD.valid_from
		  RAISE(ROLLBACK, "Cannot delay start validity of a service.")
		WHEN NEW.operator IS NOT NULL
		  RAISE(ROLLBACK, "Cannot change operator of a service.")
		WHEN NEW.days_run IS NOT NULL
		  RAISE(ROLLBACK, "Cannot change valid days of an entry.")
END;

CREATE TRIGGER service_stop_immutable
BEFORE UPDATE ON service_stop
WHEN (
  NEW.arrival != OLD.arrival
  OR NEW.departure != OLD.departure
  OR NEW.tiploc_code != OLD.tiploc_code
)
BEGIN
	RAISE(ROLLBACK, "Cannot modify public timetable stops.")
END;