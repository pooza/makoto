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

--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account (acct, "like") FROM stdin;
\.


--
-- Data for Name: form; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.form (id, name) FROM stdin;
\.


--
-- Data for Name: series; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.series (id, name) FROM stdin;
\.


--
-- Data for Name: quote; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quote (id, serias_id, form_id, episode, emotion, exclude, exclude_respond, priority, quote, remark) FROM stdin;
\.


--
-- Data for Name: track; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.track (id, title, url, makoto) FROM stdin;
\.


--
-- Name: form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.form_id_seq', 1, false);


--
-- Name: quote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quote_id_seq', 1, false);


--
-- Name: series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.series_id_seq', 1, false);


--
-- Name: track_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.track_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

