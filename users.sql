--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: users; Type: TABLE; Schema: public; Owner: volant; Tablespace: 
--

CREATE TABLE users (
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


ALTER TABLE public.users OWNER TO volant;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: volant
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO volant;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: volant
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: volant
--

SELECT pg_catalog.setval('users_id_seq', 2123512908, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: volant
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: volant
--

COPY users (id, login, email, crypted_password, salt, created_at, updated_at, remember_token, remember_token_expires_at, firstname, lastname, locale) FROM stdin;
2123512906	Nikola	evs@inexsda.cz	c5e4ee839d3cbea0cff0603a7bc1edf92be6b01c	ce5b066c882c2f2e4927c1e347feb2fd6930aac8	2014-05-30 07:53:26.704903	2014-05-30 07:53:26.704903	\N	\N	Nikola	Zdraveski	en
2123512890	inex_web_user	none	88ac1d97861267e0ec4898035b247d03f713cffe	9b033653fc60b6782e8cf012b148f19d3cba8004	2009-03-11 09:41:48	2009-03-11 09:41:48	\N	\N	inex_web_user	\N	en
2123512891	RadkaN	outgoing@inexsda.cz	5c49feb6e6098a337a77de8d5bfe3c9eeba347bc	0e4cb5bb42b2ebcbda1a03078d140eb861ecacd8	2009-03-12 08:20:07.35713	2014-06-12 14:05:21.709969	\N	\N	Radka	Nováková	cz
1447349829	kuba	jakub.hozak@gmail.com	350177a2e89918202d27c045194ebd15a6a180d3	c56e5dc2936b42775e7b05340416cfd2be93a364	2009-03-11 09:41:48	2013-03-06 16:03:38.005262	\N	\N	kuba	\N	cz
2123512895	jana	info@inexsda.cz	9291d6ebfdc0fb63ec777a4f761ae2182e40d915	d23ae70d64825a44ac07e5aedc43f519b9f6c17c	2010-03-16 08:39:57.883859	2013-03-06 16:03:38.139749	\N	\N	Jana	Konasova	cz
2123512899	matous	matous@platanus.cz	1473ef5270a6776bc2d8d046b446e066ce17ee53	bb9c1f23171b70472aa8d8c0c21a07b3df2f1f18	2012-03-14 11:46:38.119039	2013-03-06 16:03:38.146994	\N	\N	matous	borak	cz
2123512905	admin	workcamp@inexsda.cz	0a42f3e995541200af90745687a2946125d13c99	913123fe119275117de85f1a417434539bfefb64	2014-03-17 19:41:52.784854	2014-09-23 12:22:36.73163	\N	\N	\N	\N	en
2123512896	Zuzka	zuzana_daneckova@hotmail.com	4b178249dca977bc5b6af1c0acf568f8b2237c6e	1e9ade7395ff238ce386cf15c5710a972cebad84	2010-05-12 13:38:40.810156	2013-03-06 16:03:38.149905	\N	\N	Zuzka	Daněčková	cz
2123512908	martina	outgoing@inexsda.cz	c0c4b6960a1e39bb63db318af111e7e9e50a632a	66378a590db4aa0099965b7d8d806af763646a53	2015-01-06 07:54:23.401426	2015-01-06 07:54:38.525734	\N	\N	Martina	Renková	cz
2123512907	eva	outgoing@inexsda.cz	a61dce2e00310f72c47959889a859cab93b36aef	111e373c7cf1a6edcf18cfacbb489f134a7a5d2e	2014-09-02 14:23:24.376241	2015-01-06 10:37:50.784277	\N	\N	Eva	Mackova	cz
2123512900	Renata	projekty.cr@inexsda.cz	7f316543efa9215340632f914ccd2e5dd309ed74	29d72541c42808b850e63a64767cad7e5fb626b9	2014-01-28 12:42:29.270732	2014-02-03 14:11:03.230622	\N	\N	Renata	Lupačová	cz
2123512902	Frantisek	moskyt@rozhled.cz	d371c7341fff42841d3d3a7f3afccf36459b32d7	b313c4e0ecdec5391d440e460cabc68deb909622	2014-02-25 22:52:06.964864	2014-02-25 22:52:06.964864	\N	\N	František	Havlůj	en
2123512903	Delina	incoming@inexsda.cz	e4961e9d77d34b0506345a0849abde076dcb1a1d	6ed823a82cd7fa929bd1222fb3810e618a2863a1	2014-03-11 16:12:56.238509	2014-03-11 16:12:56.238509	\N	\N	Delina	\N	en
2123512901	Radka	radkapeterova@gmail.com	9a0e21fd33a3cf7fc4ad8d3191eee09b69a40e9a	5d1f76f053da9e9f6b1b6ef1d83cf6fe10fe0e5e	2014-02-25 18:24:00.550424	2014-03-17 19:21:14.268953	\N	\N	Radka	\N	en
\.


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: volant; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

