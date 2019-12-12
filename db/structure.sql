--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5 (Ubuntu 11.5-0ubuntu0.19.04.1)
-- Dumped by pg_dump version 11.5 (Ubuntu 11.5-0ubuntu0.19.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: workcamp_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workcamp_assignments (
    id integer NOT NULL,
    apply_form_id integer,
    workcamp_id integer,
    "position" integer NOT NULL,
    accepted timestamp without time zone,
    rejected timestamp without time zone,
    asked timestamp without time zone,
    infosheeted timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    confirmed timestamp without time zone
);


--
-- Name: accepted_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.accepted_assignments AS
 SELECT a.apply_form_id,
    min(a."position") AS "order"
   FROM public.workcamp_assignments a
  WHERE ((a.accepted IS NOT NULL) AND (a.rejected IS NULL))
  GROUP BY a.apply_form_id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    organization_id integer NOT NULL,
    season_end date DEFAULT '2015-03-15'::date NOT NULL,
    organization_response_limit integer DEFAULT 4 NOT NULL,
    infosheet_waiting_limit integer DEFAULT 30 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    code character varying(2) NOT NULL,
    name_cz character varying(255),
    name_en character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    triple_code character varying(3),
    region character varying(255) DEFAULT '1'::character varying NOT NULL,
    country_zone_id integer,
    free_workcamps_count integer DEFAULT 0,
    free_ltvs_count integer DEFAULT 0
);


--
-- Name: workcamps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workcamps (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    country_id integer NOT NULL,
    organization_id integer NOT NULL,
    language character varying(255),
    begin date,
    "end" date,
    capacity integer,
    places integer NOT NULL,
    places_for_males integer NOT NULL,
    places_for_females integer NOT NULL,
    minimal_age integer DEFAULT 18,
    maximal_age integer DEFAULT 99,
    area text,
    accommodation text,
    workdesc text,
    notes text,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    extra_fee numeric(10,2),
    extra_fee_currency character varying(255),
    region character varying(65536),
    capacity_natives integer,
    capacity_teenagers integer,
    capacity_males integer,
    capacity_females integer,
    airport character varying(255),
    train character varying(4096),
    publish_mode character varying(255) DEFAULT 'ALWAYS'::character varying NOT NULL,
    accepted_places integer DEFAULT 0 NOT NULL,
    accepted_places_males integer DEFAULT 0 NOT NULL,
    accepted_places_females integer DEFAULT 0 NOT NULL,
    asked_for_places integer DEFAULT 0 NOT NULL,
    asked_for_places_males integer DEFAULT 0 NOT NULL,
    asked_for_places_females integer DEFAULT 0 NOT NULL,
    type character varying(255) DEFAULT 'Outgoing::Workcamp'::character varying NOT NULL,
    longitude numeric(11,7),
    latitude numeric(11,7),
    state character varying(255),
    requirements text,
    free_places integer DEFAULT 0 NOT NULL,
    free_places_for_males integer DEFAULT 0 NOT NULL,
    free_places_for_females integer DEFAULT 0 NOT NULL,
    project_id character varying(255),
    duration integer,
    free_capacity_males integer DEFAULT 0 NOT NULL,
    free_capacity_females integer DEFAULT 0 NOT NULL,
    free_capacity integer DEFAULT 0 NOT NULL,
    partner_organization character varying(4096),
    project_summary character varying(4096),
    variable_dates boolean,
    price numeric(10,2)
);


--
-- Name: active_countries_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.active_countries_view AS
 SELECT DISTINCT c.id,
    c.code,
    c.name_cz,
    c.name_en,
    c.created_at,
    c.updated_at,
    c.triple_code
   FROM (public.countries c
     JOIN public.workcamps w ON ((c.id = w.country_id)))
  ORDER BY c.id, c.code, c.name_cz, c.name_en, c.created_at, c.updated_at, c.triple_code;


--
-- Name: apply_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.apply_forms (
    id integer NOT NULL,
    volunteer_id integer,
    fee numeric(10,2) DEFAULT 2200 NOT NULL,
    cancelled timestamp without time zone,
    general_remarks text,
    motivation text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    current_workcamp_id_cached integer,
    current_assignment_id_cached integer,
    type character varying(255) DEFAULT 'Outgoing::ApplyForm'::character varying NOT NULL,
    confirmed timestamp without time zone,
    organization_id integer,
    country_id integer,
    firstname character varying(255),
    lastname character varying(255),
    gender character varying(255),
    email character varying(255),
    phone character varying(255),
    birthnumber character varying(255),
    occupation character varying(255),
    account character varying(255),
    emergency_name character varying(255),
    emergency_day character varying(255),
    emergency_email character varying(255),
    speak_well character varying(255),
    speak_some character varying(255),
    fax character varying(255),
    street character varying(255),
    city character varying(255),
    zipcode character varying(255),
    contact_street character varying(255),
    contact_city character varying(255),
    contact_zipcode character varying(255),
    birthplace character varying(255),
    nationality character varying(255),
    special_needs text,
    past_experience text,
    comments text,
    note text,
    birthdate date,
    passport_number character varying(255),
    passport_issued_at date,
    passport_expires_at date
);


