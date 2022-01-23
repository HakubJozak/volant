/* Applications - full */
COPY
(SELECT "apply_forms".* FROM "apply_forms" INNER JOIN "workcamp_assignments" ON "workcamp_assignments"."apply_form_id" = "apply_forms"."id" ORDER BY CREATED_AT)
TO '/tmp/prihlasky.csv' DELIMITER ',' CSV HEADER;

/* Workcamps */
"SELECT \"workcamps\".* FROM \"workcamps\""


SELECT "workcamps".* FROM "workcamps"


/* Volunteer */
COPY
(SELECT "apply_forms".* FROM "apply_forms" INNER JOIN "workcamp_assignments" ON "workcamp_assignments"."apply_form_id" = "apply_forms"."id")
TO '/tmp/prihlasky.csv' DELIMITER ',' CSV HEADER;
