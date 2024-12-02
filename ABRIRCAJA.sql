-- Table: public.abrircaja

-- DROP TABLE IF EXISTS public.abrircaja;

CREATE TABLE IF NOT EXISTS public.abrircaja
(
    id integer NOT NULL DEFAULT nextval('abrircaja_id_seq'::regclass),
    fecha date NOT NULL DEFAULT CURRENT_DATE,
    monto integer NOT NULL,
    estado character varying(50) COLLATE pg_catalog."default" NOT NULL DEFAULT 'ABIERTA'::character varying,
    idusuario integer NOT NULL,
    CONSTRAINT abrircaja_pkey PRIMARY KEY (id),
    CONSTRAINT idusuario FOREIGN KEY (idusuario)
        REFERENCES public.usuarios (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.abrircaja
    OWNER to postgres;