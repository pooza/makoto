--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.account (
    id integer NOT NULL,
    acct character varying(64) NOT NULL,
    favorability integer DEFAULT 0 NOT NULL,
    nickname character varying(64)
);


ALTER TABLE public.account OWNER TO makoto;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_id_seq OWNER TO makoto;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;


--
-- Name: fairy; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.fairy (
    id integer NOT NULL,
    name text NOT NULL,
    human_name text,
    suffix text
);


ALTER TABLE public.fairy OWNER TO makoto;

--
-- Name: fairy_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.fairy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fairy_id_seq OWNER TO makoto;

--
-- Name: fairy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.fairy_id_seq OWNED BY public.fairy.id;


--
-- Name: form; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.form (
    id smallint NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.form OWNER TO makoto;

--
-- Name: form_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.form_id_seq OWNER TO makoto;

--
-- Name: form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.form_id_seq OWNED BY public.form.id;


--
-- Name: keyword; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.keyword (
    id integer NOT NULL,
    type character varying(64),
    word character varying(64)
);


ALTER TABLE public.keyword OWNER TO makoto;

--
-- Name: keyword_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.keyword_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.keyword_id_seq OWNER TO makoto;

--
-- Name: keyword_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.keyword_id_seq OWNED BY public.keyword.id;


--
-- Name: message; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.message (
    id integer NOT NULL,
    type character varying(64) NOT NULL,
    feature character varying(64),
    message text NOT NULL,
    month smallint,
    day smallint,
    data json
);


ALTER TABLE public.message OWNER TO makoto;

--
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_id_seq OWNER TO makoto;

--
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.message_id_seq OWNED BY public.message.id;


--
-- Name: past_keyword; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.past_keyword (
    id integer NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    surface character varying(64) NOT NULL,
    feature character varying(16)
);


ALTER TABLE public.past_keyword OWNER TO makoto;

--
-- Name: past_keyword_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.past_keyword_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.past_keyword_id_seq OWNER TO makoto;

--
-- Name: past_keyword_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.past_keyword_id_seq OWNED BY public.past_keyword.id;


--
-- Name: quote; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.quote (
    id integer NOT NULL,
    series_id smallint NOT NULL,
    form_id smallint NOT NULL,
    episode smallint,
    emotion character varying(16),
    exclude boolean DEFAULT false NOT NULL,
    exclude_respond boolean DEFAULT false NOT NULL,
    priority smallint DEFAULT '3'::smallint NOT NULL,
    body text NOT NULL,
    remark text
);


ALTER TABLE public.quote OWNER TO makoto;

--
-- Name: quote_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.quote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_id_seq OWNER TO makoto;

--
-- Name: quote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.quote_id_seq OWNED BY public.quote.id;


--
-- Name: series; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.series (
    id smallint NOT NULL,
    name character varying(256) NOT NULL
);


ALTER TABLE public.series OWNER TO makoto;

--
-- Name: series_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.series_id_seq OWNER TO makoto;

--
-- Name: series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.series_id_seq OWNED BY public.series.id;


--
-- Name: track; Type: TABLE; Schema: public; Owner: makoto
--

CREATE TABLE public.track (
    id integer NOT NULL,
    title text,
    url text,
    makoto boolean DEFAULT false NOT NULL,
    intro text
);


ALTER TABLE public.track OWNER TO makoto;

--
-- Name: track_id_seq; Type: SEQUENCE; Schema: public; Owner: makoto
--

CREATE SEQUENCE public.track_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.track_id_seq OWNER TO makoto;

--
-- Name: track_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: makoto
--

ALTER SEQUENCE public.track_id_seq OWNED BY public.track.id;


--
-- Name: account id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);


--
-- Name: fairy id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.fairy ALTER COLUMN id SET DEFAULT nextval('public.fairy_id_seq'::regclass);


--
-- Name: form id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.form ALTER COLUMN id SET DEFAULT nextval('public.form_id_seq'::regclass);


--
-- Name: keyword id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.keyword ALTER COLUMN id SET DEFAULT nextval('public.keyword_id_seq'::regclass);


--
-- Name: message id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.message ALTER COLUMN id SET DEFAULT nextval('public.message_id_seq'::regclass);


--
-- Name: past_keyword id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.past_keyword ALTER COLUMN id SET DEFAULT nextval('public.past_keyword_id_seq'::regclass);


--
-- Name: quote id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.quote ALTER COLUMN id SET DEFAULT nextval('public.quote_id_seq'::regclass);


--
-- Name: series id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.series ALTER COLUMN id SET DEFAULT nextval('public.series_id_seq'::regclass);


--
-- Name: track id; Type: DEFAULT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.track ALTER COLUMN id SET DEFAULT nextval('public.track_id_seq'::regclass);


--
-- Name: account account_acct_key; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_acct_key UNIQUE (acct);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: fairy fairy_name_key; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.fairy
    ADD CONSTRAINT fairy_name_key UNIQUE (name);


--
-- Name: fairy fairy_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.fairy
    ADD CONSTRAINT fairy_pkey PRIMARY KEY (id);


--
-- Name: form form_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.form
    ADD CONSTRAINT form_pkey PRIMARY KEY (id);


--
-- Name: keyword keyword_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.keyword
    ADD CONSTRAINT keyword_pkey PRIMARY KEY (id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: past_keyword past_keyword_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.past_keyword
    ADD CONSTRAINT past_keyword_pkey PRIMARY KEY (id);


--
-- Name: quote quote_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.quote
    ADD CONSTRAINT quote_pkey PRIMARY KEY (id);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: track track_pkey; Type: CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.track
    ADD CONSTRAINT track_pkey PRIMARY KEY (id);


--
-- Name: form_name_idx; Type: INDEX; Schema: public; Owner: makoto
--

CREATE UNIQUE INDEX form_name_idx ON public.form USING btree (name);


--
-- Name: keyword_type_word_idx; Type: INDEX; Schema: public; Owner: makoto
--

CREATE UNIQUE INDEX keyword_type_word_idx ON public.keyword USING btree (type, word);


--
-- Name: message_feature_idx; Type: INDEX; Schema: public; Owner: makoto
--

CREATE INDEX message_feature_idx ON public.message USING btree (feature);


--
-- Name: message_type_idx; Type: INDEX; Schema: public; Owner: makoto
--

CREATE INDEX message_type_idx ON public.message USING btree (type);


--
-- Name: series_name_idx; Type: INDEX; Schema: public; Owner: makoto
--

CREATE UNIQUE INDEX series_name_idx ON public.series USING btree (name);


--
-- Name: track_url_idx; Type: INDEX; Schema: public; Owner: makoto
--

CREATE UNIQUE INDEX track_url_idx ON public.track USING btree (url);


--
-- Name: past_keyword past_keyword_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.past_keyword
    ADD CONSTRAINT past_keyword_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id) ON DELETE CASCADE;


--
-- Name: quote quote_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.quote
    ADD CONSTRAINT quote_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.form(id) ON DELETE CASCADE;


--
-- Name: quote quote_serias_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: makoto
--

ALTER TABLE ONLY public.quote
    ADD CONSTRAINT quote_serias_id_fkey FOREIGN KEY (series_id) REFERENCES public.series(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

