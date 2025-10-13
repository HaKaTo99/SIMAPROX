-- ====================================================================
-- SIMAPRO Enterprise Consolidated Baseline (v2025_10)
-- Regenerated: 2025-10-06T07:44:32.794Z (simaproxen)
-- WARNING: Do not edit below manually; use refreshBaseline utility.
-- Exclusions: kanban_boards, kanban_columns, kanban_cards, timesheet_entries, activity_baselines, wbs_baselines, activity_relationships_legacy, calendars, calendar_exceptions
-- ====================================================================

--
-- Tambah tabel projects untuk kebutuhan custom
CREATE TABLE IF NOT EXISTS public.projects (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    portfolio_id INTEGER REFERENCES public.portfolios(id),
    eps_id INTEGER REFERENCES public.eps(id),
    name VARCHAR(128) NOT NULL,
    description TEXT,
    status VARCHAR(32) DEFAULT 'active',
    start_date DATE,
    end_date DATE,
    created_by INTEGER REFERENCES public.users(id),
    updated_by INTEGER REFERENCES public.users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
-- Dumped by pg_dump version 17.5

SELECT pg_catalog.set_config('search_path', '', false);

--
-- Name: calculate_earned_value(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_earned_value() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    NEW.earned_value = (COALESCE(NEW.percent_complete,0)::DECIMAL / 100) * COALESCE(NEW.budget_planned, 0);

    RETURN NEW;

END;$$;


--
-- Name: update_critical_path(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_critical_path() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    RETURN NEW; -- Placeholder for CPM logic

END;$$;


--
-- Name: update_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    NEW.updated_at = CURRENT_TIMESTAMP;

    RETURN NEW;

END;$$;




--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    wbs_id integer NOT NULL,
    name character varying(500) NOT NULL,
    description text,
    activity_code character varying(100),
    activity_type character varying(50) DEFAULT 'task'::character varying,
    start_date date,
    end_date date,
    actual_start_date date,
    actual_end_date date,
    duration integer,
    duration_type character varying(20) DEFAULT 'fixed'::character varying,
    percent_complete integer,
    physical_percent_complete integer,
    is_critical boolean DEFAULT false,
    constraint_type character varying(50),
    constraint_date date,
    budget_planned numeric(20,2),
    budget_used numeric(20,2) DEFAULT 0,
    earned_value numeric(20,2) DEFAULT 0,
    planned_value numeric(20,2) DEFAULT 0,
    actual_cost numeric(20,2) DEFAULT 0,
    status character varying(50) DEFAULT 'not_started'::character varying,
    priority character varying(50) DEFAULT 'medium'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer,
    duration_planned_days integer,
    duration_actual_days integer,
    early_start date,
    early_finish date,
    late_start date,
    late_finish date,
    total_float_days integer,
    driving_predecessor_id integer,
    kanban_state character varying(50) DEFAULT 'backlog'::character varying,
    kanban_order integer DEFAULT 0,
    CONSTRAINT activities_percent_complete_check CHECK (((percent_complete >= 0) AND (percent_complete <= 100))),
    CONSTRAINT activities_physical_percent_complete_check CHECK (((physical_percent_complete >= 0) AND (physical_percent_complete <= 100)))
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: activity_baselines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activity_baselines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_dependencies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_dependencies (
    id integer NOT NULL,
    predecessor_id integer,
    successor_id integer,
    relation_type character varying(10) DEFAULT 'FS'::character varying NOT NULL,
    lag_days integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: activity_dependencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activity_dependencies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_dependencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activity_dependencies_id_seq OWNED BY public.activity_dependencies.id;


--
-- Name: activity_relationships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_relationships (
    id integer NOT NULL,
    activity_id integer NOT NULL,
    predecessor_id integer NOT NULL,
    relationship_type character varying(10) DEFAULT 'FS'::character varying,
    lag_duration integer DEFAULT 0,
    lag_duration_type character varying(20) DEFAULT 'days'::character varying,
    is_critical boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: activity_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activity_relationships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activity_relationships_id_seq OWNED BY public.activity_relationships.id;


--
-- Name: ai_predictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_predictions (
    id integer NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id integer NOT NULL,
    prediction_type character varying(100) NOT NULL,
    confidence_score numeric(5,4),
    predicted_value jsonb,
    actual_value jsonb,
    prediction_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: ai_predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ai_predictions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ai_predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ai_predictions_id_seq OWNED BY public.ai_predictions.id;


--
-- Name: api_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_integrations (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    service_type character varying(100) NOT NULL,
    config jsonb NOT NULL,
    is_active boolean DEFAULT true,
    webhook_url character varying(500),
    last_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: api_integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_integrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_integrations_id_seq OWNED BY public.api_integrations.id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id integer NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id integer NOT NULL,
    filename character varying(500) NOT NULL,
    file_path character varying(1000) NOT NULL,
    file_size integer,
    mime_type character varying(100),
    uploaded_by integer NOT NULL,
    version integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    company_id integer,
    user_id integer,
    original_name character varying(255),
    stored_name character varying(255),
    size_bytes bigint,
    checksum_sha256 character(64),
    storage_path text,
    deleted_at timestamp without time zone
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachments_id_seq
    AS integer
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
-- Name: audit_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_events (
    id bigint NOT NULL,
    company_id integer,
    user_id integer,
    action character varying(80) NOT NULL,
    entity_type character varying(50),
    entity_id bigint,
    meta jsonb,
    request_id character varying(60),
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: audit_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_events_id_seq OWNED BY public.audit_events.id;


--
-- Name: auth_refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_refresh_tokens (
    id bigint NOT NULL,
    user_id integer,
    token_hash text NOT NULL,
    user_agent text,
    ip_address text,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone,
    replaced_by bigint,
    meta jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: auth_refresh_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_refresh_tokens_id_seq OWNED BY public.auth_refresh_tokens.id;


--
-- Name: baseline_activity_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.baseline_activity_snapshots (
    id bigint NOT NULL,
    baseline_set_id integer,
    activity_id integer,
    name character varying(200) NOT NULL,
    duration_planned_days integer,
    start_date date,
    end_date date,
    percent_complete integer,
    budget_planned numeric,
    created_at timestamp without time zone DEFAULT now(),
    early_start date,
    early_finish date,
    late_start date,
    late_finish date,
    total_float_days integer,
    is_critical boolean,
    driving_predecessor_id integer
);


--
-- Name: baseline_activity_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.baseline_activity_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: baseline_activity_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.baseline_activity_snapshots_id_seq OWNED BY public.baseline_activity_snapshots.id;


--
-- Name: baseline_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.baseline_sets (
    id integer NOT NULL,
    eps_id integer,
    name character varying(150) NOT NULL,
    description text,
    created_by integer,
    is_primary boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: baseline_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.baseline_sets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: baseline_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.baseline_sets_id_seq OWNED BY public.baseline_sets.id;


--
-- Name: boards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boards (
    id integer NOT NULL,
    workspace_id integer NOT NULL,
    eps_id integer,
    name character varying(255) NOT NULL,
    description text,
    board_type character varying(50) DEFAULT 'project'::character varying,
    view_type character varying(50) DEFAULT 'table'::character varying,
    color character varying(20),
    columns_config jsonb DEFAULT '[]'::jsonb,
    statuses_config jsonb DEFAULT '[]'::jsonb,
    permissions jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.boards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.boards_id_seq OWNED BY public.boards.id;


--
-- Name: business_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_units (
    id integer NOT NULL,
    company_id integer NOT NULL,
    parent_business_unit_id integer,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    manager_id integer,
    cost_center character varying(100),
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: business_units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.business_units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.business_units_id_seq OWNED BY public.business_units.id;


--
-- Name: calendar_exceptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calendar_exceptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calendars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    task_id integer,
    activity_id integer,
    user_id integer NOT NULL,
    parent_comment_id integer,
    content text NOT NULL,
    mentions jsonb DEFAULT '[]'::jsonb,
    attachments jsonb DEFAULT '[]'::jsonb,
    is_pinned boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    company_id integer,
    entity_type character varying(50),
    entity_id bigint,
    parent_id bigint,
    body_raw text,
    body_html text,
    deleted_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
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
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    parent_company_id integer,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    timezone character varying(50) DEFAULT 'Asia/Jakarta'::character varying,
    currency character varying(10) DEFAULT 'IDR'::character varying,
    locale character varying(10) DEFAULT 'id_ID'::character varying,
    config jsonb DEFAULT '{}'::jsonb,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer,
    current_plan_code text
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_feature_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_feature_flags (
    company_id integer NOT NULL,
    flag_id integer NOT NULL,
    enabled boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: company_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_subscriptions (
    id integer NOT NULL,
    company_id integer NOT NULL,
    plan_type_id integer NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    period_start timestamp with time zone DEFAULT now() NOT NULL,
    period_end timestamp with time zone,
    cancel_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: company_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_subscriptions_id_seq OWNED BY public.company_subscriptions.id;


--
-- Name: cost_ledger_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cost_ledger_entries (
    id bigint NOT NULL,
    eps_id integer,
    activity_id integer,
    resource_id integer,
    entry_date date DEFAULT CURRENT_DATE NOT NULL,
    cost_type character varying(40) DEFAULT 'actual'::character varying NOT NULL,
    amount numeric DEFAULT 0,
    hours numeric,
    description text,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: cost_ledger_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cost_ledger_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cost_ledger_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cost_ledger_entries_id_seq OWNED BY public.cost_ledger_entries.id;


--
-- Name: custom_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_fields (
    id integer NOT NULL,
    board_id integer NOT NULL,
    name character varying(255) NOT NULL,
    field_type character varying(50) NOT NULL,
    description text,
    options jsonb,
    is_required boolean DEFAULT false,
    "position" integer DEFAULT 0,
    settings jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_fields_id_seq OWNED BY public.custom_fields.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    business_unit_id integer NOT NULL,
    parent_department_id integer,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    head_id integer,
    function_type character varying(100),
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: eps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eps (
    id integer NOT NULL,
    portfolio_id integer,
    company_id integer NOT NULL,
    parent_eps_id integer,
    name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    description text,
    project_type character varying(100),
    budget_planned numeric(20,2),
    budget_used numeric(20,2) DEFAULT 0,
    revenue_expected numeric(20,2),
    start_date date,
    end_date date,
    actual_start_date date,
    actual_end_date date,
    status character varying(50) DEFAULT 'draft'::character varying,
    priority character varying(50) DEFAULT 'medium'::character varying,
    health_status character varying(50) DEFAULT 'green'::character varying,
    critical_path_method_enabled boolean DEFAULT true,
    earned_value_management_enabled boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: eps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eps_id_seq OWNED BY public.eps.id;


--
-- Name: evm_periods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.evm_periods (
    id bigint NOT NULL,
    eps_id integer,
    period_start date NOT NULL,
    period_end date NOT NULL,
    pv numeric DEFAULT 0,
    ev numeric DEFAULT 0,
    ac numeric DEFAULT 0,
    cpi numeric,
    spi numeric,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: evm_periods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.evm_periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evm_periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.evm_periods_id_seq OWNED BY public.evm_periods.id;


--
-- Name: feature_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feature_flags (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    description text,
    enabled_global boolean DEFAULT false,
    rollout_pct integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
-- Tambah kolom enabled untuk kompatibilitas seed
ALTER TABLE public.feature_flags ADD COLUMN enabled boolean DEFAULT true;


--
-- Name: feature_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feature_flags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feature_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feature_flags_id_seq OWNED BY public.feature_flags.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.issues (
    id bigint NOT NULL,
    company_id integer,
    entity_type character varying(50),
    entity_id bigint,
    title character varying(250) NOT NULL,
    description text,
    status character varying(40) DEFAULT 'open'::character varying NOT NULL,
    priority character varying(20) DEFAULT 'medium'::character varying NOT NULL,
    assignee_user_id integer,
    reporter_user_id integer,
    labels text[],
    due_date date,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    closed_at timestamp without time zone,
    CONSTRAINT issues_entity_chk CHECK (((entity_type IS NULL) OR ((entity_type)::text = ANY ((ARRAY['activities'::character varying, 'kanban_cards'::character varying, 'eps'::character varying, 'wbs'::character varying, 'resources'::character varying])::text[]))))
);


--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.issues_id_seq OWNED BY public.issues.id;


--
-- Name: kanban_boards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.kanban_boards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kanban_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.kanban_cards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kanban_columns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.kanban_columns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    address text,
    city character varying(100),
    state character varying(100),
    country character varying(100) DEFAULT 'Indonesia'::character varying,
    timezone character varying(50),
    latitude numeric(10,8),
    longitude numeric(11,8),
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    user_id integer,
    company_id integer,
    type character varying(60) NOT NULL,
    entity_type character varying(50),
    entity_id bigint,
    payload jsonb,
    read_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    key character varying(120) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: plan_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plan_types (
    id integer NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    monthly_price numeric,
    annual_price numeric,
    max_users integer,
    storage_quota_mb integer,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: plan_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plan_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plan_types_id_seq OWNED BY public.plan_types.id;


--
-- Name: portfolios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.portfolios (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    strategic_objectives text,
    budget_total numeric(20,2),
    budget_used numeric(20,2) DEFAULT 0,
    start_date date,
    end_date date,
    status character varying(50) DEFAULT 'planning'::character varying,
    priority character varying(50) DEFAULT 'medium'::character varying,
    risk_tolerance character varying(50) DEFAULT 'medium'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: portfolio_overview; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.portfolio_overview AS
 SELECT p.id,
    p.name,
    p.budget_total,
    p.budget_used,
    count(e.id) AS project_count,
    avg(
        CASE
            WHEN ((e.health_status)::text = 'green'::text) THEN (1)::numeric
            WHEN ((e.health_status)::text = 'yellow'::text) THEN 0.5
            ELSE (0)::numeric
        END) AS health_score
   FROM (public.portfolios p
     LEFT JOIN public.eps e ON ((p.id = e.portfolio_id)))
  GROUP BY p.id, p.name, p.budget_total, p.budget_used;


--
-- Name: portfolios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.portfolios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portfolios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.portfolios_id_seq OWNED BY public.portfolios.id;


--
-- Name: wbs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wbs (
    id integer NOT NULL,
    eps_id integer NOT NULL,
    parent_wbs_id integer,
    name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    description text,
    wbs_level integer DEFAULT 1,
    budget_planned numeric(20,2),
    budget_used numeric(20,2) DEFAULT 0,
    scope_statement text,
    weight_percent numeric(5,2),
    is_milestone boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: project_health_dashboard; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.project_health_dashboard AS
 SELECT e.id,
    e.name,
    e.status,
    e.health_status,
    e.start_date,
    e.end_date,
    e.budget_planned,
    e.budget_used,
    count(a.id) AS activity_count,
    avg(a.percent_complete) AS avg_completion,
    sum(
        CASE
            WHEN a.is_critical THEN 1
            ELSE 0
        END) AS critical_activities
   FROM ((public.eps e
     LEFT JOIN public.wbs w ON ((e.id = w.eps_id)))
     LEFT JOIN public.activities a ON ((w.id = a.wbs_id)))
  GROUP BY e.id, e.name, e.status, e.health_status, e.start_date, e.end_date, e.budget_planned, e.budget_used;


--
-- Name: resource_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_assignments (
    id integer NOT NULL,
    activity_id integer NOT NULL,
    resource_id integer NOT NULL,
    units numeric(5,2) DEFAULT 100,
    work_quantity numeric(15,2),
    work_unit character varying(50) DEFAULT 'hours'::character varying,
    planned_cost numeric(20,2),
    actual_cost numeric(20,2) DEFAULT 0,
    remaining_cost numeric(20,2) DEFAULT 0,
    start_date date,
    end_date date,
    actual_start_date date,
    actual_end_date date,
    status character varying(50) DEFAULT 'planned'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer,
    allocation_percent numeric,
    planned_hours numeric,
    actual_hours numeric
);


--
-- Name: resource_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resource_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resource_assignments_id_seq OWNED BY public.resource_assignments.id;


--
-- Name: resource_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_types (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    category character varying(100),
    rate_type character varying(50) DEFAULT 'hourly'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: resource_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resource_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resource_types_id_seq OWNED BY public.resource_types.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resources (
    id integer NOT NULL,
    resource_type_id integer,
    company_id integer NOT NULL,
    user_id integer,
    name character varying(255) NOT NULL,
    code character varying(100),
    description text,
    unit_cost numeric(15,2),
    cost_per_use numeric(15,2) DEFAULT 0,
    availability numeric(5,2) DEFAULT 100,
    max_units numeric(5,2) DEFAULT 100,
    calendar_id integer,
    skills jsonb DEFAULT '[]'::jsonb,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer,
    cost_rate_hour numeric,
    utilization_target numeric
);


--
-- Name: resource_utilization; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.resource_utilization AS
 SELECT r.id,
    r.name,
    r.resource_type_id,
    rt.name AS resource_type,
    count(ra.id) AS assignment_count,
    sum(ra.units) AS total_units,
    avg(ra.units) AS avg_utilization
   FROM ((public.resources r
     JOIN public.resource_types rt ON ((r.resource_type_id = rt.id)))
     LEFT JOIN public.resource_assignments ra ON ((r.id = ra.resource_id)))
  GROUP BY r.id, r.name, r.resource_type_id, rt.name;


--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resources_id_seq OWNED BY public.resources.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    role_type character varying(50) DEFAULT 'system'::character varying,
    hierarchy_level integer DEFAULT 0,
    permissions jsonb DEFAULT '[]'::jsonb,
    is_system_role boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: saved_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_reports (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    report_type character varying(100) NOT NULL,
    filters jsonb DEFAULT '{}'::jsonb,
    columns jsonb DEFAULT '[]'::jsonb,
    schedule jsonb,
    is_public boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: saved_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.saved_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saved_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.saved_reports_id_seq OWNED BY public.saved_reports.id;


--
-- Name: task_dependencies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_dependencies (
    id integer NOT NULL,
    task_id integer NOT NULL,
    depends_on_task_id integer NOT NULL,
    dependency_type character varying(20) DEFAULT 'finish_to_start'::character varying,
    lag_days integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: task_dependencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_dependencies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_dependencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_dependencies_id_seq OWNED BY public.task_dependencies.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    board_id integer NOT NULL,
    activity_id integer,
    parent_task_id integer,
    name character varying(500) NOT NULL,
    description text,
    status character varying(100) DEFAULT 'todo'::character varying,
    priority character varying(50) DEFAULT 'medium'::character varying,
    due_date timestamp with time zone,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    actual_start_date timestamp with time zone,
    actual_end_date timestamp with time zone,
    estimated_hours numeric(8,2),
    actual_hours numeric(8,2) DEFAULT 0,
    progress_percent integer,
    "position" integer DEFAULT 0,
    tags jsonb DEFAULT '[]'::jsonb,
    custom_fields jsonb DEFAULT '{}'::jsonb,
    assignee_ids jsonb DEFAULT '[]'::jsonb,
    follower_ids jsonb DEFAULT '[]'::jsonb,
    is_template boolean DEFAULT false,
    template_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer,
    CONSTRAINT tasks_progress_percent_check CHECK (((progress_percent >= 0) AND (progress_percent <= 100)))
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: time_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.time_entries (
    id integer NOT NULL,
    task_id integer,
    activity_id integer,
    user_id integer NOT NULL,
    started_at timestamp with time zone NOT NULL,
    ended_at timestamp with time zone,
    duration_minutes integer,
    description text,
    billable boolean DEFAULT true,
    billing_rate numeric(10,2),
    status character varying(50) DEFAULT 'draft'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: time_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.time_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.time_entries_id_seq OWNED BY public.time_entries.id;


--
-- Name: timesheet_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timesheet_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_roles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    assigned_by integer,
    assigned_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp with time zone
);


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    company_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    employee_id character varying(50),
    department character varying(100),
    "position" character varying(100),
    phone character varying(20),
    avatar_url character varying(500),
    timezone character varying(50) DEFAULT 'Asia/Jakarta'::character varying,
    locale character varying(10) DEFAULT 'id_ID'::character varying,
    working_hours jsonb DEFAULT '{"fri": {"end": "18:00", "start": "09:00"}, "mon": {"end": "18:00", "start": "09:00"}, "thu": {"end": "18:00", "start": "09:00"}, "tue": {"end": "18:00", "start": "09:00"}, "wed": {"end": "18:00", "start": "09:00"}}'::jsonb,
    skills jsonb DEFAULT '[]'::jsonb,
    capacity_hours_per_week integer DEFAULT 40,
    status character varying(20) DEFAULT 'active'::character varying,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer,
    must_change_password boolean DEFAULT false
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
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
-- Name: wbs_baselines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wbs_baselines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wbs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wbs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wbs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wbs_id_seq OWNED BY public.wbs.id;


--
-- Name: work_calendars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_calendars (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    base_calendar_id integer,
    work_hours jsonb DEFAULT '{"fri": {"end": "17:00", "start": "08:00"}, "mon": {"end": "17:00", "start": "08:00"}, "thu": {"end": "17:00", "start": "08:00"}, "tue": {"end": "17:00", "start": "08:00"}, "wed": {"end": "17:00", "start": "08:00"}}'::jsonb,
    exceptions jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: work_calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.work_calendars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.work_calendars_id_seq OWNED BY public.work_calendars.id;


--
-- Name: workflow_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflow_instances (
    id integer NOT NULL,
    workflow_template_id integer NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id integer NOT NULL,
    current_step integer DEFAULT 0,
    status character varying(50) DEFAULT 'pending'::character varying,
    initiated_by integer NOT NULL,
    initiated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: workflow_instances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflow_instances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflow_instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflow_instances_id_seq OWNED BY public.workflow_instances.id;


--
-- Name: workflow_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflow_templates (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    entity_type character varying(100) NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb,
    steps jsonb DEFAULT '[]'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: workflow_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflow_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflow_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflow_templates_id_seq OWNED BY public.workflow_templates.id;


--
-- Name: workspaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspaces (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    color character varying(20),
    icon character varying(50),
    privacy character varying(20) DEFAULT 'private'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    updated_by integer
);


--
-- Name: workspaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workspaces_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workspaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workspaces_id_seq OWNED BY public.workspaces.id;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: activity_dependencies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_dependencies ALTER COLUMN id SET DEFAULT nextval('public.activity_dependencies_id_seq'::regclass);


--
-- Name: activity_relationships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_relationships ALTER COLUMN id SET DEFAULT nextval('public.activity_relationships_id_seq'::regclass);


--
-- Name: ai_predictions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_predictions ALTER COLUMN id SET DEFAULT nextval('public.ai_predictions_id_seq'::regclass);


--
-- Name: api_integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_integrations ALTER COLUMN id SET DEFAULT nextval('public.api_integrations_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: audit_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events ALTER COLUMN id SET DEFAULT nextval('public.audit_events_id_seq'::regclass);


--
-- Name: auth_refresh_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_refresh_tokens ALTER COLUMN id SET DEFAULT nextval('public.auth_refresh_tokens_id_seq'::regclass);


--
-- Name: baseline_activity_snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_activity_snapshots ALTER COLUMN id SET DEFAULT nextval('public.baseline_activity_snapshots_id_seq'::regclass);


--
-- Name: baseline_sets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_sets ALTER COLUMN id SET DEFAULT nextval('public.baseline_sets_id_seq'::regclass);


--
-- Name: boards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards ALTER COLUMN id SET DEFAULT nextval('public.boards_id_seq'::regclass);


--
-- Name: business_units id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_units ALTER COLUMN id SET DEFAULT nextval('public.business_units_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: company_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.company_subscriptions_id_seq'::regclass);


--
-- Name: cost_ledger_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cost_ledger_entries ALTER COLUMN id SET DEFAULT nextval('public.cost_ledger_entries_id_seq'::regclass);


--
-- Name: custom_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields ALTER COLUMN id SET DEFAULT nextval('public.custom_fields_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: eps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eps ALTER COLUMN id SET DEFAULT nextval('public.eps_id_seq'::regclass);


--
-- Name: evm_periods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evm_periods ALTER COLUMN id SET DEFAULT nextval('public.evm_periods_id_seq'::regclass);


--
-- Name: feature_flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_flags ALTER COLUMN id SET DEFAULT nextval('public.feature_flags_id_seq'::regclass);


--
-- Name: issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues ALTER COLUMN id SET DEFAULT nextval('public.issues_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: plan_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan_types ALTER COLUMN id SET DEFAULT nextval('public.plan_types_id_seq'::regclass);


--
-- Name: portfolios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portfolios ALTER COLUMN id SET DEFAULT nextval('public.portfolios_id_seq'::regclass);


--
-- Name: resource_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_assignments ALTER COLUMN id SET DEFAULT nextval('public.resource_assignments_id_seq'::regclass);


--
-- Name: resource_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_types ALTER COLUMN id SET DEFAULT nextval('public.resource_types_id_seq'::regclass);


--
-- Name: resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources ALTER COLUMN id SET DEFAULT nextval('public.resources_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: saved_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_reports ALTER COLUMN id SET DEFAULT nextval('public.saved_reports_id_seq'::regclass);


--
-- Name: task_dependencies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_dependencies ALTER COLUMN id SET DEFAULT nextval('public.task_dependencies_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: time_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries ALTER COLUMN id SET DEFAULT nextval('public.time_entries_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: wbs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wbs ALTER COLUMN id SET DEFAULT nextval('public.wbs_id_seq'::regclass);


--
-- Name: work_calendars id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_calendars ALTER COLUMN id SET DEFAULT nextval('public.work_calendars_id_seq'::regclass);


--
-- Name: workflow_instances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_instances ALTER COLUMN id SET DEFAULT nextval('public.workflow_instances_id_seq'::regclass);


--
-- Name: workflow_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_templates ALTER COLUMN id SET DEFAULT nextval('public.workflow_templates_id_seq'::regclass);


--
-- Name: workspaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces ALTER COLUMN id SET DEFAULT nextval('public.workspaces_id_seq'::regclass);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: activity_dependencies activity_dependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_dependencies
    ADD CONSTRAINT activity_dependencies_pkey PRIMARY KEY (id);


--
-- Name: activity_dependencies activity_dependencies_predecessor_id_successor_id_relation__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_dependencies
    ADD CONSTRAINT activity_dependencies_predecessor_id_successor_id_relation__key UNIQUE (predecessor_id, successor_id, relation_type);


--
-- Name: activity_relationships activity_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_relationships
    ADD CONSTRAINT activity_relationships_pkey PRIMARY KEY (id);


--
-- Name: ai_predictions ai_predictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_predictions
    ADD CONSTRAINT ai_predictions_pkey PRIMARY KEY (id);


--
-- Name: api_integrations api_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_integrations
    ADD CONSTRAINT api_integrations_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: audit_events audit_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);


--
-- Name: auth_refresh_tokens auth_refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_refresh_tokens
    ADD CONSTRAINT auth_refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: auth_refresh_tokens auth_refresh_tokens_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_refresh_tokens
    ADD CONSTRAINT auth_refresh_tokens_token_hash_key UNIQUE (token_hash);


--
-- Name: baseline_activity_snapshots baseline_activity_snapshots_baseline_set_id_activity_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_activity_snapshots
    ADD CONSTRAINT baseline_activity_snapshots_baseline_set_id_activity_id_key UNIQUE (baseline_set_id, activity_id);


--
-- Name: baseline_activity_snapshots baseline_activity_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_activity_snapshots
    ADD CONSTRAINT baseline_activity_snapshots_pkey PRIMARY KEY (id);


--
-- Name: baseline_sets baseline_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_sets
    ADD CONSTRAINT baseline_sets_pkey PRIMARY KEY (id);


--
-- Name: boards boards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: business_units business_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_units
    ADD CONSTRAINT business_units_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: companies companies_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_code_key UNIQUE (code);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_feature_flags company_feature_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_feature_flags
    ADD CONSTRAINT company_feature_flags_pkey PRIMARY KEY (company_id, flag_id);


--
-- Name: company_subscriptions company_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_subscriptions
    ADD CONSTRAINT company_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: cost_ledger_entries cost_ledger_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cost_ledger_entries
    ADD CONSTRAINT cost_ledger_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_fields custom_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields
    ADD CONSTRAINT custom_fields_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: eps eps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eps
    ADD CONSTRAINT eps_pkey PRIMARY KEY (id);


--
-- Name: evm_periods evm_periods_eps_id_period_start_period_end_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evm_periods
    ADD CONSTRAINT evm_periods_eps_id_period_start_period_end_key UNIQUE (eps_id, period_start, period_end);


--
-- Name: evm_periods evm_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evm_periods
    ADD CONSTRAINT evm_periods_pkey PRIMARY KEY (id);


--
-- Name: feature_flags feature_flags_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_flags
    ADD CONSTRAINT feature_flags_key_key UNIQUE (key);


--
-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_key_key UNIQUE (key);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: plan_types plan_types_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan_types
    ADD CONSTRAINT plan_types_code_key UNIQUE (code);


--
-- Name: plan_types plan_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan_types
    ADD CONSTRAINT plan_types_pkey PRIMARY KEY (id);


--
-- Name: portfolios portfolios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portfolios
    ADD CONSTRAINT portfolios_pkey PRIMARY KEY (id);


--
-- Name: resource_assignments resource_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_assignments
    ADD CONSTRAINT resource_assignments_pkey PRIMARY KEY (id);


--
-- Name: resource_types resource_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_types
    ADD CONSTRAINT resource_types_pkey PRIMARY KEY (id);


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_company_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_company_name_unique UNIQUE (company_id, name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: saved_reports saved_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_reports
    ADD CONSTRAINT saved_reports_pkey PRIMARY KEY (id);


--
-- Name: task_dependencies task_dependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_dependencies
    ADD CONSTRAINT task_dependencies_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: time_entries time_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_user_id_role_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_id_key UNIQUE (user_id, role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: wbs wbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wbs
    ADD CONSTRAINT wbs_pkey PRIMARY KEY (id);


--
-- Name: work_calendars work_calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_calendars
    ADD CONSTRAINT work_calendars_pkey PRIMARY KEY (id);


--
-- Name: workflow_instances workflow_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_instances
    ADD CONSTRAINT workflow_instances_pkey PRIMARY KEY (id);


--
-- Name: workflow_templates workflow_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_templates
    ADD CONSTRAINT workflow_templates_pkey PRIMARY KEY (id);


--
-- Name: workspaces workspaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);


--
-- Name: idx_activities_critical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_activities_critical ON public.activities USING btree (is_critical);


--
-- Name: idx_activities_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_activities_dates ON public.activities USING btree (start_date, end_date);


--
-- Name: idx_activities_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_activities_status ON public.activities USING btree (status);


--
-- Name: idx_activities_wbs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_activities_wbs ON public.activities USING btree (wbs_id);


--
-- Name: idx_activity_deps_predecessor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_activity_deps_predecessor ON public.activity_dependencies USING btree (predecessor_id);


--
-- Name: idx_activity_deps_successor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_activity_deps_successor ON public.activity_dependencies USING btree (successor_id);


--
-- Name: idx_attachments_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attachments_checksum ON public.attachments USING btree (checksum_sha256);


--
-- Name: idx_attachments_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attachments_company ON public.attachments USING btree (company_id);


--
-- Name: idx_attachments_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attachments_entity ON public.attachments USING btree (entity_type, entity_id);


--
-- Name: idx_attachments_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attachments_user ON public.attachments USING btree (user_id);


--
-- Name: idx_audit_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_action ON public.audit_events USING btree (action);


--
-- Name: idx_audit_company_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_company_created ON public.audit_events USING btree (company_id, created_at DESC);


--
-- Name: idx_audit_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_entity ON public.audit_events USING btree (entity_type, entity_id);


--
-- Name: idx_auth_refresh_tokens_user_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_refresh_tokens_user_active ON public.auth_refresh_tokens USING btree (user_id) WHERE (revoked_at IS NULL);


--
-- Name: idx_baseline_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_baseline_primary ON public.baseline_sets USING btree (eps_id) WHERE (is_primary = true);


--
-- Name: idx_comments_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comments_company ON public.comments USING btree (company_id);


--
-- Name: idx_comments_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comments_entity ON public.comments USING btree (entity_type, entity_id);


--
-- Name: idx_comments_mentions_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comments_mentions_gin ON public.comments USING gin (mentions);


--
-- Name: idx_comments_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comments_parent ON public.comments USING btree (parent_id);


--
-- Name: idx_company_feature_flags_flag; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_company_feature_flags_flag ON public.company_feature_flags USING btree (flag_id);


--
-- Name: idx_cost_ledger_activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cost_ledger_activity ON public.cost_ledger_entries USING btree (activity_id);


--
-- Name: idx_cost_ledger_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cost_ledger_date ON public.cost_ledger_entries USING btree (entry_date);


--
-- Name: idx_cost_ledger_eps; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cost_ledger_eps ON public.cost_ledger_entries USING btree (eps_id);


--
-- Name: idx_eps_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_eps_company ON public.eps USING btree (company_id);


--
-- Name: idx_eps_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_eps_dates ON public.eps USING btree (start_date, end_date);


--
-- Name: idx_eps_portfolio; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_eps_portfolio ON public.eps USING btree (portfolio_id);


--
-- Name: idx_eps_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_eps_status ON public.eps USING btree (status);


--
-- Name: idx_evm_periods_eps; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evm_periods_eps ON public.evm_periods USING btree (eps_id);


--
-- Name: idx_feature_flags_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feature_flags_enabled ON public.feature_flags USING btree (enabled_global);


--
-- Name: idx_issues_assignee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_issues_assignee ON public.issues USING btree (assignee_user_id);


--
-- Name: idx_issues_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_issues_company ON public.issues USING btree (company_id);


--
-- Name: idx_issues_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_issues_entity ON public.issues USING btree (entity_type, entity_id);


--
-- Name: idx_issues_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_issues_status ON public.issues USING btree (status);


--
-- Name: idx_notifications_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_company ON public.notifications USING btree (company_id);


--
-- Name: idx_notifications_user_unread; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user_unread ON public.notifications USING btree (user_id) WHERE (read_at IS NULL);


--
-- Name: idx_resource_assign_activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resource_assign_activity ON public.resource_assignments USING btree (activity_id);


--
-- Name: idx_resource_assign_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resource_assign_resource ON public.resource_assignments USING btree (resource_id);


--
-- Name: idx_resource_assignments_activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resource_assignments_activity ON public.resource_assignments USING btree (activity_id);


--
-- Name: idx_resource_assignments_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_resource_assignments_resource ON public.resource_assignments USING btree (resource_id);


--
-- Name: idx_role_permissions_perm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_permissions_perm ON public.role_permissions USING btree (permission_id);


--
-- Name: idx_role_permissions_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_permissions_role ON public.role_permissions USING btree (role_id);


--
-- Name: idx_tasks_assignees; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_assignees ON public.tasks USING gin (assignee_ids);


--
-- Name: idx_tasks_board; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_board ON public.tasks USING btree (board_id);


--
-- Name: idx_tasks_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_dates ON public.tasks USING btree (due_date, start_date);


--
-- Name: idx_tasks_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_parent ON public.tasks USING btree (parent_task_id);


--
-- Name: idx_tasks_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_status ON public.tasks USING btree (status);


--
-- Name: idx_time_entries_task; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entries_task ON public.time_entries USING btree (task_id);


--
-- Name: idx_time_entries_user_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_time_entries_user_date ON public.time_entries USING btree (user_id, started_at);


--
-- Name: idx_users_company; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_company ON public.users USING btree (company_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: activities calculate_activity_earned_value; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER calculate_activity_earned_value BEFORE INSERT OR UPDATE OF percent_complete, budget_planned ON public.activities FOR EACH ROW EXECUTE FUNCTION public.calculate_earned_value();


--
-- Name: activities update_activities_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_activities_timestamp BEFORE UPDATE ON public.activities FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: companies update_companies_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_companies_timestamp BEFORE UPDATE ON public.companies FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: eps update_eps_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_eps_timestamp BEFORE UPDATE ON public.eps FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: tasks update_tasks_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_tasks_timestamp BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: users update_users_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_users_timestamp BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: activities activities_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: activities activities_driving_predecessor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_driving_predecessor_id_fkey FOREIGN KEY (driving_predecessor_id) REFERENCES public.activities(id);


--
-- Name: activities activities_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: activities activities_wbs_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_wbs_id_fkey FOREIGN KEY (wbs_id) REFERENCES public.wbs(id) ON DELETE CASCADE;


--
-- Name: activity_dependencies activity_dependencies_predecessor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_dependencies
    ADD CONSTRAINT activity_dependencies_predecessor_id_fkey FOREIGN KEY (predecessor_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: activity_dependencies activity_dependencies_successor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_dependencies
    ADD CONSTRAINT activity_dependencies_successor_id_fkey FOREIGN KEY (successor_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: activity_relationships activity_relationships_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_relationships
    ADD CONSTRAINT activity_relationships_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: activity_relationships activity_relationships_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_relationships
    ADD CONSTRAINT activity_relationships_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: activity_relationships activity_relationships_predecessor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_relationships
    ADD CONSTRAINT activity_relationships_predecessor_id_fkey FOREIGN KEY (predecessor_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: activity_relationships activity_relationships_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_relationships
    ADD CONSTRAINT activity_relationships_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: api_integrations api_integrations_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_integrations
    ADD CONSTRAINT api_integrations_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: api_integrations api_integrations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_integrations
    ADD CONSTRAINT api_integrations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: api_integrations api_integrations_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_integrations
    ADD CONSTRAINT api_integrations_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: attachments attachments_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: attachments attachments_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: attachments attachments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: audit_events audit_events_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events
    ADD CONSTRAINT audit_events_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: audit_events audit_events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events
    ADD CONSTRAINT audit_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: auth_refresh_tokens auth_refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_refresh_tokens
    ADD CONSTRAINT auth_refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: baseline_activity_snapshots baseline_activity_snapshots_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_activity_snapshots
    ADD CONSTRAINT baseline_activity_snapshots_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: baseline_activity_snapshots baseline_activity_snapshots_baseline_set_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_activity_snapshots
    ADD CONSTRAINT baseline_activity_snapshots_baseline_set_id_fkey FOREIGN KEY (baseline_set_id) REFERENCES public.baseline_sets(id) ON DELETE CASCADE;


--
-- Name: baseline_sets baseline_sets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_sets
    ADD CONSTRAINT baseline_sets_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: baseline_sets baseline_sets_eps_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.baseline_sets
    ADD CONSTRAINT baseline_sets_eps_id_fkey FOREIGN KEY (eps_id) REFERENCES public.eps(id) ON DELETE CASCADE;


--
-- Name: boards boards_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: boards boards_eps_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_eps_id_fkey FOREIGN KEY (eps_id) REFERENCES public.eps(id) ON DELETE SET NULL;


--
-- Name: boards boards_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: boards boards_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: business_units business_units_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_units
    ADD CONSTRAINT business_units_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: business_units business_units_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_units
    ADD CONSTRAINT business_units_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: business_units business_units_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_units
    ADD CONSTRAINT business_units_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: business_units business_units_parent_business_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_units
    ADD CONSTRAINT business_units_parent_business_unit_id_fkey FOREIGN KEY (parent_business_unit_id) REFERENCES public.business_units(id) ON DELETE SET NULL;


--
-- Name: business_units business_units_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_units
    ADD CONSTRAINT business_units_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: comments comments_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: comments comments_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: comments comments_parent_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_parent_comment_id_fkey FOREIGN KEY (parent_comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comments comments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comments comments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: companies companies_parent_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_parent_company_id_fkey FOREIGN KEY (parent_company_id) REFERENCES public.companies(id) ON DELETE SET NULL;


--
-- Name: company_feature_flags company_feature_flags_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_feature_flags
    ADD CONSTRAINT company_feature_flags_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_feature_flags company_feature_flags_flag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_feature_flags
    ADD CONSTRAINT company_feature_flags_flag_id_fkey FOREIGN KEY (flag_id) REFERENCES public.feature_flags(id) ON DELETE CASCADE;


--
-- Name: company_subscriptions company_subscriptions_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_subscriptions
    ADD CONSTRAINT company_subscriptions_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_subscriptions company_subscriptions_plan_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_subscriptions
    ADD CONSTRAINT company_subscriptions_plan_type_id_fkey FOREIGN KEY (plan_type_id) REFERENCES public.plan_types(id) ON DELETE RESTRICT;


--
-- Name: cost_ledger_entries cost_ledger_entries_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cost_ledger_entries
    ADD CONSTRAINT cost_ledger_entries_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE SET NULL;


--
-- Name: cost_ledger_entries cost_ledger_entries_eps_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cost_ledger_entries
    ADD CONSTRAINT cost_ledger_entries_eps_id_fkey FOREIGN KEY (eps_id) REFERENCES public.eps(id) ON DELETE CASCADE;


--
-- Name: cost_ledger_entries cost_ledger_entries_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cost_ledger_entries
    ADD CONSTRAINT cost_ledger_entries_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resources(id) ON DELETE SET NULL;


--
-- Name: custom_fields custom_fields_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields
    ADD CONSTRAINT custom_fields_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: custom_fields custom_fields_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields
    ADD CONSTRAINT custom_fields_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: custom_fields custom_fields_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields
    ADD CONSTRAINT custom_fields_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: departments departments_business_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_business_unit_id_fkey FOREIGN KEY (business_unit_id) REFERENCES public.business_units(id) ON DELETE CASCADE;


--
-- Name: departments departments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: departments departments_head_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_head_id_fkey FOREIGN KEY (head_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: departments departments_parent_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_department_id_fkey FOREIGN KEY (parent_department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: departments departments_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: eps eps_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eps
    ADD CONSTRAINT eps_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: eps eps_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eps
    ADD CONSTRAINT eps_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: eps eps_parent_eps_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eps
    ADD CONSTRAINT eps_parent_eps_id_fkey FOREIGN KEY (parent_eps_id) REFERENCES public.eps(id) ON DELETE SET NULL;


--
-- Name: eps eps_portfolio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eps
    ADD CONSTRAINT eps_portfolio_id_fkey FOREIGN KEY (portfolio_id) REFERENCES public.portfolios(id) ON DELETE SET NULL;


--
-- Name: eps eps_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eps
    ADD CONSTRAINT eps_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: evm_periods evm_periods_eps_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evm_periods
    ADD CONSTRAINT evm_periods_eps_id_fkey FOREIGN KEY (eps_id) REFERENCES public.eps(id) ON DELETE CASCADE;


--
-- Name: issues issues_assignee_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_assignee_user_id_fkey FOREIGN KEY (assignee_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: issues issues_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: issues issues_reporter_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_reporter_user_id_fkey FOREIGN KEY (reporter_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: locations locations_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: portfolios portfolios_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portfolios
    ADD CONSTRAINT portfolios_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: portfolios portfolios_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portfolios
    ADD CONSTRAINT portfolios_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: portfolios portfolios_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portfolios
    ADD CONSTRAINT portfolios_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: resource_assignments resource_assignments_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_assignments
    ADD CONSTRAINT resource_assignments_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: resource_assignments resource_assignments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_assignments
    ADD CONSTRAINT resource_assignments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: resource_assignments resource_assignments_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_assignments
    ADD CONSTRAINT resource_assignments_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resources(id) ON DELETE CASCADE;


--
-- Name: resource_assignments resource_assignments_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_assignments
    ADD CONSTRAINT resource_assignments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: resource_types resource_types_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_types
    ADD CONSTRAINT resource_types_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: resources resources_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: resources resources_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: resources resources_resource_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_resource_type_id_fkey FOREIGN KEY (resource_type_id) REFERENCES public.resource_types(id) ON DELETE CASCADE;


--
-- Name: resources resources_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: resources resources_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: roles roles_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: saved_reports saved_reports_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_reports
    ADD CONSTRAINT saved_reports_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: saved_reports saved_reports_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_reports
    ADD CONSTRAINT saved_reports_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: saved_reports saved_reports_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_reports
    ADD CONSTRAINT saved_reports_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: task_dependencies task_dependencies_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_dependencies
    ADD CONSTRAINT task_dependencies_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: task_dependencies task_dependencies_depends_on_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_dependencies
    ADD CONSTRAINT task_dependencies_depends_on_task_id_fkey FOREIGN KEY (depends_on_task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: task_dependencies task_dependencies_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_dependencies
    ADD CONSTRAINT task_dependencies_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: task_dependencies task_dependencies_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_dependencies
    ADD CONSTRAINT task_dependencies_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_parent_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_parent_task_id_fkey FOREIGN KEY (parent_task_id) REFERENCES public.tasks(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.tasks(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: time_entries time_entries_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: time_entries time_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: time_entries time_entries_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: time_entries time_entries_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: time_entries time_entries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: users users_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: users users_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: wbs wbs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wbs
    ADD CONSTRAINT wbs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: wbs wbs_eps_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wbs
    ADD CONSTRAINT wbs_eps_id_fkey FOREIGN KEY (eps_id) REFERENCES public.eps(id) ON DELETE CASCADE;


--
-- Name: wbs wbs_parent_wbs_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wbs
    ADD CONSTRAINT wbs_parent_wbs_id_fkey FOREIGN KEY (parent_wbs_id) REFERENCES public.wbs(id) ON DELETE SET NULL;


--
-- Name: wbs wbs_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wbs
    ADD CONSTRAINT wbs_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: work_calendars work_calendars_base_calendar_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_calendars
    ADD CONSTRAINT work_calendars_base_calendar_id_fkey FOREIGN KEY (base_calendar_id) REFERENCES public.work_calendars(id) ON DELETE SET NULL;


--
-- Name: work_calendars work_calendars_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_calendars
    ADD CONSTRAINT work_calendars_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: work_calendars work_calendars_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_calendars
    ADD CONSTRAINT work_calendars_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: work_calendars work_calendars_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_calendars
    ADD CONSTRAINT work_calendars_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: workflow_instances workflow_instances_initiated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_instances
    ADD CONSTRAINT workflow_instances_initiated_by_fkey FOREIGN KEY (initiated_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: workflow_instances workflow_instances_workflow_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_instances
    ADD CONSTRAINT workflow_instances_workflow_template_id_fkey FOREIGN KEY (workflow_template_id) REFERENCES public.workflow_templates(id) ON DELETE CASCADE;


--
-- Name: workflow_templates workflow_templates_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_templates
    ADD CONSTRAINT workflow_templates_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: workflow_templates workflow_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_templates
    ADD CONSTRAINT workflow_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: workflow_templates workflow_templates_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_templates
    ADD CONSTRAINT workflow_templates_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: workspaces workspaces_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: workspaces workspaces_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: workspaces workspaces_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

