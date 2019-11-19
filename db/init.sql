--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

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

SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    acct character varying(64) NOT NULL,
    favorability integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: form; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.form (
    id smallint NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.form OWNER TO postgres;

--
-- Name: form_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.form_id_seq OWNER TO postgres;

--
-- Name: form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.form_id_seq OWNED BY public.form.id;


--
-- Name: quote; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.quote OWNER TO postgres;

--
-- Name: quote_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_id_seq OWNER TO postgres;

--
-- Name: quote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quote_id_seq OWNED BY public.quote.id;


--
-- Name: series; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.series (
    id smallint NOT NULL,
    name character varying(256) NOT NULL
);


ALTER TABLE public.series OWNER TO postgres;

--
-- Name: series_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.series_id_seq OWNER TO postgres;

--
-- Name: series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.series_id_seq OWNED BY public.series.id;


--
-- Name: track; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.track (
    id integer NOT NULL,
    title text,
    url text,
    makoto boolean DEFAULT false NOT NULL
);


ALTER TABLE public.track OWNER TO postgres;

--
-- Name: track_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.track_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.track_id_seq OWNER TO postgres;

--
-- Name: track_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.track_id_seq OWNED BY public.track.id;


--
-- Name: form id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form ALTER COLUMN id SET DEFAULT nextval('public.form_id_seq'::regclass);


--
-- Name: quote id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quote ALTER COLUMN id SET DEFAULT nextval('public.quote_id_seq'::regclass);


--
-- Name: series id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.series ALTER COLUMN id SET DEFAULT nextval('public.series_id_seq'::regclass);


--
-- Name: track id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.track ALTER COLUMN id SET DEFAULT nextval('public.track_id_seq'::regclass);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (acct);


--
-- Name: form form_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form
    ADD CONSTRAINT form_pkey PRIMARY KEY (id);


--
-- Name: quote quote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quote
    ADD CONSTRAINT quote_pkey PRIMARY KEY (id);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: track track_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.track
    ADD CONSTRAINT track_pkey PRIMARY KEY (id);


--
-- Name: form_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX form_name_idx ON public.form USING btree (name);


--
-- Name: series_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX series_name_idx ON public.series USING btree (name);


--
-- Name: track_title_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX track_title_idx ON public.track USING btree (title);


--
-- Name: track_url_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX track_url_idx ON public.track USING btree (url);


--
-- Name: quote quote_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quote
    ADD CONSTRAINT quote_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.form(id) ON DELETE CASCADE;


--
-- Name: quote quote_serias_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quote
    ADD CONSTRAINT quote_serias_id_fkey FOREIGN KEY (series_id) REFERENCES public.series(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

