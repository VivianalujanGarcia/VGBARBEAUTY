-- Table: public.ventas

-- DROP TABLE IF EXISTS public.ventas;

CREATE TABLE IF NOT EXISTS public.ventas
(
    id integer NOT NULL DEFAULT nextval('ventas_id_seq'::regclass),
    id_cliente integer NOT NULL,
    fecha date NOT NULL,
    estado character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'pendiente'::character varying,
    total integer NOT NULL DEFAULT 0,
    condicion character varying COLLATE pg_catalog."default" DEFAULT 'contado'::character varying,
    CONSTRAINT ventas_pkey PRIMARY KEY (id),
    CONSTRAINT id_cliente FOREIGN KEY (id_cliente)
        REFERENCES public.clientes (id_cliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.ventas
    OWNER to postgres;