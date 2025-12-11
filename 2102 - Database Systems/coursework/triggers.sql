-- Both commit if not rolled back.
CREATE TRIGGER service_update_immutable
BEFORE UPDATE ON service
BEGIN
    -- Only enforce immutability for services still valid in the future
    SELECT CASE
        WHEN OLD.valid_until > strftime('%y%m%d','now')
             AND NEW.valid_until IS NOT NULL
             AND NEW.valid_until < OLD.valid_until
        THEN RAISE(ROLLBACK, 'Cannot shorten validity of a service.')
    END;

    SELECT CASE
        WHEN OLD.valid_until > strftime('%y%m%d','now')
             AND NEW.valid_from IS NOT NULL
             AND NEW.valid_from > OLD.valid_from
        THEN RAISE(ROLLBACK, 'Cannot delay start validity of a service.')
    END;

    SELECT CASE
        WHEN OLD.valid_until > strftime('%y%m%d','now')
             AND NEW.operator IS NOT NULL
        THEN RAISE(ROLLBACK, 'Cannot change operator of a service.')
    END;

    SELECT CASE
        WHEN OLD.valid_until > strftime('%y%m%d','now')
             AND NEW.days_run IS NOT NULL
        THEN RAISE(ROLLBACK, 'Cannot change valid days of an entry.')
    END;
END;

CREATE TRIGGER service_delete_immutable
BEFORE DELETE ON service
BEGIN
	-- Cannot delete services currently valid
	SELECT CASE
		WHEN OLD.valid_until > strftime('%y%m%d','now')
		AND OLD.valid_from < strftime('%y%m%d','now')
		THEN RAISE(ROLLBACK, 'Cannot delete a service that is still valid in the future.')
	END;
END;