CREATE EXTENSION postgis;

-- Table: public.spatial_ref_sys

-- DROP TABLE public.spatial_ref_sys;

CREATE TABLE public.spatial_ref_sys
(
    srid integer NOT NULL,
    auth_name character varying(256) COLLATE pg_catalog."default",
    auth_srid integer,
    srtext character varying(2048) COLLATE pg_catalog."default",
    proj4text character varying(2048) COLLATE pg_catalog."default",
    CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid),
    CONSTRAINT spatial_ref_sys_srid_check CHECK (srid > 0 AND srid <= 998999)
)

TABLESPACE pg_default;

ALTER TABLE public.spatial_ref_sys
    OWNER to postgres;

GRANT ALL ON TABLE public.spatial_ref_sys TO postgres;

GRANT SELECT ON TABLE public.spatial_ref_sys TO PUBLIC;

-- create new column to store time, day, and stores
-- for future process, this should be done in temporary way to save memory
ALTER TABLE network_speed
ADD column n_time VARCHAR,
add column hours Varchar,
add column mins Varchar,
ADD column n_day VARCHAR,
ADD column n_month VARCHAR,
ADD column stores VARCHAR;

-- fill the data with time extracted from date_time column
-- for future process, this should be done in temporary way to save memory
UPDATE network_speed
SET n_time = TO_CHAR(network_speed.date_time, 'HH24:MI');

Update network_speed
set hours = to_char(network_speed.date_time, 'HH24');

Update network_speed
set mins = to_char(network_speed.date_time, 'MI');

-- fill the data with day extracted from date_time column
-- for future process, this should be done in temporary way to save memory
UPDATE network_speed
SET n_day = TO_CHAR(network_speed.date_time, 'D');

-- fill the data with month extracted from date_time column
-- for future process, this should be done in temporary way to save memory
UPDATE network_speed
SET n_month = TO_CHAR(network_speed.date_time, 'MM');

-- fill the data with store extracted from conditional case 
-- for future process, this should be done in temporary way to save memory
UPDATE network_speed
SET stores = CASE 
WHEN (TO_CHAR(network_speed.date_time, 'HH24:MI') BETWEEN '09:00' AND '20:59') AND (TO_CHAR(network_speed.date_time, 'DAY') 
IN ('TUESDAY  ','FRIDAY   ','THURSDAY ')) THEN '1'
WHEN (TO_CHAR(network_speed.date_time, 'HH24:MI') BETWEEN '09:00' AND '17:59') AND (TO_CHAR(network_speed.date_time, 'DAY') 
IN ('MONDAY   ','WEDNESDAY','SATURDAY ')) THEN '1'
WHEN (TO_CHAR(network_speed.date_time, 'HH24:MI') BETWEEN '07:30' AND '08:59') AND (TO_CHAR(network_speed.date_time, 'DAY') 
NOT IN ('SUNDAY   ')) THEN '2'
WHEN (TO_CHAR(network_speed.date_time, 'HH24:MI') BETWEEN '21:00' AND '22:00') AND (TO_CHAR(network_speed.date_time, 'DAY') 
IN ('TUESDAY  ','FRIDAY   ','THURSDAY ')) THEN '3'
WHEN (TO_CHAR(network_speed.date_time, 'HH24:MI') BETWEEN '18:00' AND '19:00') AND (TO_CHAR(network_speed.date_time, 'DAY') 
IN ('MONDAY   ','WEDNESDAY','SATURDAY ')) THEN '3'
ELSE '0'
END;

-- Add network_speed_2018
-- Add network_speed_2019
-- Add network_speed_2020
-- Add network_speed_2021_22

-- for pilot processing, some road segments will be selected by following 
-- the road segment that was previously selected
-- in the future, need to find a way to automate this process (probably by using the segment coordinates)
select network_speed_2018.osm_id, network_speed_2018.date_time, network_speed_2018.link_dir, network_speed_2018.speed_kmph, 
network_speed_2018.n_time, network_speed_2018.hours, network_speed_2018.mins, network_speed_2018.n_day, network_speed_2018.stores, 
network_speed_2018.n_month, thessaloniki_road_network.highway, thessaloniki_road_network.road_lt_m, thessaloniki_road_network.bus_stop
from network_speed_2018
left join thessaloniki_road_network
on network_speed_2018.osm_id = thessaloniki_road_network.osm_id 
where network_speed_2018.osm_id in (
197107696,
176665188,
13769164,
174019380
)
union 
select network_speed_2019.osm_id, network_speed_2019.date_time, network_speed_2019.link_dir, network_speed_2019.speed_kmph, 
network_speed_2019.n_time, network_speed_2019.hours, network_speed_2019.mins, network_speed_2019.n_day, network_speed_2019.stores, 
network_speed_2019.n_month,
thessaloniki_road_network.highway, thessaloniki_road_network.road_lt_m, thessaloniki_road_network.bus_stop
from network_speed_2019
left join thessaloniki_road_network
on network_speed_2019.osm_id = thessaloniki_road_network.osm_id
where network_speed_2019.osm_id in (
197107696,
176665188,
13769164,
174019380
)
union 
select network_speed_2020.osm_id, network_speed_2020.date_time, network_speed_2020.link_dir, network_speed_2020.speed_kmph, 
network_speed_2020.n_time, network_speed_2020.hours, network_speed_2020.mins, network_speed_2020.n_day, network_speed_2020.stores, 
network_speed_2020.n_month,
thessaloniki_road_network.highway, thessaloniki_road_network.road_lt_m, thessaloniki_road_network.bus_stop
from network_speed_2020
left join thessaloniki_road_network
on network_speed_2020.osm_id = thessaloniki_road_network.osm_id
where network_speed_2020.osm_id in (
197107696,
176665188,
13769164,
174019380
)
union 
select network_speed_2021_22.osm_id, network_speed_2021_22.date_time, network_speed_2021_22.link_dir, network_speed_2021_22.speed_kmph, 
network_speed_2021_22.n_time, network_speed_2021_22.hours, network_speed_2021_22.mins, network_speed_2021_22.n_day, network_speed_2021_22.stores, 
network_speed_2021_22.n_month,
thessaloniki_road_network.highway, thessaloniki_road_network.road_lt_m, thessaloniki_road_network.bus_stop
from network_speed_2021_22
left join thessaloniki_road_network
on network_speed_2021_22.osm_id = thessaloniki_road_network.osm_id
where network_speed_2021_22.osm_id in (
197107696,
176665188,
13769164,
174019380
)
