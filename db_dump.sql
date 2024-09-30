--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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
-- Name: on_update_clientdiscount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.on_update_clientdiscount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$declare
current_sum_ int;
client_discountnum_ varchar(20);
begin

select clientdiscount_discountnumber into client_discountnum_
from client where client.clientid=NEW.client_clientid;

select purchasesum into current_sum_ from clientdiscount
where discountnumber=client_discountnum_;

if current_sum_>=3000 then
update clientdiscount set discountvalue=3;
end if;

if current_sum_>=10000 then
update clientdiscount set discountvalue=5;
end if;

if current_sum_>=20000 then
update clientdiscount set discountvalue=10;
end if;

return NEW;
END;
$$;


ALTER FUNCTION public.on_update_clientdiscount() OWNER TO postgres;

--
-- Name: on_update_itemsale(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.on_update_itemsale() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
datein_ date;
dateout_ date;
positionnum_ varchar(20);
invoicenum_ varchar(20);
begin

dateout_=NEW.datesale;
positionnum_=NEW.itemposition_itempositionnumber;

select invoice_invoicenumber into invoicenum_ from itemposition where itempositionnumber=positionnum_;

select invoicedate into datein_ from invoice where invoicenumber=invoicenum_;

IF dateout_ < datein_ THEN
        RAISE EXCEPTION 'Дата date_column1 должна быть меньше или равна date_column2';
END IF;

return NEW;
end;
$$;


ALTER FUNCTION public.on_update_itemsale() OWNER TO postgres;

--
-- Name: on_update_itemsale_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.on_update_itemsale_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare

itemposition_num_ varchar(20);
discountnumber_ varchar(20);
count_ int;
clientid_ int;
itemid_ int;
price_ int;
totalsum_ int;

begin

clientid_=NEW.client_clientid;
count_=NEW.countsale;
itemposition_num_=NEW.itemposition_itempositionnumber;

select item_itemid into itemid_ from itemposition
where itempositionnumber=itemposition_num_;

select itemprice into price_ from item
where item.itemid=itemid_;

select clientdiscount_discountnumber into discountnumber_ 
from client where client.clientid=clientid_;

update clientdiscount set purchasesum=purchasesum+price_*count_
where discountnumber=discountnumber_;

return NEW;

end;
$$;


ALTER FUNCTION public.on_update_itemsale_price() OWNER TO postgres;

--
-- Name: on_update_itemsalecount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.on_update_itemsalecount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update itemposition set itempositioncount=itempositioncount-NEW.countsale where itempositionnumber=NEW.itemposition_itempositionnumber;
return NEW;
end;
$$;


ALTER FUNCTION public.on_update_itemsalecount() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    clientid integer NOT NULL,
    clientname character varying(255) NOT NULL,
    clientborndate date NOT NULL,
    clientphone character varying(15) NOT NULL,
    clientpassword_passid integer NOT NULL,
    clientdiscount_discountnumber character varying(255)
);


ALTER TABLE public.client OWNER TO postgres;