--
-- Name: apply_forms_cached_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.apply_forms_cached_view AS
 SELECT application.id,
    application.volunteer_id,
    application.fee,
    application.cancelled,
    application.general_remarks,
    application.motivation,
    application.created_at,
    application.updated_at,
    application.current_workcamp_id_cached,
    application.current_assignment_id_cached,
    workcamp_assignments.accepted,
    workcamp_assignments.rejected,
    workcamp_assignments.asked,
    workcamp_assignments.infosheeted
   FROM (public.apply_forms application
     LEFT JOIN public.workcamp_assignments ON ((application.current_assignment_id_cached = workcamp_assignments.id)));


--
-- Name: apply_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.apply_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: apply_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.apply_forms_id_seq OWNED BY public.apply_forms.id;


--
-- Name: pending_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.pending_assignments AS
 SELECT a.apply_form_id,
    min(a."position") AS "order"
   FROM public.workcamp_assignments a
  WHERE (((a.accepted IS NULL) AND (a.asked IS NULL) AND (a.rejected IS NULL)) OR ((a.asked IS NOT NULL) AND (a.rejected IS NULL)))
  GROUP BY a.apply_form_id;


--
-- Name: rejected_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.rejected_assignments AS
 SELECT a.apply_form_id,
    a."position" AS "order"
   FROM (public.workcamp_assignments a
     JOIN ( SELECT c.apply_form_id,
            max(c."position") AS maximum
           FROM public.workcamp_assignments c
          GROUP BY c.apply_form_id) b USING (apply_form_id))
  WHERE ((a."position" = b.maximum) AND (a.rejected IS NOT NULL));


--
-- Name: apply_forms_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.apply_forms_view AS
 SELECT application.id,
    application.volunteer_id,
    application.fee,
    application.cancelled,
    application.general_remarks,
    application.motivation,
    application.created_at,
    application.updated_at,
    application.current_workcamp_id_cached,
    application.current_assignment_id_cached,
    workcamp.workcamp_id AS current_workcamp_id,
    workcamp.current_assignment_id,
    workcamp.accepted,
    workcamp.rejected,
    workcamp.asked,
    workcamp.infosheeted
   FROM (public.apply_forms application
     LEFT JOIN ( SELECT assignment.id AS current_assignment_id,
            assignment.apply_form_id,
            assignment.workcamp_id,
            assignment.accepted,
            assignment.rejected,
            assignment.asked,
            assignment.infosheeted
           FROM (public.workcamp_assignments assignment
             JOIN ( SELECT assignments.apply_form_id,
                    min(assignments."order") AS "order"
                   FROM ( SELECT pending_assignments.apply_form_id,
                            pending_assignments."order"
                           FROM public.pending_assignments
                        UNION
                         SELECT accepted_assignments.apply_form_id,
                            accepted_assignments."order"
                           FROM public.accepted_assignments
                        UNION
                         SELECT rejected_assignments.apply_form_id,
                            rejected_assignments."order"
                           FROM public.rejected_assignments) assignments
                  GROUP BY assignments.apply_form_id) latest ON (((assignment.apply_form_id = latest.apply_form_id) AND (assignment."position" = latest."order"))))) workcamp ON ((workcamp.apply_form_id = application.id)));


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id integer NOT NULL,
    file character varying(255),
    type character varying(255) DEFAULT 'Attachment'::character varying NOT NULL,
    message_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    workcamp_id integer,
    apply_form_id integer
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    workcamp_id integer,
    organization_id integer,
    country_id integer,
    gender character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    expires_at date
);


--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    title character varying(50) DEFAULT ''::character varying,
    comment text DEFAULT ''::text,
    created_at timestamp without time zone NOT NULL,
    commentable_id integer DEFAULT 0 NOT NULL,
    commentable_type character varying(15) DEFAULT ''::character varying NOT NULL,
    user_id integer DEFAULT 0 NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: country_zones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.country_zones (
    id integer NOT NULL,
    name_en character varying(255),
    name_cz character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    continent character varying(255)
);


--
-- Name: country_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.country_zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: country_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.country_zones_id_seq OWNED BY public.country_zones.id;


--
-- Name: devise_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devise_users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    first_name character varying(255),
    last_name character varying(255),
    account_id integer
);


--
-- Name: devise_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devise_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devise_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devise_users_id_seq OWNED BY public.devise_users.id;


--
-- Name: email_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_contacts (
    id integer NOT NULL,
    active boolean DEFAULT false,
    address character varying(255) NOT NULL,
    name character varying(255),
    notes character varying(255),
    organization_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    kind character varying(255)
);


