--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 16.0

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
-- Name: byroyalty(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.byroyalty(IN p_percentage integer, OUT cur refcursor)
    LANGUAGE plpgsql
    AS $$
BEGIN
open cur for select au_id from titleauthor
where titleauthor.royaltyper = p_percentage;


END;
$$;


ALTER PROCEDURE public.byroyalty(IN p_percentage integer, OUT cur refcursor) OWNER TO postgres;

--
-- Name: reptq1(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.reptq1(OUT cur refcursor)
    LANGUAGE plpgsql
    AS $$
BEGIN
open cur for select
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id,
	avg(price) as avg_price
from titles
where price is NOT NULL
group by pub_id 
order by pub_id;
END;
$$;


ALTER PROCEDURE public.reptq1(OUT cur refcursor) OWNER TO postgres;

--
-- Name: reptq2(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.reptq2(OUT cur refcursor)
    LANGUAGE plpgsql
    AS $$
BEGIN
open cur for select
	case when grouping(type) = 1 then 'ALL' else type end as type,
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id,
	avg(ytd_sales) as avg_ytd_sales
from titles
where pub_id is NOT NULL
group by pub_id ;


END;
$$;


ALTER PROCEDURE public.reptq2(OUT cur refcursor) OWNER TO postgres;

--
-- Name: reptq3(money, money, character); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.reptq3(IN p_lolimit money, IN p_hilimit money, IN p_type character, OUT cur refcursor)
    LANGUAGE plpgsql
    AS $$
BEGIN
open cur for select
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id,
	case when grouping(type) = 1 then 'ALL' else type end as type,
	count(title_id) as cnt
from titles
where price >p_lolimit AND price <p_hilimit AND type = p_type OR type LIKE '%cook%'
group by pub_id ;


END;
$$;


ALTER PROCEDURE public.reptq3(IN p_lolimit money, IN p_hilimit money, IN p_type character, OUT cur refcursor) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Query; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Query" (
    au_id character varying NOT NULL,
    au_lname character varying NOT NULL,
    au_fname character varying NOT NULL,
    phone character(1) NOT NULL,
    address character varying,
    city character varying,
    state character(1),
    zip character(1),
    contract boolean NOT NULL
);


ALTER TABLE public."Query" OWNER TO postgres;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    au_id character varying NOT NULL,
    au_lname character varying NOT NULL,
    au_fname character varying NOT NULL,
    phone character varying NOT NULL,
    address character varying,
    city character varying,
    state character varying,
    zip character varying,
    contract smallint NOT NULL
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- Name: authors_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors_test (
    au_id character varying NOT NULL,
    au_lname character varying NOT NULL,
    au_fname character varying NOT NULL,
    phone character varying NOT NULL,
    address character varying,
    city character varying,
    state character varying,
    zip character varying,
    contract boolean NOT NULL
);


ALTER TABLE public.authors_test OWNER TO postgres;

--
-- Name: discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts (
    discounttype character varying NOT NULL,
    stor_id character varying,
    lowqty smallint NOT NULL,
    highqty smallint NOT NULL,
    discount numeric NOT NULL
);


ALTER TABLE public.discounts OWNER TO postgres;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    emp_id character varying NOT NULL,
    fname character varying NOT NULL,
    minit character varying,
    lname character varying NOT NULL,
    job_id smallint NOT NULL,
    job_lvl smallint,
    pub_id character varying NOT NULL,
    hire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    job_id smallint NOT NULL,
    job_desc character varying NOT NULL,
    min_lvl smallint NOT NULL,
    max_lvl smallint NOT NULL
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: pub_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pub_info (
    pub_id character varying NOT NULL,
    logo bytea,
    pr_info text
);


ALTER TABLE public.pub_info OWNER TO postgres;

--
-- Name: publishers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishers (
    pub_id character varying NOT NULL,
    pub_name character varying,
    city character varying,
    state character varying,
    country character varying
);


ALTER TABLE public.publishers OWNER TO postgres;

--
-- Name: roysched; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roysched (
    title_id character varying NOT NULL,
    lorange integer,
    hirange integer,
    royalty integer
);


ALTER TABLE public.roysched OWNER TO postgres;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    stor_id character varying NOT NULL,
    ord_num character varying NOT NULL,
    ord_date timestamp with time zone NOT NULL,
    qty smallint NOT NULL,
    payterms character varying NOT NULL,
    title_id character varying NOT NULL
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stores (
    stor_id character varying NOT NULL,
    stor_name character varying,
    stor_address character varying,
    city character varying,
    state character varying,
    zip character varying
);


ALTER TABLE public.stores OWNER TO postgres;

--
-- Name: titleauthor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.titleauthor (
    au_id character varying NOT NULL,
    title_id character varying NOT NULL,
    au_ord smallint,
    royaltyper integer
);


ALTER TABLE public.titleauthor OWNER TO postgres;

--
-- Name: titles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.titles (
    title_id character varying NOT NULL,
    title character varying NOT NULL,
    type character varying NOT NULL,
    pub_id character varying,
    price numeric,
    advance numeric,
    royalty integer,
    ytd_sales integer,
    notes character varying,
    pubdate timestamp with time zone NOT NULL
);


ALTER TABLE public.titles OWNER TO postgres;

--
-- Name: titleview; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.titleview (
    title character varying NOT NULL,
    au_ord smallint,
    au_lname character varying NOT NULL,
    price numeric,
    ytd_sales integer,
    pub_id character varying
);


ALTER TABLE public.titleview OWNER TO postgres;

--
-- Data for Name: Query; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Query" (au_id, au_lname, au_fname, phone, address, city, state, zip, contract) FROM stdin;
\.


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (au_id, au_lname, au_fname, phone, address, city, state, zip, contract) FROM stdin;
172-32-1176	White	Johnson	408 496-7223	10932 Bigge Rd.	Menlo Park	CA	94025	1
213-46-8915	Green	Marjorie	415 986-7020	309 63rd St. #411	Oakland	CA	94618	1
238-95-7766	Carson	Cheryl	415 548-7723	589 Darwin Ln.	Berkeley	CA	94705	1
267-41-2394	O'Leary	Michael	408 286-2428	22 Cleveland Av. #14	San Jose	CA	95128	1
274-80-9391	Straight	Dean	415 834-2919	5420 College Av.	Oakland	CA	94609	1
341-22-1782	Smith	Meander	913 843-0462	10 Mississippi Dr.	Lawrence	KS	66044	0
409-56-7008	Bennet	Abraham	415 658-9932	6223 Bateman St.	Berkeley	CA	94705	1
427-17-2319	Dull	Ann	415 836-7128	3410 Blonde St.	Palo Alto	CA	94301	1
472-27-2349	Gringlesby	Burt	707 938-6445	PO Box 792	Covelo	CA	95428	1
486-29-1786	Locksley	Charlene	415 585-4620	18 Broadway Av.	San Francisco	CA	94130	1
527-72-3246	Greene	Morningstar	615 297-2723	22 Graybar House Rd.	Nashville	TN	37215	0
648-92-1872	Blotchet-Halls	Reginald	503 745-6402	55 Hillsdale Bl.	Corvallis	OR	97330	1
672-71-3249	Yokomoto	Akiko	415 935-4228	3 Silver Ct.	Walnut Creek	CA	94595	1
712-45-1867	del Castillo	Innes	615 996-8275	2286 Cram Pl. #86	Ann Arbor	MI	48105	1
722-51-5454	DeFrance	Michel	219 547-9982	3 Balding Pl.	Gary	IN	46403	1
724-08-9931	Stringer	Dirk	415 843-2991	5420 Telegraph Av.	Oakland	CA	94609	0
724-80-9391	MacFeather	Stearns	415 354-7128	44 Upland Hts.	Oakland	CA	94612	1
756-30-7391	Karsen	Livia	415 534-9219	5720 McAuley St.	Oakland	CA	94609	1
807-91-6654	Panteley	Sylvia	301 946-8853	1956 Arlington Pl.	Rockville	MD	20853	1
846-92-7186	Hunter	Sheryl	415 836-7128	3410 Blonde St.	Palo Alto	CA	94301	1
893-72-1158	McBadden	Heather	707 448-4982	301 Putnam	Vacaville	CA	95688	0
899-46-2035	Ringer	Anne	801 826-0752	67 Seventh Av.	Salt Lake City	UT	84152	1
998-72-3567	Ringer	Albert	801 826-0752	67 Seventh Av.	Salt Lake City	UT	84152	1
\.


--
-- Data for Name: authors_test; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors_test (au_id, au_lname, au_fname, phone, address, city, state, zip, contract) FROM stdin;
\.


--
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discounts (discounttype, stor_id, lowqty, highqty, discount) FROM stdin;
Initial Customer	\N	0	0	10.50
Volume Discount	\N	100	1000	6.70
Customer Discount	8042	0	0	5.00
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (emp_id, fname, minit, lname, job_id, job_lvl, pub_id, hire_date) FROM stdin;
PMA42628M	Paolo	M	Accorti	13	35	0877	1992-08-27 00:00:00+00
PSA89086M	Pedro	S	Afonso	14	89	1389	1990-12-24 00:00:00+00
VPA30890F	Victoria	P	Ashworth	6	140	0877	1990-09-13 00:00:00+00
H-B39728F	Helen	 	Bennett	12	35	0877	1989-09-21 00:00:00+00
L-B31947F	Lesley	 	Brown	7	120	0877	1991-02-13 00:00:00+00
F-C16315M	Francisco	 	Chang	4	227	9952	1990-11-03 00:00:00+00
PTC11962M	Philip	T	Cramer	2	215	9952	1989-11-11 00:00:00+00
A-C71970F	Aria	 	Cruz	10	87	1389	1991-10-26 00:00:00+00
AMD15433F	Ann	M	Devon	3	200	9952	1991-07-16 00:00:00+00
ARD36773F	Anabela	R	Domingues	8	100	0877	1993-01-27 00:00:00+00
PHF38899M	Peter	H	Franken	10	75	0877	1992-05-17 00:00:00+00
PXH22250M	Paul	X	Henriot	5	159	0877	1993-08-19 00:00:00+00
CFH28514M	Carlos	F	Hernadez	5	211	9999	1989-04-21 00:00:00+00
PDI47470M	Palle	D	Ibsen	7	195	0736	1993-05-09 00:00:00+00
KJJ92907F	Karla	J	Jablonski	9	170	9999	1994-03-11 00:00:00+00
KFJ64308F	Karin	F	Josephs	14	100	0736	1992-10-17 00:00:00+00
MGK44605M	Matti	G	Karttunen	6	220	0736	1994-05-01 00:00:00+00
POK93028M	Pirkko	O	Koskitalo	10	80	9999	1993-11-29 00:00:00+00
JYL26161F	Janine	Y	Labrune	5	172	9901	1991-05-26 00:00:00+00
M-L67958F	Maria	 	Larsson	7	135	1389	1992-03-27 00:00:00+00
Y-L77953M	Yoshi	 	Latimer	12	32	1389	1989-06-11 00:00:00+00
LAL21447M	Laurence	A	Lebihan	5	175	0736	1990-06-03 00:00:00+00
ENL44273F	Elizabeth	N	Lincoln	14	35	0877	1990-07-24 00:00:00+00
PCM98509F	Patricia	C	McKenna	11	150	9999	1989-08-01 00:00:00+00
R-M53550M	Roland	 	Mendel	11	150	0736	1991-09-05 00:00:00+00
RBM23061F	Rita	B	Muller	5	198	1622	1993-10-09 00:00:00+00
HAN90777M	Helvetius	A	Nagy	7	120	9999	1993-03-19 00:00:00+00
TPO55093M	Timothy	P	O'Rourke	13	100	0736	1988-06-19 00:00:00+00
SKO22412M	Sven	K	Ottlieb	5	150	1389	1991-04-05 00:00:00+00
MAP77183M	Miguel	A	Paolino	11	112	1389	1992-12-07 00:00:00+00
PSP68661F	Paula	S	Parente	8	125	1389	1994-01-19 00:00:00+00
M-P91209M	Manuel	 	Pereira	8	101	9999	1989-01-09 00:00:00+00
MJP25939M	Maria	J	Pontes	5	246	1756	1989-03-01 00:00:00+00
M-R38834F	Martine	 	Rance	9	75	0877	1992-02-05 00:00:00+00
DWR65030M	Diego	W	Roel	6	192	1389	1991-12-16 00:00:00+00
A-R89858F	Annette	 	Roulet	6	152	9999	1990-02-21 00:00:00+00
MMS49649F	Mary	M	Saveley	8	175	0736	1993-06-29 00:00:00+00
CGS88322F	Carine	G	Schmitt	13	64	1389	1992-07-07 00:00:00+00
MAS70474F	Margaret	A	Smith	9	78	1389	1988-09-29 00:00:00+00
HAS54740M	Howard	A	Snyder	12	100	0736	1988-11-19 00:00:00+00
MFS52347M	Martin	F	Sommer	10	165	0736	1990-04-13 00:00:00+00
GHT50241M	Gary	H	Thomas	9	170	0736	1988-08-09 00:00:00+00
DBT39435M	Daniel	B	Tonini	11	75	0877	1990-01-01 00:00:00+00
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (job_id, job_desc, min_lvl, max_lvl) FROM stdin;
1	New Hire - Job not specified	10	10
2	Chief Executive Officer	200	250
3	Business Operations Manager	175	225
4	Chief Financial Officier	175	250
5	Publisher	150	250
6	Managing Editor	140	225
7	Marketing Manager	120	200
8	Public Relations Manager	100	175
9	Acquisitions Manager	75	175
10	Productions Manager	75	165
11	Operations Manager	75	150
12	Editor	25	100
13	Sales Representative	25	100
14	Designer	25	100
\.


--
-- Data for Name: pub_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pub_info (pub_id, logo, pr_info) FROM stdin;
0736	\\x474946383961d3001f00b30f00000000800000008000808000000080800080008080808080c0c0c0ff000000ff00ffff000000ffff00ff00ffffffffff21f9040100000f002c00000000d3001f004004fff0c949abbd38ebcdbbff60288e245001686792236abab03bc5b055b3f843d3b99de2ab532a36fb15253b19e5a6231a934ca18cb75c1191d69bf62aad467f5cf036d8243791369f516adef9304af8f30a3563d7e54cfc04bf24377b5d697e6451333d8821757f898d8e8f1f76657877907259755e5493962081798d9f8a846d9b4a929385a7a5458ca0777362acaf585e6c6a84ad429555baa9a471a89d8e8ba2c3c7c82dc9c8aecbcecf1ec2d09143a66e80d3d9bc2c41d76ad28fb2cd509adaa9aac62594a3df81c65fe0bdb5b0cdf4e276def6dd78ef6b86fa6c82c5a2648a54ab6aaae4c1027864de392e3af4582bf582dfc07d9244ada2480bd4c6767bff32ae0bf3ef603b3907490a4427ce21a7330a6d0584b810664d7f383fa25932488fb96d0f37bdf9491448d1a348937a52cab4a9d3784ef5e58b4a5545d54bc568fabc9a68dd526ed0a6b8aa17331bd91e5ad9d1d390ced23d88f54a3acb0a955addad9a50b50d87296e3eb9c76a7cdaabc86b2460040df34d3995515ab9ff125f1afa0dab20a0972382ccb9f9e5aebc368b21eedb66eda15f1347be2dfdebb44a7b7c6889240d9473eb73322f4e8d8dbbe14d960b6519bce5724bb95789350e97ea4bf3718cdd64068d751a261d8b1539d6dcde3c37f68e1fb58e5dced8a44477537049852efd253cee38c973b7e9d97a488c2979fb936fbaff2cf5cb79e35830400c31860f4a9be925d4439f81b6a073bef1575f593c01a25b26127255d45d4a45b65b851a36c56154678568a20e1100003b	This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.\n\nThis is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston, Massachusetts.
0877	\\x4749463839618b002f00b30f00000000800000008000808000000080800080008080808080c0c0c0ff000000ff00ffff000000ffff00ff00ffffffffff21f9040100000f002c000000008b002f004004fff0c949abbd38ebcdbbffa0048464089ce384a62bd596309cc6f4f58a287eba79ed73b3d26a482c1a8fc8a47249fccd76bc1f3058d94135579c9345053d835768560cfe6a555d343a1b6d3fc6dc2a377e66dba5f8dbebf6eee1ff2a805b463a47828269871f7a3d7c7c8a3e899093947f666a756567996e6c519e167692646e7d9c98a42295abac24a092ad364c737eb15eb61b8e8db58fb81db0be8c6470a0be58c618bac365c5c836cea1bcbbc4c0d0aad6d14c85cdd86fdddfab5f43a580dcb519a25b9bae989bc3eea9a7ebd9bf54619a7df8bba87475eda770d6c58b968c59a27402fb99e2378fc7187010d5558948b15cc58b4e20ce9a762e62b558cab86839fc088d24ab90854662bcd60d653e832bbd7924f49226469327fdec91c6ad2538972e6ffee429720d4e63472901251a33a9d28db47a5a731a7325d56d50b36addaa2463d5af1eae82f5f84faa946656aa21ac31d0c4bf85cba87912d6d194d4b535c5dddba93221cb226d022e9437d89c594305fd321c0cb7dfa5c58223036e088f3139b9032563dd0be66d2acd8b2bcb9283cedee3c6a53ee39ba7579a62c1294917dc473035e0b9e3183f9a3bb6f7abde608b018800003b	This is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.\n\nThis is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.\n\nThis is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.\n\nThis is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.\n\nThis is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington, D.C.
1389	\\x474946383961c2001d00b30f00000000800000008000808000000080800080008080808080c0c0c0ff000000ff00ffff000000ffff00ff00ffffffffff21f9040100000f002c00000000c2001d004004fff0c949abbd38ebcdbbff60288e1c609e2840ae2c969e6d2ccfb339d90f2ce1f8aee6bc9fef26ec01413aa3f2d76baa96c7a154ea7cc29c449ac7a8ed7a2fdc2fed25149b29e4d479fd55a7cbd931dc35cfa4916171befdaabc51546541684c8285847151537f898a588d89806045947491757b6c9a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a95a6a3e64169923b0901a775b7566b25d7f8c888a5150be7b8f93847d8dc3c07983bebdc1878bcfaf6f44bbd0ad71c9cbd653bfd5cec7d1c3dfdb8197d8959cb9aab8b7ebeeeff0ba92f1b6b5f4a0f6f776d3fa9ebcfd748c01dcb4ab5dbf7c03cf1454070f61423d491c326ba18e211081250c7ab12867619825f37f2ece1168ac242b6a274556d121d28fa46c11e78564c5b295308f21bbf5cad6cce52c7018813932c4ed5c517346b7c1c2683368349d49a19d0439d31538a452a916135a0b19a59aab9e6a835a0eabd00e5cd11d1d478c1c59714053aa4c4955ab4b9956879ab497f62e1cba2373da25b752239f8787119390ab5806c74e1100003b	This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.\n\nThis is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley, California.
1622	\\x474946383961f5003400b30f00000000800000008000808000000080800080008080808080c0c0c0ff000000ff00ffff000000ffff00ff00ffffffffff21f9040100000f002c00000000f50034004004fff0c949abbd38ebcdbbff60288e64d90166aa016cebbeb02acf746d67e82dc2aceeffc0a02997b31027c521ef25698d8e42230e049d3e8ad8537385bc4179db6b574c26637be58bf38a1eb393df2ce55ca52731f77918be9fafcd6180817f697f5f6e6c7a836d62876a817a79898a7e31524d708e7299159c9456929f9044777c6575a563a68e827d9d4c8d334bb3b051b6b7b83a8490b91eb4b3bdc1c251a1c24bc3c8c9c8c5c4bfcccad0d135acc36b2e3bbcb655ad1cdb8f6921deb8d48aa9ada46046d7e0dc829b9d98e9988878d9aae5aef875bc6deff7e7a35c9943f18cca3175c0a4295c48625f3b8610234a0c17d159c289189515cc7531a3c7891bff9b59fa4812634820f24aaa94882ea50d8bbb3e8813598b8a3d7c0d6f12cb8710e5ba7536d9ed3c458f8b509cf17ce94cea658f254d944889528306e83c245089629dda4f8bd65885049acbb7adab2a5364afdaf344902752409a6085fa39105ebb3c2dab2e52fa8611b7acfa060956cb1370598176db3e74fb956ccca77207bb6b8caaaadea3ffbe01a48cd871d65569c37e25a458c5c9572e57aade59f7f40a98b456cb36560f730967b3737b74adbbb7efdabf830be70b11f6c8e1c82f31345e33b9f3a5c698fb7d4e9d779083d4b313d7985abb77e0c9b07f1f0f3efa71f2e8ed56eb98bebd7559306fc72c6995ea7499f3b5dda403ff17538ab6fd20c9ff7d463d531681971888e0104e45069d7c742d58db7b29b45454811b381420635135b5d838d6e487612f876d98d984b73d2820877dfd871523f5e161d97dd7fcb4c82e31bec8176856d9d8487d95e1e5d711401ae2448ef11074e47e9d69359382e8a8871391880c28e5861636399950fefca55e315d8279255c2c6aa89899b68588961c5b82c366693359f1ca89acacb959971d76f6e6607b6e410e9d57b1a9196a52bdd56636cc08ba519c5e1eda8743688906da9d53f2e367999656a96292e2781397a6264e62a04e25fe49a59354696958409b11f527639deac84e7795553a9aaca85c68e8977d2a7919a5a7f83329a46f0d79698bf60d98688ccc118a6c3f8f38e6d89c8c12f635e49145f6132d69dcce684725fc0546c3b40875d79e70a5867a8274e69e8baeac1feec02e92ee3aa7ada015365befbe83f2eb6f351100003b	This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.\n\nThis is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago, Illinois.
1756	\\x474946383961e3002500b30f00000000800000008000808000000080800080008080808080c0c0c0ff000000ff00ffff000000ffff00ff00ffffffffff21f9040100000f002c00000000e30025004004fff0c949abbd38ebcdbbff60288e240858e705a4d2ea4e6e0cc7324dd1eb9cdbbafce1ac878de7abbd84476452c963369f2f288e933a595b404db27834e67a5fec37acec517d4eb24e5c8d069966361a5e8ed3c3dca5aa54b9b2ae2d423082817f848286898386858754887b8a8d939094947e918b7d8780959e9d817c18986fa2a6a75a7b22a59b378e1dacaeb18f1940b6a8b8a853727ab5bd4e76676a37bfb9af2a564d6bc0776e635bce6dcfd2c3c873716879d4746c6053da76e0dab3a133d6d5b290929f9ceaedeb6fa0c435ef9e97f59896ec28eefa9dff69a21c1bb4ca1e3e63084db42b970fd6407d05c9e59298b0a2c58b18337aa0e88da3468dc3ffd0692187a7982f5f2271b152162de54795ceb0f0daf8ebda2a932f1ff203b38c484b6ed07674194acd639679424b4edb36279b4d3852fe1095266743955138c5209ada6d5cb26dcdfc644dd351eacf804bcd32421a562db6965f25aadd11b056bd7ba436c903e82a1d4a3d024769bae777b0bb7887f51a0e022e9589bcfce0dd6527597223c4917502acbcf8d5e6c49f0b6fa60751a7c2748a3ee7dd6b70b5628f9a5873c6db5936e57eb843c726043b95ebde394f3584ec7096ed8da60d86001ebcb9f3e72f99439f0e7dec7297ba84d9924efdb11a65566b8efb510c7cc258dbb7779f7834a9756e6c97d114f95e5429f13ce5f7f9aaf51c996928604710ff544afdc79717c10cd85157c6edd75f7eb49c81d45c5ea9674e5bbba065941bfb45f3d62d5e99e11488516568a15d1292255f635e8045e0520f3e15a0798db5c5a08105ee52e3884c05255778e6f5c4a287ccb4d84d1d41ce08cd913c56656482eaede8e38d71b974553c199ec324573c3669237c585588e52d1ace049f85521648659556cd83445d27c9f4d68501ce580e31748ed4948c0e3e88959b257c87e39d0a8ec5d812559234996a9ee5b6e864fe31ba5262971de40fa5b75d9a487a9a79975c6ab5dd06ea6cca9db94fa6a1568ad8a4c33dba6a5995ee5450ac0aa24a9c6dbae9f6883cb48976d0aba8d90aa9a88d6246c2aba3fe8a1b43ca229b9c58afc11e071ab1d1be366db5c9ae85dca48595466b83ac95c61da60d1146eeb3bb817ada40a08cfbdbb2eb9972eb6edb66d26d71768d5b2b1fefc65b11afa5fa96c93af50aa6afbefe263c1dc0fca2ab8ac210472c310a1100003b	This is sample text data for Ramona Publishers, publisher 1756 in the pubs database. Ramona Publishers is located in Dallas, Texas.
9901	\\x4749463839615d002200b30f00000000800000008000808000000080800080008080808080c0c0c0ff000000ff00ffff000000ffff00ff00ffffffffff21f9040100000f002c000000005d0022004004fff0c949abbd38ebcdfb03df078c249895a386aa68bb9e6e0ace623abd1bc9e9985dffb89e8e366bed782c5332563aba4245a6744aad5aaf4d2276cbed5ea1d026c528b230cd38b2c92721d78cc4772526748f9f611eb28de7afe25e818283604a1e8788898a7385838e8f55856f6c2c1d86392f6b9730708d6c5477673758a3865e92627e94754e173697a6a975809368949bb2ae7b9a6865aa734f80a2a17da576aa5bb667c290cdce4379cfd2ce9ed3d6a7ccd7daa4d9c79341c8b9df5fc052a8deba9bb696767b9c7fd5b8bbf23eabb9706bcae5f05ab7e6c4c7488ddaf7251bc062530efe93638c5b3580ecd4951312c217c425e73e89d38709d79d810d393bd20a528ce0aa704aa2d4d3082e583c89bd2c2d720753e1c8922697d44cf6ae53bf6d4041750b4ad467c54548932a1d7374a9d3a789004400003b	This is sample text data for GGG&G, publisher 9901 in the pubs database. GGG&G is located in M?nchen, Germany.
9952	\\x47494638396107012800b30f00000000800000008000808000000080800080008080808080c0c0c0ff000000ff00ffff000000ffff00ff00ffffffffff21f9040100000f002c00000000070128004004fff0c949abbd38ebcdbbff60288e6469660005ac2c7bb56d05a7d24c4f339e3f765fc716980c3824f28418e4d1a552da8acca5517a7b526f275912690d2a9bd11d14ab8b8257e7e9776bdee452c2279c47a5cbedef2b3c3fbf9fc85981821d7d76868588878a898c8b838f1c8d928e733890829399949b979d9e9fa074a1a3a4a5a6a7458f583e69803f53af4c62ad5e6db13b6b3daeac6eba64b365b26bb7abbeb5c07fb428bcc4c8c1ccc7bbb065637c7a9b7bbe8cdadbda8b7c31d9e1d88e2fa89e9ae9e49ae7eda48da2eef2f3f4f597aef6f9fafbfc805d6cd28c0164c64d18be3aad88d87aa5c1dbc07fd59ce54293f0e0882ac39ed9ca2886e3308fb3ff262ebc726d591823204f2e0c09a4a3b32cfeacbc24198d86c48fd3e208d43832e3c0671a2d89737167281aa333219ac048d061499a3c83bec8090bd84e5a99de808b730de9516b727ce85ae7c122bf73ead29255cb76addbb6ec549c8504f7ad5db37343a98d97576eddbf7cfb0aee8457ef5d4e83132baeb1b8b1e3c749204b9eacb830e5cb984de1f339a4e1cc88c93cb7d989d72234d1d3a672fef85055c483c80a06742adb664f3563119e417d5a8f52dfb1512aec5d82e9c8662a477fb19a72b6f2e714413f8d0654aa75a8c4c648fdbc346acdcd5487afc439be8bc8e8aa7f6bd77d2b7df4e6c5882e57dfbde2f56aee6d87dfb8bfe06be7e8f1c6cbce4d2dc15751803c5956567efa1d47a041e5f1176183cc1d571d21c2850396565cf5b1d5571d8ac21d08e099a15e85269e87207b1736b31e6fe620324e582116f5215178c86763518a9068df7fe8c9c6207dcd0104a47b6b717388901efa27238e3482454e43bb61e8d388f7fd44dd32473e79d43a527633232561e6f86536660256891699d175989a6f1a020a9c75c9d5e68274c619d79d91b5c5189f7906ca67297129d88f9e881a3aa83e8ab623e85e8b0edae89c892216e9a584b80318a69c7e3269a7a046fa69a8a4b6094004003b	This is sample text data for Scootney Books, publisher 9952 in the pubs database. Scootney Books is located in New York City, New York.
9999	\\x474946383961a9002400b30f00000000800000008000808000000080800080008080808080c0c0c0ff000000ff00ffff000000ffff00ff00ffffffffff21f9040100000f002c00000000a90024004004fff0c949abbd38ebcdbbff60f8011a609e67653ea8d48a702ccff44566689ed67cefff23d58e7513b686444a6ea26b126fc8e74ac82421a7abe5f4594d61b7bbf0d6f562719a68a07acdc6389925749afc6edbefbca24d3e96e2ff803d7a1672468131736e494a8b5c848d8633834b916e598b657e4a83905f7d9b7b56986064a09ba2a68d63603a2e717c9487b2b3209ca7ad52594751b4bd80b65d75b799bec5bfaf7cc6cacb6638852acc409f901bd33eb6bccdc1d1cea9967b23c082c3709662a69fa4a591e7ae84d87a5fa0ab502f43ac5d74eb9367b0624593fa5cb101ed144173e5f4315ae8485b4287fcbe39e446b1624173feac59dc2809594623d9c3388a54e4acd59c642353e2f098e919319530dd61c405c7cbcb9831c5e5a2192c244e983a3ffe1cda21282ca248abb18c25336952a389d689e489b0d24483243b66cd8775a315801aa5a60a6b2dac074e3741d6bba8902ba687e9a6d1a3b6d6d15c7460c77aa3e3e556d79ebaf4aaaab2cfcf578671dfde657598305d51f7be5e5a25361ed3388eed0a84b2b7535d6072c1d62db5588be5cca5b1bda377b99e3cbe9eda31944a951adf7db15263a1429b37bb7e429d8ec4d754b87164078f2b87012002003b	This is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.\n\nThis is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.\n\nThis is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.\n\nThis is sample text data for Lucerne Publishing, publisher 9999 in the pubs database. Lucerne publishing is located in Paris, France.
\.


--
-- Data for Name: publishers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishers (pub_id, pub_name, city, state, country) FROM stdin;
0736	New Moon Books	Boston	MA	USA
0877	Binnet & Hardley	Washington	DC	USA
1389	Algodata Infosystems	Berkeley	CA	USA
1622	Five Lakes Publishing	Chicago	IL	USA
1756	Ramona Publishers	Dallas	TX	USA
9901	GGG&G	M?nchen	\N	Germany
9952	Scootney Books	New York	NY	USA
9999	Lucerne Publishing	Paris	\N	France
\.


--
-- Data for Name: roysched; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roysched (title_id, lorange, hirange, royalty) FROM stdin;
BU1032	0	5000	10
BU1032	5001	50000	12
PC1035	0	2000	10
PC1035	2001	3000	12
PC1035	3001	4000	14
PC1035	4001	10000	16
PC1035	10001	50000	18
BU2075	0	1000	10
BU2075	1001	3000	12
BU2075	3001	5000	14
BU2075	5001	7000	16
BU2075	7001	10000	18
BU2075	10001	12000	20
BU2075	12001	14000	22
BU2075	14001	50000	24
PS2091	0	1000	10
PS2091	1001	5000	12
PS2091	5001	10000	14
PS2091	10001	50000	16
PS2106	0	2000	10
PS2106	2001	5000	12
PS2106	5001	10000	14
PS2106	10001	50000	16
MC3021	0	1000	10
MC3021	1001	2000	12
MC3021	2001	4000	14
MC3021	4001	6000	16
MC3021	6001	8000	18
MC3021	8001	10000	20
MC3021	10001	12000	22
MC3021	12001	50000	24
TC3218	0	2000	10
TC3218	2001	4000	12
TC3218	4001	6000	14
TC3218	6001	8000	16
TC3218	8001	10000	18
TC3218	10001	12000	20
TC3218	12001	14000	22
TC3218	14001	50000	24
PC8888	0	5000	10
PC8888	5001	10000	12
PC8888	10001	15000	14
PC8888	15001	50000	16
PS7777	0	5000	10
PS7777	5001	50000	12
PS3333	0	5000	10
PS3333	5001	10000	12
PS3333	10001	15000	14
PS3333	15001	50000	16
BU1111	0	4000	10
BU1111	4001	8000	12
BU1111	8001	10000	14
BU1111	12001	16000	16
BU1111	16001	20000	18
BU1111	20001	24000	20
BU1111	24001	28000	22
BU1111	28001	50000	24
MC2222	0	2000	10
MC2222	2001	4000	12
MC2222	4001	8000	14
MC2222	8001	12000	16
MC2222	12001	20000	18
MC2222	20001	50000	20
TC7777	0	5000	10
TC7777	5001	15000	12
TC7777	15001	50000	14
TC4203	0	2000	10
TC4203	2001	8000	12
TC4203	8001	16000	14
TC4203	16001	24000	16
TC4203	24001	32000	18
TC4203	32001	40000	20
TC4203	40001	50000	22
BU7832	0	5000	10
BU7832	5001	10000	12
BU7832	10001	15000	14
BU7832	15001	20000	16
BU7832	20001	25000	18
BU7832	25001	30000	20
BU7832	30001	35000	22
BU7832	35001	50000	24
PS1372	0	10000	10
PS1372	10001	20000	12
PS1372	20001	30000	14
PS1372	30001	40000	16
PS1372	40001	50000	18
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (stor_id, ord_num, ord_date, qty, payterms, title_id) FROM stdin;
6380	6871	1994-09-14 00:00:00+00	5	Net 60	BU1032
6380	722a	1994-09-13 00:00:00+00	3	Net 60	PS2091
7066	A2976	1993-05-24 00:00:00+00	50	Net 30	PC8888
7066	QA7442.3	1994-09-13 00:00:00+00	75	ON invoice	PS2091
7067	D4482	1994-09-14 00:00:00+00	10	Net 60	PS2091
7067	P2121	1992-06-15 00:00:00+00	40	Net 30	TC3218
7067	P2121	1992-06-15 00:00:00+00	20	Net 30	TC4203
7067	P2121	1992-06-15 00:00:00+00	20	Net 30	TC7777
7131	N914008	1994-09-14 00:00:00+00	20	Net 30	PS2091
7131	N914014	1994-09-14 00:00:00+00	25	Net 30	MC3021
7131	P3087a	1993-05-29 00:00:00+00	20	Net 60	PS1372
7131	P3087a	1993-05-29 00:00:00+00	25	Net 60	PS2106
7131	P3087a	1993-05-29 00:00:00+00	15	Net 60	PS3333
7131	P3087a	1993-05-29 00:00:00+00	25	Net 60	PS7777
7896	QQ2299	1993-10-28 00:00:00+00	15	Net 60	BU7832
7896	TQ456	1993-12-12 00:00:00+00	10	Net 60	MC2222
7896	X999	1993-02-21 00:00:00+00	35	ON invoice	BU2075
8042	423LL922	1994-09-14 00:00:00+00	15	ON invoice	MC3021
8042	423LL930	1994-09-14 00:00:00+00	10	ON invoice	BU1032
8042	P723	1993-03-11 00:00:00+00	25	Net 30	BU1111
8042	QA879.1	1993-05-22 00:00:00+00	30	Net 30	PC1035
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stores (stor_id, stor_name, stor_address, city, state, zip) FROM stdin;
6380	Eric the Read Books	788 Catamaugus Ave.	Seattle	WA	98056
7066	Barnum's	567 Pasadena Ave.	Tustin	CA	92789
7067	News & Brews	577 First St.	Los Gatos	CA	96745
7131	Doc-U-Mat: Quality Laundry and Books	24-A Avogadro Way	Remulade	WA	98014
7896	Fricative Bookshop	89 Madison St.	Fremont	CA	90019
8042	Bookbeat	679 Carson St.	Portland	OR	89076
\.


--
-- Data for Name: titleauthor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.titleauthor (au_id, title_id, au_ord, royaltyper) FROM stdin;
172-32-1176	PS3333	1	100
213-46-8915	BU1032	2	40
213-46-8915	BU2075	1	100
238-95-7766	PC1035	1	100
267-41-2394	BU1111	2	40
267-41-2394	TC7777	2	30
274-80-9391	BU7832	1	100
409-56-7008	BU1032	1	60
427-17-2319	PC8888	1	50
472-27-2349	TC7777	3	30
486-29-1786	PC9999	1	100
486-29-1786	PS7777	1	100
648-92-1872	TC4203	1	100
672-71-3249	TC7777	1	40
712-45-1867	MC2222	1	100
722-51-5454	MC3021	1	75
724-80-9391	BU1111	1	60
724-80-9391	PS1372	2	25
756-30-7391	PS1372	1	75
807-91-6654	TC3218	1	100
846-92-7186	PC8888	2	50
899-46-2035	MC3021	2	25
899-46-2035	PS2091	2	50
998-72-3567	PS2091	1	50
998-72-3567	PS2106	1	100
\.


--
-- Data for Name: titles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate) FROM stdin;
BU1032	The Busy Executive's Database Guide	business    	1389	19.99	5000	10	4095	An overview of available database systems with emphasis on common business applications. Illustrated.	1991-06-12 00:00:00+00
BU1111	Cooking with Computers: Surreptitious Balance Sheets	business    	1389	11.95	5000	10	3876	Helpful hints on how to use your electronic resources to the best advantage.	1991-06-09 00:00:00+00
BU2075	You Can Combat Computer Stress!	business    	0736	2.99	10125	24	18722	The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.	1991-06-30 00:00:00+00
BU7832	Straight Talk About Computers	business    	1389	19.99	5000	10	4095	Annotated analysis of what computers can do for you: a no-hype guide for the critical user.	1991-06-22 00:00:00+00
MC2222	Silicon Valley Gastronomic Treats	mod_cook    	0877	19.99	0.0000	12	2032	Favorite recipes for quick, easy, and elegant meals.	1991-06-09 00:00:00+00
MC3021	The Gourmet Microwave	mod_cook    	0877	2.99	15000	24	22246	Traditional French gourmet recipes adapted for modern microwave cooking.	1991-06-18 00:00:00+00
MC3026	The Psychology of Computer Cooking	UNDECIDED   	0877	\N	\N	\N	\N	\N	2024-02-03 13:47:48.887+00
PC1035	But Is It User Friendly?	popular_comp	1389	22.95	7000	16	8780	A survey of software for the naive user, focusing on the 'friendliness' of each.	1991-06-30 00:00:00+00
PC8888	Secrets of Silicon Valley	popular_comp	1389	20	8000	10	4095	Muckraking reporting on the world's largest computer hardware and software manufacturers.	1994-06-12 00:00:00+00
PC9999	Net Etiquette	popular_comp	1389	\N	\N	\N	\N	A must-read for computer conferencing.	2024-02-03 13:47:48.89+00
PS1372	Computer Phobic AND Non-Phobic Individuals: Behavior Variations	psychology  	0877	21.59	7000	10	375	A must for the specialist, this book examines the difference between those who hate and fear computers and those who don't.	1991-10-21 00:00:00+00
PS2091	Is Anger the Enemy?	psychology  	0736	10.95	2275	12	2045	Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.	1991-06-15 00:00:00+00
PS2106	Life Without Fear	psychology  	0736	7	6000	10	111	New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.	1991-10-05 00:00:00+00
PS3333	Prolonged Data Deprivation: Four Case Studies	psychology  	0736	19.99	2000	10	4072	What happens when the data runs dry?  Searching evaluations of information-shortage effects.	1991-06-12 00:00:00+00
PS7777	Emotional Security: A New Algorithm	psychology  	0736	7.99	4000	10	3336	Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.	1991-06-12 00:00:00+00
TC3218	Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean	trad_cook   	0877	20.95	7000	10	375	Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.	1991-10-21 00:00:00+00
TC4203	Fifty Years in Buckingham Palace Kitchens	trad_cook   	0877	11.95	4000	14	15096	More anecdotes from the Queen's favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.	1991-06-12 00:00:00+00
TC7777	Sushi, Anyone?	trad_cook   	0877	14.99	8000	10	4095	Detailed instructions on how to make authentic Japanese sushi in your spare time.	1991-06-12 00:00:00+00
\.


--
-- Data for Name: titleview; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.titleview (title, au_ord, au_lname, price, ytd_sales, pub_id) FROM stdin;
The Busy Executive's Database Guide	1	Bennet	19.99	4095	1389
Fifty Years in Buckingham Palace Kitchens	1	Blotchet-Halls	11.95	15096	0877
But Is It User Friendly?	1	Carson	22.95	8780	1389
The Gourmet Microwave	1	DeFrance	2.99	22246	0877
Silicon Valley Gastronomic Treats	1	del Castillo	19.99	2032	0877
Secrets of Silicon Valley	1	Dull	20	4095	1389
The Busy Executive's Database Guide	2	Green	19.99	4095	1389
You Can Combat Computer Stress!	1	Green	2.99	18722	0736
Sushi, Anyone?	3	Gringlesby	14.99	4095	0877
Secrets of Silicon Valley	2	Hunter	20	4095	1389
Computer Phobic AND Non-Phobic Individuals: Behavior Variations	1	Karsen	21.59	375	0877
Net Etiquette	1	Locksley	\N	\N	1389
Emotional Security: A New Algorithm	1	Locksley	7.99	3336	0736
Cooking with Computers: Surreptitious Balance Sheets	1	MacFeather	11.95	3876	1389
Computer Phobic AND Non-Phobic Individuals: Behavior Variations	2	MacFeather	21.59	375	0877
Cooking with Computers: Surreptitious Balance Sheets	2	O'Leary	11.95	3876	1389
Sushi, Anyone?	2	O'Leary	14.99	4095	0877
Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean	1	Panteley	20.95	375	0877
Is Anger the Enemy?	1	Ringer	10.95	2045	0736
Life Without Fear	1	Ringer	7	111	0736
The Gourmet Microwave	2	Ringer	2.99	22246	0877
Is Anger the Enemy?	2	Ringer	10.95	2045	0736
Straight Talk About Computers	1	Straight	19.99	4095	1389
Prolonged Data Deprivation: Four Case Studies	1	White	19.99	4072	0736
Sushi, Anyone?	1	Yokomoto	14.99	4095	0877
\.


--
-- PostgreSQL database dump complete
--