--
-- Name: clientdiscount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientdiscount (
    discountnumber character varying(255) NOT NULL,
    purchasesum integer,
    discountvalue integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.clientdiscount OWNER TO postgres;

--
-- Name: clientpassport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientpassport (
    passid integer NOT NULL,
    passseries integer NOT NULL,
    passnumber integer NOT NULL,
    dateissued date NOT NULL,
    placeissued character varying(255) NOT NULL
);


ALTER TABLE public.clientpassport OWNER TO postgres;

--
-- Name: invoice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice (
    invoicenumber character varying(255) NOT NULL,
    invoicedate date NOT NULL,
    shop_shopid integer NOT NULL
);


ALTER TABLE public.invoice OWNER TO postgres;

--
-- Name: item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item (
    itemid integer NOT NULL,
    itemname character varying(255) NOT NULL,
    itemarticle character varying(255) NOT NULL,
    itemprice integer NOT NULL,
    itemtype_typeid integer NOT NULL
);


ALTER TABLE public.item OWNER TO postgres;

--
-- Name: itemmeasure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemmeasure (
    measureid integer NOT NULL,
    measurename character varying(255) NOT NULL
);


ALTER TABLE public.itemmeasure OWNER TO postgres;

--
-- Name: itemposition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemposition (
    itempositionnumber character varying(255) NOT NULL,
    itempositioncount integer NOT NULL,
    invoice_invoicenumber character varying(255) NOT NULL,
    item_itemid integer NOT NULL,
    itemmeasure_measureid integer NOT NULL
);


ALTER TABLE public.itemposition OWNER TO postgres;

--
-- Name: itemsale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemsale (
    itemposition_itempositionnumber character varying(255) NOT NULL,
    datesale date NOT NULL,
    countsale integer NOT NULL,
    client_clientid integer NOT NULL
);


ALTER TABLE public.itemsale OWNER TO postgres;

--
-- Name: itemtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itemtype (
    typeid integer NOT NULL,
    typename character varying(255) NOT NULL
);


ALTER TABLE public.itemtype OWNER TO postgres;

--
-- Name: shop; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shop (
    shopid integer NOT NULL,
    shopname character varying(255) NOT NULL,
    shopshortname character varying(255) NOT NULL
);


ALTER TABLE public.shop OWNER TO postgres;

--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (clientid, clientname, clientborndate, clientphone, clientpassword_passid, clientdiscount_discountnumber) FROM stdin;
1	Сидоров Иван Анатольевич	1990-02-12	88005553535	1	1001
\.


--
-- Data for Name: clientdiscount; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientdiscount (discountnumber, purchasesum, discountvalue) FROM stdin;
1001	6800	3
\.


--
-- Data for Name: clientpassport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientpassport (passid, passseries, passnumber, dateissued, placeissued) FROM stdin;
1	5110	123000	2002-02-12	УМВД ОРЕНБУРГА
\.


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice (invoicenumber, invoicedate, shop_shopid) FROM stdin;
909123	2023-02-10	1
909124	2023-02-12	2
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item (itemid, itemname, itemarticle, itemprice, itemtype_typeid) FROM stdin;
1	Футболка Красная	1902345	500	1
2	Джинсы Синие	782345	1200	1
\.


--
-- Data for Name: itemmeasure; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemmeasure (measureid, measurename) FROM stdin;
1	Руб.
2	USD
\.


--
-- Data for Name: itemposition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemposition (itempositionnumber, itempositioncount, invoice_invoicenumber, item_itemid, itemmeasure_measureid) FROM stdin;
100	6	909123	1	1
234	7	909124	2	1
\.


--
-- Data for Name: itemsale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemsale (itemposition_itempositionnumber, datesale, countsale, client_clientid) FROM stdin;
100	2023-03-04	2	1
234	2023-03-04	2	1
100	2023-04-05	2	1
234	2023-04-06	2	1
\.


--
-- Data for Name: itemtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itemtype (typeid, typename) FROM stdin;
1	Одежда
2	Кожгалантерея
3	Чулочно - носочные изделия
4	Обувь
\.


--
-- Data for Name: shop; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shop (shopid, shopname, shopshortname) FROM stdin;
1	ОАО "OSTIN"	OSTIN
2	ОАО "Gloria Jeans"	Gloria Jeans
3	ИП Спортмастер	Спортмастер
7	Chilli Co	ChilliWilli
\.


--
-- Name: client client_clientdiscount_discountnumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_clientdiscount_discountnumber_key UNIQUE (clientdiscount_discountnumber);


--
-- Name: client client_clientname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_clientname_key UNIQUE (clientname);


--
-- Name: client client_clientpassword_passid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_clientpassword_passid_key UNIQUE (clientpassword_passid);


--
-- Name: client client_clientphone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_clientphone_key UNIQUE (clientphone);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (clientid);


--
-- Name: clientdiscount clientdiscount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientdiscount
    ADD CONSTRAINT clientdiscount_pkey PRIMARY KEY (discountnumber);


--
-- Name: clientpassport clientpassword_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientpassport
    ADD CONSTRAINT clientpassword_pkey PRIMARY KEY (passid);


--
-- Name: invoice invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (invoicenumber);


--
-- Name: item item_itemarticle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_itemarticle_key UNIQUE (itemarticle);


--
-- Name: item item_itemname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_itemname_key UNIQUE (itemname);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (itemid);


--
-- Name: itemposition itemcount_nonneg; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.itemposition
    ADD CONSTRAINT itemcount_nonneg CHECK ((itempositioncount > 0)) NOT VALID;


--
-- Name: itemmeasure itemmeasure_measurename_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemmeasure
    ADD CONSTRAINT itemmeasure_measurename_key UNIQUE (measurename);


--
-- Name: itemmeasure itemmeasure_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemmeasure
    ADD CONSTRAINT itemmeasure_pkey PRIMARY KEY (measureid);


--
-- Name: itemposition itemposition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemposition
    ADD CONSTRAINT itemposition_pkey PRIMARY KEY (itempositionnumber);


--
-- Name: itemtype itemtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemtype
    ADD CONSTRAINT itemtype_pkey PRIMARY KEY (typeid);


--
-- Name: itemtype itemtype_typename_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemtype
    ADD CONSTRAINT itemtype_typename_key UNIQUE (typename);


--
-- Name: shop shop_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shop
    ADD CONSTRAINT shop_pkey PRIMARY KEY (shopid);


--
-- Name: shop shop_shopname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shop
    ADD CONSTRAINT shop_shopname_key UNIQUE (shopname);


--
-- Name: shop shop_shopshortname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shop
    ADD CONSTRAINT shop_shopshortname_key UNIQUE (shopshortname);


--
-- Name: itemsale on_update_discount_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_update_discount_trigger AFTER INSERT ON public.itemsale FOR EACH ROW EXECUTE FUNCTION public.on_update_clientdiscount();


--
-- Name: itemsale on_update_itemsale_datesale; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_update_itemsale_datesale BEFORE INSERT ON public.itemsale FOR EACH ROW EXECUTE FUNCTION public.on_update_itemsale();


--
-- Name: itemsale update_customer_total_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_customer_total_trigger AFTER INSERT ON public.itemsale FOR EACH ROW EXECUTE FUNCTION public.on_update_itemsale_price();


--
-- Name: itemsale update_itemsale_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_itemsale_trigger AFTER INSERT OR UPDATE ON public.itemsale FOR EACH ROW EXECUTE FUNCTION public.on_update_itemsalecount();


--
-- Name: client client_clientdiscount_discountnumber_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_clientdiscount_discountnumber_fkey FOREIGN KEY (clientdiscount_discountnumber) REFERENCES public.clientdiscount(discountnumber) ON DELETE SET NULL;


--
-- Name: client client_clientpassword_passid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_clientpassword_passid_fkey FOREIGN KEY (clientpassword_passid) REFERENCES public.clientpassport(passid) ON DELETE SET NULL;


--
-- Name: invoice invoice_shop_shopid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_shop_shopid_fkey FOREIGN KEY (shop_shopid) REFERENCES public.shop(shopid) ON DELETE SET NULL;


--
-- Name: item item_itemtype_typeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_itemtype_typeid_fkey FOREIGN KEY (itemtype_typeid) REFERENCES public.itemtype(typeid) ON DELETE SET NULL;


--
-- Name: itemposition itemposition_invoice_invoicenumber_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemposition
    ADD CONSTRAINT itemposition_invoice_invoicenumber_fkey FOREIGN KEY (invoice_invoicenumber) REFERENCES public.invoice(invoicenumber) ON DELETE SET NULL;


--
-- Name: itemposition itemposition_item_itemid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemposition
    ADD CONSTRAINT itemposition_item_itemid_fkey FOREIGN KEY (item_itemid) REFERENCES public.item(itemid);


--
-- Name: itemposition itemposition_itemmeasure_measureid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemposition
    ADD CONSTRAINT itemposition_itemmeasure_measureid_fkey FOREIGN KEY (itemmeasure_measureid) REFERENCES public.itemmeasure(measureid) ON DELETE SET NULL;


--
-- Name: itemsale itemsale_client_clientid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemsale
    ADD CONSTRAINT itemsale_client_clientid_fkey FOREIGN KEY (client_clientid) REFERENCES public.client(clientid) ON DELETE SET NULL;


--
-- Name: itemsale itemsale_itemposition_itempositionumber_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itemsale
    ADD CONSTRAINT itemsale_itemposition_itempositionumber_fkey FOREIGN KEY (itemposition_itempositionnumber) REFERENCES public.itemposition(itempositionnumber) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--
 