--
-- Name: email_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_contacts_id_seq OWNED BY public.email_contacts.id;


--
-- Name: email_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_templates (
    id integer NOT NULL,
    action character varying(255),
    description character varying(255),
    subject character varying(255),
    wrap_into_template character varying(255) DEFAULT 'mail'::character varying,
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: email_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_templates_id_seq OWNED BY public.email_templates.id;


--
-- Name: hostings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hostings (
    id integer NOT NULL,
    workcamp_id integer,
    partner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: hostings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hostings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hostings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hostings_id_seq OWNED BY public.hostings.id;


--
-- Name: import_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_changes (
    id integer NOT NULL,
    field character varying(255) NOT NULL,
    value text NOT NULL,
    diff text,
    workcamp_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: import_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.import_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.import_changes_id_seq OWNED BY public.import_changes.id;


--
-- Name: infosheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.infosheets (
    id integer NOT NULL,
    workcamp_id integer,
    document_file_name character varying(255),
    document_content_type character varying(255),
    document_file_size integer,
    document_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    notes text
);


--
-- Name: infosheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.infosheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: infosheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.infosheets_id_seq OWNED BY public.infosheets.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.languages (
    id integer NOT NULL,
    code character varying(2),
    triple_code character varying(3) NOT NULL,
    name_cz character varying(255),
    name_en character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- Name: leaderships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leaderships (
    id integer NOT NULL,
    person_id integer,
    workcamp_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: leaderships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leaderships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leaderships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leaderships_id_seq OWNED BY public.leaderships.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    "to" character varying(65536),
    "from" character varying(65536),
    subject character varying(255),
    body text,
    action character varying(255),
    user_id integer NOT NULL,
    email_template_id integer,
    workcamp_id integer,
    sent_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    apply_form_id integer,
    html_body text,
    cc character varying(65536),
    bcc character varying(65536)
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: networks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.networks (
    id integer NOT NULL,
    name character varying(255),
    web character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: networks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.networks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: networks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.networks_id_seq OWNED BY public.networks.id;


--
-- Name: new_email_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_email_templates (
    id integer NOT NULL,
    action character varying(255),
    title character varying(255),
    "to" character varying(255),
    cc character varying(255),
    bcc character varying(255) DEFAULT '{{user.email}}'::character varying,
    "from" character varying(255) DEFAULT '{{user.email}}'::character varying,
    subject character varying(255),
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: new_email_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_email_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_email_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_email_templates_id_seq OWNED BY public.new_email_templates.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    address character varying(255),
    contact_person character varying(255),
    phone character varying(255),
    mobile character varying(255),
    fax character varying(255),
    website character varying(2048),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: partners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.partners (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    contact_person character varying(255),
    phone character varying(255),
    email character varying(255),
    address character varying(2048),
    website character varying(2048),
    negotiations_notes character varying(5096),
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.partners_id_seq OWNED BY public.partners.id;


--
-- Name: partnerships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.partnerships (
    id integer NOT NULL,
    description character varying(255),
    network_id integer,
    organization_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: partnerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.partnerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: partnerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.partnerships_id_seq OWNED BY public.partnerships.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    apply_form_id integer,
    old_schema_key integer,
    amount numeric(10,2) NOT NULL,
    received date NOT NULL,
    description character varying(1024),
    account character varying(255),
    mean character varying(255) NOT NULL,
    returned_date date,
    returned_amount numeric(10,2),
    return_reason character varying(1024),
    bank_code character varying(4),
    spec_symbol character varying(255),
    var_symbol character varying(255),
    const_symbol character varying(255),
    name character varying(255)
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id integer NOT NULL,
    firstname character varying(255) NOT NULL,
    lastname character varying(255) NOT NULL,
    gender character varying(255) NOT NULL,
    old_schema_key integer,
    email character varying(255),
    phone character varying(255),
    birthdate date,
    birthnumber character varying(255),
    nationality character varying(255),
    occupation character varying(255),
    account character varying(255),
    emergency_name character varying(255),
    emergency_day character varying(255),
    emergency_email character varying(255),
    speak_well character varying(255),
    speak_some character varying(255),
    special_needs text,
    past_experience text,
    comments text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    fax character varying(255),
    street character varying(255),
    city character varying(255),
    zipcode character varying(255),
    contact_street character varying(255),
    contact_city character varying(255),
    contact_zipcode character varying(255),
    birthplace character varying(255),
    type character varying(255) DEFAULT 'Volunteer'::character varying NOT NULL,
    workcamp_id integer,
    country_id integer,
    note text,
    organization_id integer,
    passport_number character varying(255),
    passport_issued_at date,
    passport_expires_at date
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: starrings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.starrings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    favorite_id integer NOT NULL,
    favorite_type character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: starrings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.starrings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: starrings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.starrings_id_seq OWNED BY public.starrings.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    created_at timestamp without time zone,
    context character varying(128) DEFAULT 'tags'::character varying,
    tagger_id integer,
    tagger_type character varying(255)
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    color character varying(7) DEFAULT '#FF0000'::character varying NOT NULL,
    text_color character varying(7) DEFAULT '#FFFFFF'::character varying NOT NULL,
    taggings_count integer DEFAULT 0,
    symbol character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    crypted_password character varying(40),
    salt character varying(40),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    remember_token character varying(255),
    remember_token_expires_at timestamp without time zone,
    firstname character varying(255),
    lastname character varying(255),
    locale character varying(3) DEFAULT 'en'::character varying NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: volunteers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.volunteers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: volunteers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.volunteers_id_seq OWNED BY public.people.id;


--
-- Name: workcamp_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workcamp_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workcamp_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workcamp_assignments_id_seq OWNED BY public.workcamp_assignments.id;


--
-- Name: workcamp_intentions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workcamp_intentions (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    description_cz character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description_en character varying(255)
);


--
-- Name: workcamp_intentions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workcamp_intentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workcamp_intentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workcamp_intentions_id_seq OWNED BY public.workcamp_intentions.id;


--
-- Name: workcamp_intentions_workcamps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workcamp_intentions_workcamps (
    workcamp_id integer,
    workcamp_intention_id integer
);


--
-- Name: workcamps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workcamps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workcamps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workcamps_id_seq OWNED BY public.workcamps.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: apply_forms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apply_forms ALTER COLUMN id SET DEFAULT nextval('public.apply_forms_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: country_zones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_zones ALTER COLUMN id SET DEFAULT nextval('public.country_zones_id_seq'::regclass);


--
-- Name: devise_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devise_users ALTER COLUMN id SET DEFAULT nextval('public.devise_users_id_seq'::regclass);


--
-- Name: email_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_contacts ALTER COLUMN id SET DEFAULT nextval('public.email_contacts_id_seq'::regclass);


--
-- Name: email_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_templates ALTER COLUMN id SET DEFAULT nextval('public.email_templates_id_seq'::regclass);


--
-- Name: hostings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostings ALTER COLUMN id SET DEFAULT nextval('public.hostings_id_seq'::regclass);


--
-- Name: import_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_changes ALTER COLUMN id SET DEFAULT nextval('public.import_changes_id_seq'::regclass);


--
-- Name: infosheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.infosheets ALTER COLUMN id SET DEFAULT nextval('public.infosheets_id_seq'::regclass);


--
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- Name: leaderships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaderships ALTER COLUMN id SET DEFAULT nextval('public.leaderships_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: networks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.networks ALTER COLUMN id SET DEFAULT nextval('public.networks_id_seq'::regclass);


--
-- Name: new_email_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_email_templates ALTER COLUMN id SET DEFAULT nextval('public.new_email_templates_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: partners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partners ALTER COLUMN id SET DEFAULT nextval('public.partners_id_seq'::regclass);


--
-- Name: partnerships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partnerships ALTER COLUMN id SET DEFAULT nextval('public.partnerships_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.volunteers_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: starrings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.starrings ALTER COLUMN id SET DEFAULT nextval('public.starrings_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workcamp_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamp_assignments ALTER COLUMN id SET DEFAULT nextval('public.workcamp_assignments_id_seq'::regclass);


--
-- Name: workcamp_intentions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamp_intentions ALTER COLUMN id SET DEFAULT nextval('public.workcamp_intentions_id_seq'::regclass);


--
-- Name: workcamps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamps ALTER COLUMN id SET DEFAULT nextval('public.workcamps_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: apply_forms apply_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apply_forms
    ADD CONSTRAINT apply_forms_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: country_zones country_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_zones
    ADD CONSTRAINT country_zones_pkey PRIMARY KEY (id);


--
-- Name: devise_users devise_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devise_users
    ADD CONSTRAINT devise_users_pkey PRIMARY KEY (id);


--
-- Name: email_contacts email_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_contacts
    ADD CONSTRAINT email_contacts_pkey PRIMARY KEY (id);


--
-- Name: email_templates email_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_templates
    ADD CONSTRAINT email_templates_pkey PRIMARY KEY (id);


--
-- Name: hostings hostings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostings
    ADD CONSTRAINT hostings_pkey PRIMARY KEY (id);


--
-- Name: import_changes import_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_changes
    ADD CONSTRAINT import_changes_pkey PRIMARY KEY (id);


--
-- Name: infosheets infosheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.infosheets
    ADD CONSTRAINT infosheets_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: leaderships leaderships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaderships
    ADD CONSTRAINT leaderships_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: networks networks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.networks
    ADD CONSTRAINT networks_pkey PRIMARY KEY (id);


--
-- Name: new_email_templates new_email_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_email_templates
    ADD CONSTRAINT new_email_templates_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: partners partners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- Name: partnerships partnerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partnerships
    ADD CONSTRAINT partnerships_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: starrings starrings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.starrings
    ADD CONSTRAINT starrings_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: people volunteers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT volunteers_pkey PRIMARY KEY (id);


--
-- Name: workcamp_assignments workcamp_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamp_assignments
    ADD CONSTRAINT workcamp_assignments_pkey PRIMARY KEY (id);


--
-- Name: workcamp_intentions workcamp_intentions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamp_intentions
    ADD CONSTRAINT workcamp_intentions_pkey PRIMARY KEY (id);


--
-- Name: workcamps workcamps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamps
    ADD CONSTRAINT workcamps_pkey PRIMARY KEY (id);


--
-- Name: fk_comments_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_comments_user ON public.comments USING btree (user_id);


--
-- Name: index_apply_forms_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_apply_forms_on_id ON public.apply_forms USING btree (id);


--
-- Name: index_devise_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_devise_users_on_email ON public.devise_users USING btree (email);


--
-- Name: index_devise_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_devise_users_on_reset_password_token ON public.devise_users USING btree (reset_password_token);


--
-- Name: index_infosheets_on_workcamp_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_infosheets_on_workcamp_id ON public.infosheets USING btree (workcamp_id);


--
-- Name: index_organizations_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_id ON public.organizations USING btree (id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_session_id ON public.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON public.sessions USING btree (updated_at);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type ON public.taggings USING btree (taggable_id, taggable_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_volunteers_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_volunteers_on_id ON public.people USING btree (id);


--
-- Name: index_workcamp_assignments_on_accepted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamp_assignments_on_accepted ON public.workcamp_assignments USING btree (accepted);


--
-- Name: index_workcamp_assignments_on_apply_form_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamp_assignments_on_apply_form_id ON public.workcamp_assignments USING btree (apply_form_id);


--
-- Name: index_workcamp_assignments_on_asked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamp_assignments_on_asked ON public.workcamp_assignments USING btree (asked);


--
-- Name: index_workcamp_assignments_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamp_assignments_on_id ON public.workcamp_assignments USING btree (id);


--
-- Name: index_workcamp_assignments_on_infosheeted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamp_assignments_on_infosheeted ON public.workcamp_assignments USING btree (infosheeted);


--
-- Name: index_workcamp_assignments_on_rejected; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamp_assignments_on_rejected ON public.workcamp_assignments USING btree (rejected);


--
-- Name: index_workcamp_assignments_on_workcamp_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamp_assignments_on_workcamp_id ON public.workcamp_assignments USING btree (workcamp_id);


--
-- Name: index_workcamps_on_begin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamps_on_begin ON public.workcamps USING btree (begin);


--
-- Name: index_workcamps_on_country_id_and_begin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamps_on_country_id_and_begin ON public.workcamps USING btree (country_id, begin);


--
-- Name: index_workcamps_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamps_on_id ON public.workcamps USING btree (id);


--
-- Name: index_workcamps_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamps_on_state ON public.workcamps USING btree (state);


--
-- Name: index_workcamps_on_state_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamps_on_state_and_type ON public.workcamps USING btree (state, type);


--
-- Name: index_workcamps_on_state_and_type_and_begin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamps_on_state_and_type_and_begin ON public.workcamps USING btree (state, type, begin);


--
-- Name: index_workcamps_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workcamps_on_type ON public.workcamps USING btree (type);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: apply_forms_cached_view apply_forms_cached_view_delete; Type: RULE; Schema: public; Owner: -
--

CREATE RULE apply_forms_cached_view_delete AS
    ON DELETE TO public.apply_forms_cached_view DO INSTEAD  DELETE FROM public.apply_forms
  WHERE (apply_forms.id = old.id);


--
-- Name: apply_forms_cached_view apply_forms_cached_view_insert; Type: RULE; Schema: public; Owner: -
--

CREATE RULE apply_forms_cached_view_insert AS
    ON INSERT TO public.apply_forms_cached_view DO INSTEAD  INSERT INTO public.apply_forms (volunteer_id, fee, cancelled, general_remarks, motivation, created_at, updated_at, current_workcamp_id_cached, current_assignment_id_cached)
  VALUES (new.volunteer_id, new.fee, new.cancelled, new.general_remarks, new.motivation, new.created_at, new.updated_at, new.current_workcamp_id_cached, new.current_assignment_id_cached)
  RETURNING apply_forms.id,
    apply_forms.volunteer_id,
    apply_forms.fee,
    apply_forms.cancelled,
    apply_forms.general_remarks,
    apply_forms.motivation,
    apply_forms.created_at,
    apply_forms.updated_at,
    apply_forms.current_workcamp_id_cached,
    apply_forms.current_assignment_id_cached,
    NULL::timestamp without time zone AS "apply_forms.accepted",
    NULL::timestamp without time zone AS "apply_forms.rejected",
    NULL::timestamp without time zone AS "apply_forms.asked",
    NULL::timestamp without time zone AS "apply_forms.infosheeted";


--
-- Name: apply_forms_cached_view apply_forms_cached_view_update; Type: RULE; Schema: public; Owner: -
--

CREATE RULE apply_forms_cached_view_update AS
    ON UPDATE TO public.apply_forms_cached_view DO INSTEAD  UPDATE public.apply_forms SET volunteer_id = new.volunteer_id, fee = new.fee, cancelled = new.cancelled, general_remarks = new.general_remarks, motivation = new.motivation, created_at = new.created_at, updated_at = new.updated_at, current_workcamp_id_cached = new.current_workcamp_id_cached, current_assignment_id_cached = new.current_assignment_id_cached
  WHERE (apply_forms.id = old.id);


--
-- Name: apply_forms_view apply_forms_view_delete; Type: RULE; Schema: public; Owner: -
--

CREATE RULE apply_forms_view_delete AS
    ON DELETE TO public.apply_forms_view DO INSTEAD  DELETE FROM public.apply_forms
  WHERE (apply_forms.id = old.id);


--
-- Name: apply_forms_view apply_forms_view_insert; Type: RULE; Schema: public; Owner: -
--

CREATE RULE apply_forms_view_insert AS
    ON INSERT TO public.apply_forms_view DO INSTEAD  INSERT INTO public.apply_forms (volunteer_id, fee, cancelled, general_remarks, motivation, created_at, updated_at)
  VALUES (new.volunteer_id, new.fee, new.cancelled, new.general_remarks, new.motivation, new.created_at, new.updated_at)
  RETURNING apply_forms.id,
    apply_forms.volunteer_id,
    apply_forms.fee,
    apply_forms.cancelled,
    apply_forms.general_remarks,
    apply_forms.motivation,
    apply_forms.created_at,
    apply_forms.updated_at,
    apply_forms.current_workcamp_id_cached,
    apply_forms.current_assignment_id_cached,
    0,
    0,
    NULL::timestamp without time zone AS "apply_forms.accepted",
    NULL::timestamp without time zone AS "apply_forms.rejected",
    NULL::timestamp without time zone AS "apply_forms.asked",
    NULL::timestamp without time zone AS "apply_forms.infosheeted";


--
-- Name: apply_forms_view apply_forms_view_update; Type: RULE; Schema: public; Owner: -
--

CREATE RULE apply_forms_view_update AS
    ON UPDATE TO public.apply_forms_view DO INSTEAD  UPDATE public.apply_forms SET volunteer_id = new.volunteer_id, fee = new.fee, cancelled = new.cancelled, general_remarks = new.general_remarks, motivation = new.motivation, created_at = new.created_at, updated_at = new.updated_at
  WHERE (apply_forms.id = old.id);


--
-- Name: apply_forms apply_forms_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apply_forms
    ADD CONSTRAINT apply_forms_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.people(id);


--
-- Name: bookings bookings_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: bookings bookings_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: bookings bookings_workcamp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_workcamp_id_fkey FOREIGN KEY (workcamp_id) REFERENCES public.workcamps(id);


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: email_contacts email_contacts_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_contacts
    ADD CONSTRAINT email_contacts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: hostings hostings_partner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostings
    ADD CONSTRAINT hostings_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES public.partners(id);


--
-- Name: hostings hostings_workcamp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostings
    ADD CONSTRAINT hostings_workcamp_id_fkey FOREIGN KEY (workcamp_id) REFERENCES public.workcamps(id);


--
-- Name: import_changes import_changes_workcamp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_changes
    ADD CONSTRAINT import_changes_workcamp_id_fkey FOREIGN KEY (workcamp_id) REFERENCES public.workcamps(id);


--
-- Name: infosheets infosheets_workcamp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.infosheets
    ADD CONSTRAINT infosheets_workcamp_id_fkey FOREIGN KEY (workcamp_id) REFERENCES public.workcamps(id);


--
-- Name: leaderships leaderships_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaderships
    ADD CONSTRAINT leaderships_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: leaderships leaderships_workcamp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaderships
    ADD CONSTRAINT leaderships_workcamp_id_fkey FOREIGN KEY (workcamp_id) REFERENCES public.workcamps(id);


--
-- Name: organizations organizations_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: partnerships partnerships_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partnerships
    ADD CONSTRAINT partnerships_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id);


--
-- Name: partnerships partnerships_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partnerships
    ADD CONSTRAINT partnerships_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: payments payments_apply_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_apply_form_id_fkey FOREIGN KEY (apply_form_id) REFERENCES public.apply_forms(id);


--
-- Name: people people_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: people people_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: people people_workcamp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_workcamp_id_fkey FOREIGN KEY (workcamp_id) REFERENCES public.workcamps(id);


--
-- Name: taggings taggings_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: workcamp_assignments workcamp_assignments_apply_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamp_assignments
    ADD CONSTRAINT workcamp_assignments_apply_form_id_fkey FOREIGN KEY (apply_form_id) REFERENCES public.apply_forms(id);


--
-- Name: workcamp_assignments workcamp_assignments_workcamp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamp_assignments
    ADD CONSTRAINT workcamp_assignments_workcamp_id_fkey FOREIGN KEY (workcamp_id) REFERENCES public.workcamps(id);


--
-- Name: workcamp_intentions_workcamps workcamp_intentions_workcamps_workcamp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamp_intentions_workcamps
    ADD CONSTRAINT workcamp_intentions_workcamps_workcamp_id_fkey FOREIGN KEY (workcamp_id) REFERENCES public.workcamps(id);


--
-- Name: workcamp_intentions_workcamps workcamp_intentions_workcamps_workcamp_intention_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamp_intentions_workcamps
    ADD CONSTRAINT workcamp_intentions_workcamps_workcamp_intention_id_fkey FOREIGN KEY (workcamp_intention_id) REFERENCES public.workcamp_intentions(id);


--
-- Name: workcamps workcamps_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamps
    ADD CONSTRAINT workcamps_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: workcamps workcamps_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workcamps
    ADD CONSTRAINT workcamps_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20071205150145');

INSERT INTO schema_migrations (version) VALUES ('20071205150230');

INSERT INTO schema_migrations (version) VALUES ('20071208141431');

INSERT INTO schema_migrations (version) VALUES ('20081202192410');

INSERT INTO schema_migrations (version) VALUES ('20081205143817');

INSERT INTO schema_migrations (version) VALUES ('20081205150124');

INSERT INTO schema_migrations (version) VALUES ('20081205150155');

INSERT INTO schema_migrations (version) VALUES ('20081211185010');

INSERT INTO schema_migrations (version) VALUES ('20081225172253');

INSERT INTO schema_migrations (version) VALUES ('20081226131334');

INSERT INTO schema_migrations (version) VALUES ('20081226210600');

INSERT INTO schema_migrations (version) VALUES ('20081226210601');

INSERT INTO schema_migrations (version) VALUES ('20090105105415');

INSERT INTO schema_migrations (version) VALUES ('20090105105533');

INSERT INTO schema_migrations (version) VALUES ('20090105105733');

INSERT INTO schema_migrations (version) VALUES ('20090116152151');

INSERT INTO schema_migrations (version) VALUES ('20090119155213');

INSERT INTO schema_migrations (version) VALUES ('20090120111217');

INSERT INTO schema_migrations (version) VALUES ('20090202111348');

INSERT INTO schema_migrations (version) VALUES ('20090214125123');

INSERT INTO schema_migrations (version) VALUES ('20090214125124');

INSERT INTO schema_migrations (version) VALUES ('20090215223615');

INSERT INTO schema_migrations (version) VALUES ('20090304200627');

INSERT INTO schema_migrations (version) VALUES ('20090313172521');

INSERT INTO schema_migrations (version) VALUES ('20090317213853');

INSERT INTO schema_migrations (version) VALUES ('20090318030055');

INSERT INTO schema_migrations (version) VALUES ('20090318095819');

INSERT INTO schema_migrations (version) VALUES ('20090322182558');

INSERT INTO schema_migrations (version) VALUES ('20090325215842');

INSERT INTO schema_migrations (version) VALUES ('20090418204625');

INSERT INTO schema_migrations (version) VALUES ('20090422110207');

INSERT INTO schema_migrations (version) VALUES ('20091123140859');

INSERT INTO schema_migrations (version) VALUES ('20091123231403');

INSERT INTO schema_migrations (version) VALUES ('20091221113852');

INSERT INTO schema_migrations (version) VALUES ('20091222102642');

INSERT INTO schema_migrations (version) VALUES ('20100115195634');

INSERT INTO schema_migrations (version) VALUES ('20100127105329');

INSERT INTO schema_migrations (version) VALUES ('20100127105330');

INSERT INTO schema_migrations (version) VALUES ('20100204103604');

INSERT INTO schema_migrations (version) VALUES ('20100204103606');

INSERT INTO schema_migrations (version) VALUES ('20100204103607');

INSERT INTO schema_migrations (version) VALUES ('20100204103609');

INSERT INTO schema_migrations (version) VALUES ('20100204103610');

INSERT INTO schema_migrations (version) VALUES ('20100204103611');

INSERT INTO schema_migrations (version) VALUES ('20100204103612');

INSERT INTO schema_migrations (version) VALUES ('20100204103613');

INSERT INTO schema_migrations (version) VALUES ('20100204103614');

INSERT INTO schema_migrations (version) VALUES ('20100204103615');

INSERT INTO schema_migrations (version) VALUES ('20100204103616');

INSERT INTO schema_migrations (version) VALUES ('20100204103617');

INSERT INTO schema_migrations (version) VALUES ('20100204103618');

INSERT INTO schema_migrations (version) VALUES ('20100204103619');

INSERT INTO schema_migrations (version) VALUES ('20100204103620');

INSERT INTO schema_migrations (version) VALUES ('20100204103621');

INSERT INTO schema_migrations (version) VALUES ('20100204103622');

INSERT INTO schema_migrations (version) VALUES ('20100204103623');

INSERT INTO schema_migrations (version) VALUES ('20100204103625');

INSERT INTO schema_migrations (version) VALUES ('20100204103626');

INSERT INTO schema_migrations (version) VALUES ('20100204103627');

INSERT INTO schema_migrations (version) VALUES ('20100204103628');

INSERT INTO schema_migrations (version) VALUES ('20100204103629');

INSERT INTO schema_migrations (version) VALUES ('20100204103630');

INSERT INTO schema_migrations (version) VALUES ('20100204103631');

INSERT INTO schema_migrations (version) VALUES ('20100204103632');

INSERT INTO schema_migrations (version) VALUES ('20100204103633');

INSERT INTO schema_migrations (version) VALUES ('20100204103634');

INSERT INTO schema_migrations (version) VALUES ('20100204103635');

INSERT INTO schema_migrations (version) VALUES ('20100204103636');

INSERT INTO schema_migrations (version) VALUES ('20100204103637');

INSERT INTO schema_migrations (version) VALUES ('20100204103638');

INSERT INTO schema_migrations (version) VALUES ('20100204103639');

INSERT INTO schema_migrations (version) VALUES ('20140702122903');

INSERT INTO schema_migrations (version) VALUES ('20140702122904');

INSERT INTO schema_migrations (version) VALUES ('20140702122905');

INSERT INTO schema_migrations (version) VALUES ('20140904142136');

INSERT INTO schema_migrations (version) VALUES ('20141007183833');

INSERT INTO schema_migrations (version) VALUES ('20141013143540');

INSERT INTO schema_migrations (version) VALUES ('20141021132011');

INSERT INTO schema_migrations (version) VALUES ('20141021140043');

INSERT INTO schema_migrations (version) VALUES ('20141029204415');

INSERT INTO schema_migrations (version) VALUES ('20141103130915');

INSERT INTO schema_migrations (version) VALUES ('20141109114439');

INSERT INTO schema_migrations (version) VALUES ('20141109190633');

INSERT INTO schema_migrations (version) VALUES ('20141129212750');

INSERT INTO schema_migrations (version) VALUES ('20141219104230');

INSERT INTO schema_migrations (version) VALUES ('20141219133401');

INSERT INTO schema_migrations (version) VALUES ('20141226215131');

INSERT INTO schema_migrations (version) VALUES ('20150107124536');

INSERT INTO schema_migrations (version) VALUES ('20150112142151');

INSERT INTO schema_migrations (version) VALUES ('20150212151917');

INSERT INTO schema_migrations (version) VALUES ('20150228104912');

INSERT INTO schema_migrations (version) VALUES ('20150301092749');

INSERT INTO schema_migrations (version) VALUES ('20150303102410');

INSERT INTO schema_migrations (version) VALUES ('20150330110301');

INSERT INTO schema_migrations (version) VALUES ('20150330211145');

INSERT INTO schema_migrations (version) VALUES ('20150331120524');

INSERT INTO schema_migrations (version) VALUES ('20150331123340');

INSERT INTO schema_migrations (version) VALUES ('20150408154336');

INSERT INTO schema_migrations (version) VALUES ('20150411163911');

INSERT INTO schema_migrations (version) VALUES ('20150411194550');

INSERT INTO schema_migrations (version) VALUES ('20150412115324');

INSERT INTO schema_migrations (version) VALUES ('20150412171113');

INSERT INTO schema_migrations (version) VALUES ('20150412204639');

INSERT INTO schema_migrations (version) VALUES ('20150415145620');

INSERT INTO schema_migrations (version) VALUES ('20150418212753');

INSERT INTO schema_migrations (version) VALUES ('20150426113644');

INSERT INTO schema_migrations (version) VALUES ('20150501172715');

INSERT INTO schema_migrations (version) VALUES ('20150629115150');

INSERT INTO schema_migrations (version) VALUES ('20151220121739');

INSERT INTO schema_migrations (version) VALUES ('20160314113503');

INSERT INTO schema_migrations (version) VALUES ('20160315214056');

INSERT INTO schema_migrations (version) VALUES ('20160531101148');

INSERT INTO schema_migrations (version) VALUES ('20170301084210');

INSERT INTO schema_migrations (version) VALUES ('20170302100934');

INSERT INTO schema_migrations (version) VALUES ('20170315113846');

INSERT INTO schema_migrations (version) VALUES ('20180202143309');

INSERT INTO schema_migrations (version) VALUES ('20180617173056');

INSERT INTO schema_migrations (version) VALUES ('20191203151355');

