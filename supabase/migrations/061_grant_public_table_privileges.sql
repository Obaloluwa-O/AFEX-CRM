-- ============================================================
-- 061_grant_public_table_privileges.sql
--
-- Projects without default public-schema table grants leave PostgREST
-- roles (`authenticated`, `service_role`) unable to access tables
-- created by migrations (`42501: permission denied for table profiles`).
-- Grant baseline schema, table, and sequence privileges explicitly while
-- preserving the stricter table/column revocations from 027 and 054.
-- ============================================================

GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;

GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated, service_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;

-- Preserve 027_notifications.sql: recipients may only update read_at.
REVOKE INSERT, UPDATE, DELETE ON TABLE public.notifications FROM authenticated;
GRANT UPDATE (read_at) ON TABLE public.notifications TO authenticated;

-- Preserve 054_webhook_status_integrity.sql: internal webhook buffer only.
REVOKE ALL ON TABLE public.pending_message_statuses FROM anon, authenticated;
