PGDMP                     
    |        
   VGBarberia    15.6    15.6 �    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            @           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            A           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            B           1262    33326 
   VGBarberia    DATABASE     �   CREATE DATABASE "VGBarberia" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Paraguay.1252';
    DROP DATABASE "VGBarberia";
                postgres    false                       1255    35171    asignar_numero_factura()    FUNCTION       CREATE FUNCTION public.asignar_numero_factura() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Asigna el siguiente valor de la secuencia al campo 'numero' de la tabla 'compras'
    NEW.numero := nextval('numero_factura_seq');
    RETURN NEW;
END;
$$;
 /   DROP FUNCTION public.asignar_numero_factura();
       public          postgres    false                       1255    35087    aumentar_stock_compra()    FUNCTION     `  CREATE FUNCTION public.aumentar_stock_compra() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificar si el producto está en una de las categorías de producto (1 a 5)
    IF EXISTS (
        SELECT 1
        FROM public.productos
        WHERE id_producto = NEW.id_producto
          AND id_categoria IN (1, 2, 3, 4, 5)  -- Solo categorías de productos
    ) THEN
        -- Aumenta el stock del producto afectado por la compra
        UPDATE public.productos
        SET cantidad = cantidad + NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    END IF;

    RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.aumentar_stock_compra();
       public          postgres    false                       1255    35371    disminuir_stock_compra()    FUNCTION     �  CREATE FUNCTION public.disminuir_stock_compra() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Actualizar el stock solo para categorías 1 a 5
    IF (SELECT id_categoria FROM public.productos WHERE id_producto = NEW.id_producto) BETWEEN 1 AND 5 THEN
        UPDATE public.productos
        SET cantidad = cantidad + NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    END IF;

    RETURN NEW;
END;
$$;
 /   DROP FUNCTION public.disminuir_stock_compra();
       public          postgres    false                       1255    35089    disminuir_stock_venta()    FUNCTION     �  CREATE FUNCTION public.disminuir_stock_venta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificar si el producto pertenece a las categorías 1 a 5
    IF (SELECT id_categoria FROM public.productos WHERE id_producto = NEW.id_producto) BETWEEN 1 AND 5 THEN
        -- Verificar si el stock es suficiente
        IF (SELECT cantidad FROM public.productos WHERE id_producto = NEW.id_producto) < NEW.cantidad THEN
            RAISE EXCEPTION 'Stock insuficiente para la venta';
        END IF;

        -- Actualizar el stock del producto
        UPDATE public.productos
        SET cantidad = cantidad - NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    END IF;

    RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.disminuir_stock_venta();
       public          postgres    false                       1255    35173    revertir_stock_compra()    FUNCTION       CREATE FUNCTION public.revertir_stock_compra() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Si el estado de la compra es 'anulada', revertimos el stock
    IF EXISTS (
        SELECT 1
        FROM public.compras
        WHERE id = OLD.idcompra
          AND estado = 'anulada'
    ) THEN
        -- Recuperamos el stock de los productos comprados
        UPDATE public.productos
        SET cantidad = cantidad - OLD.cantidad
        WHERE id_producto = OLD.id_producto;
    END IF;

    RETURN OLD;
END;
$$;
 .   DROP FUNCTION public.revertir_stock_compra();
       public          postgres    false                       1255    35175    revertir_stock_venta()    FUNCTION       CREATE FUNCTION public.revertir_stock_venta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Si el estado de la venta es 'anulada', revertimos el stock
    IF EXISTS (
        SELECT 1
        FROM public.ventas
        WHERE id = OLD.idventa
          AND estado = 'anulada'
    ) THEN
        -- Recuperamos el stock de los productos vendidos
        UPDATE public.productos
        SET cantidad = cantidad + OLD.cantidad
        WHERE id_producto = OLD.id_producto;
    END IF;

    RETURN OLD;
END;
$$;
 -   DROP FUNCTION public.revertir_stock_venta();
       public          postgres    false                       1255    35352    verificar_stock()    FUNCTION     �  CREATE FUNCTION public.verificar_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificación para asegurarse de que la cantidad no sea negativa
    IF NEW.cantidad < 0 THEN
        RAISE EXCEPTION 'La cantidad no puede ser negativa';
    END IF;

    -- Establecer un valor mínimo para el stock (puedes ajustar el valor de 10 según lo necesites)
    IF NEW.cantidad < 10 THEN
        RAISE NOTICE 'Alerta: El producto % tiene un stock bajo (% unidades)', NEW.nombre, NEW.cantidad;
    END IF;

    -- Si la operación es una venta (UPDATE o DELETE), asegurar que no quede cantidad negativa
    IF TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        -- Verificar la cantidad actual antes de actualizar o eliminar
        IF NEW.cantidad < 0 THEN
            RAISE EXCEPTION 'No se puede reducir la cantidad a un valor negativo';
        END IF;
    END IF;

    RETURN NEW;
END;
$$;
 (   DROP FUNCTION public.verificar_stock();
       public          postgres    false                       1259    35181    Banco    TABLE     `   CREATE TABLE public."Banco" (
    id integer NOT NULL,
    nombre character varying NOT NULL
);
    DROP TABLE public."Banco";
       public         heap    postgres    false                       1259    35180    Banco_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Banco_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Banco_id_seq";
       public          postgres    false    264            C           0    0    Banco_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."Banco_id_seq" OWNED BY public."Banco".id;
          public          postgres    false    263            �            1259    34516 	   abrircaja    TABLE     �   CREATE TABLE public.abrircaja (
    id integer NOT NULL,
    fecha date NOT NULL,
    monto integer NOT NULL,
    estado character varying,
    idusuario integer NOT NULL
);
    DROP TABLE public.abrircaja;
       public         heap    postgres    false            �            1259    34515    abrircaja_id_seq    SEQUENCE     �   CREATE SEQUENCE public.abrircaja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.abrircaja_id_seq;
       public          postgres    false    245            D           0    0    abrircaja_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.abrircaja_id_seq OWNED BY public.abrircaja.id;
          public          postgres    false    244            �            1259    34544    ajusteinventario    TABLE     �   CREATE TABLE public.ajusteinventario (
    id integer NOT NULL,
    fecha date NOT NULL,
    tipo character varying NOT NULL,
    estado character varying DEFAULT 'PENDIENTE'::character varying NOT NULL,
    idusuarios integer NOT NULL
);
 $   DROP TABLE public.ajusteinventario;
       public         heap    postgres    false            �            1259    34543    ajusteinventario_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ajusteinventario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.ajusteinventario_id_seq;
       public          postgres    false    247            E           0    0    ajusteinventario_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.ajusteinventario_id_seq OWNED BY public.ajusteinventario.id;
          public          postgres    false    246            �            1259    34098 
   categorias    TABLE     r   CREATE TABLE public.categorias (
    id_categoria integer NOT NULL,
    nombre character varying(100) NOT NULL
);
    DROP TABLE public.categorias;
       public         heap    postgres    false            �            1259    34097    categorias_id_categoria_seq    SEQUENCE     �   CREATE SEQUENCE public.categorias_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.categorias_id_categoria_seq;
       public          postgres    false    217            F           0    0    categorias_id_categoria_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.categorias_id_categoria_seq OWNED BY public.categorias.id_categoria;
          public          postgres    false    216            �            1259    34500 
   cerrarcaja    TABLE     �   CREATE TABLE public.cerrarcaja (
    id integer NOT NULL,
    fecha date DEFAULT CURRENT_DATE NOT NULL,
    monto integer NOT NULL,
    estado character varying NOT NULL,
    idabrircaja integer
);
    DROP TABLE public.cerrarcaja;
       public         heap    postgres    false            �            1259    34499    cerrarcaja_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cerrarcaja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.cerrarcaja_id_seq;
       public          postgres    false    243            G           0    0    cerrarcaja_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.cerrarcaja_id_seq OWNED BY public.cerrarcaja.id;
          public          postgres    false    242            �            1259    34084    ciudades    TABLE     m   CREATE TABLE public.ciudades (
    id_ciudad integer NOT NULL,
    nombre character varying(100) NOT NULL
);
    DROP TABLE public.ciudades;
       public         heap    postgres    false            �            1259    34083    ciudades_id_ciudad_seq    SEQUENCE     �   CREATE SEQUENCE public.ciudades_id_ciudad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.ciudades_id_ciudad_seq;
       public          postgres    false    215            H           0    0    ciudades_id_ciudad_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.ciudades_id_ciudad_seq OWNED BY public.ciudades.id_ciudad;
          public          postgres    false    214            �            1259    34292    clientes    TABLE     �   CREATE TABLE public.clientes (
    id_cliente integer NOT NULL,
    nombre character varying(100) NOT NULL,
    ci character varying(10) NOT NULL,
    direccion text,
    telefono character varying(15),
    id_ciudad integer
);
    DROP TABLE public.clientes;
       public         heap    postgres    false            �            1259    34291    clientes_id_cliente_seq    SEQUENCE     �   CREATE SEQUENCE public.clientes_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.clientes_id_cliente_seq;
       public          postgres    false    229            I           0    0    clientes_id_cliente_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.clientes_id_cliente_seq OWNED BY public.clientes.id_cliente;
          public          postgres    false    228            �            1259    34994    cobros    TABLE     �   CREATE TABLE public.cobros (
    id integer NOT NULL,
    fecha date NOT NULL,
    estado character varying DEFAULT 'PENDIENTE'::character varying NOT NULL,
    idclientes integer NOT NULL,
    idabrircaja integer NOT NULL,
    numero integer NOT NULL
);
    DROP TABLE public.cobros;
       public         heap    postgres    false            �            1259    34993    cobros_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cobros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.cobros_id_seq;
       public          postgres    false    251            J           0    0    cobros_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.cobros_id_seq OWNED BY public.cobros.id;
          public          postgres    false    250                       1259    35273    cobros_numero_seq    SEQUENCE     �   CREATE SEQUENCE public.cobros_numero_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.cobros_numero_seq;
       public          postgres    false    251            K           0    0    cobros_numero_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.cobros_numero_seq OWNED BY public.cobros.numero;
          public          postgres    false    268            �            1259    34329    compras    TABLE     7  CREATE TABLE public.compras (
    id integer NOT NULL,
    id_proveedor integer NOT NULL,
    fecha date DEFAULT CURRENT_DATE NOT NULL,
    estado character varying(50) DEFAULT 'pendiente'::character varying NOT NULL,
    total integer DEFAULT 0 NOT NULL,
    numero integer,
    condicion character varying
);
    DROP TABLE public.compras;
       public         heap    postgres    false            �            1259    34328    compras_id_seq    SEQUENCE     �   CREATE SEQUENCE public.compras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.compras_id_seq;
       public          postgres    false    233            L           0    0    compras_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.compras_id_seq OWNED BY public.compras.id;
          public          postgres    false    232            �            1259    35021    cuentasclientes    TABLE     Y  CREATE TABLE public.cuentasclientes (
    id integer NOT NULL,
    monto integer NOT NULL,
    cuota integer NOT NULL,
    nrocuota integer NOT NULL,
    parcial integer DEFAULT 0 NOT NULL,
    vencimiento character varying NOT NULL,
    estado character varying DEFAULT 'PENDIENTE'::character varying NOT NULL,
    idventas integer NOT NULL
);
 #   DROP TABLE public.cuentasclientes;
       public         heap    postgres    false            �            1259    35020    cuentasclientes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cuentasclientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.cuentasclientes_id_seq;
       public          postgres    false    255            M           0    0    cuentasclientes_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.cuentasclientes_id_seq OWNED BY public.cuentasclientes.id;
          public          postgres    false    254                       1259    35062    cuentasproveedores    TABLE     U  CREATE TABLE public.cuentasproveedores (
    id integer NOT NULL,
    monto integer NOT NULL,
    cuota integer NOT NULL,
    nrocuota integer NOT NULL,
    parcial integer DEFAULT 0,
    vencimiento character varying(255) NOT NULL,
    estado character varying(255) DEFAULT 'PENDIENTE'::character varying,
    idcompras integer NOT NULL
);
 &   DROP TABLE public.cuentasproveedores;
       public         heap    postgres    false                        1259    35061    cuentasproveedores_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cuentasproveedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.cuentasproveedores_id_seq;
       public          postgres    false    257            N           0    0    cuentasproveedores_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.cuentasproveedores_id_seq OWNED BY public.cuentasproveedores.id;
          public          postgres    false    256            �            1259    34558    detalleajuste    TABLE     �   CREATE TABLE public.detalleajuste (
    id integer NOT NULL,
    idajusteinve integer NOT NULL,
    idproductos integer NOT NULL,
    motivo character varying NOT NULL,
    cant_ajuste integer NOT NULL
);
 !   DROP TABLE public.detalleajuste;
       public         heap    postgres    false            �            1259    34557    detalleajuste_id_seq    SEQUENCE     �   CREATE SEQUENCE public.detalleajuste_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.detalleajuste_id_seq;
       public          postgres    false    249            O           0    0    detalleajuste_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.detalleajuste_id_seq OWNED BY public.detalleajuste.id;
          public          postgres    false    248            �            1259    35014    detallecobros    TABLE     �   CREATE TABLE public.detallecobros (
    iddetallecobros integer NOT NULL,
    idcobros integer NOT NULL,
    idcuentaclientes integer NOT NULL
);
 !   DROP TABLE public.detallecobros;
       public         heap    postgres    false            �            1259    35013 !   detallecobros_iddetallecobros_seq    SEQUENCE     �   CREATE SEQUENCE public.detallecobros_iddetallecobros_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.detallecobros_iddetallecobros_seq;
       public          postgres    false    253            P           0    0 !   detallecobros_iddetallecobros_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.detallecobros_iddetallecobros_seq OWNED BY public.detallecobros.iddetallecobros;
          public          postgres    false    252            �            1259    34351    detallecompras    TABLE     �   CREATE TABLE public.detallecompras (
    id integer NOT NULL,
    idcompra integer NOT NULL,
    cantidad integer NOT NULL,
    precio integer NOT NULL,
    id_producto integer NOT NULL
);
 "   DROP TABLE public.detallecompras;
       public         heap    postgres    false            �            1259    34350    detallecompras_id_seq    SEQUENCE     �   CREATE SEQUENCE public.detallecompras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.detallecompras_id_seq;
       public          postgres    false    237            Q           0    0    detallecompras_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.detallecompras_id_seq OWNED BY public.detallecompras.id;
          public          postgres    false    236                       1259    35154    detallepagos    TABLE     �   CREATE TABLE public.detallepagos (
    iddetallepagos integer NOT NULL,
    idpagos integer NOT NULL,
    idcuentaproveedores integer NOT NULL
);
     DROP TABLE public.detallepagos;
       public         heap    postgres    false                       1259    35153    detallepagos_iddetallepagos_seq    SEQUENCE     �   CREATE SEQUENCE public.detallepagos_iddetallepagos_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.detallepagos_iddetallepagos_seq;
       public          postgres    false    261            R           0    0    detallepagos_iddetallepagos_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.detallepagos_iddetallepagos_seq OWNED BY public.detallepagos.iddetallepagos;
          public          postgres    false    260            �            1259    34339    detalleventas    TABLE     �   CREATE TABLE public.detalleventas (
    id integer NOT NULL,
    idventa integer NOT NULL,
    cantidad integer NOT NULL,
    precio integer NOT NULL,
    id_producto integer NOT NULL
);
 !   DROP TABLE public.detalleventas;
       public         heap    postgres    false            �            1259    34338    detalleventas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.detalleventas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.detalleventas_id_seq;
       public          postgres    false    235            S           0    0    detalleventas_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.detalleventas_id_seq OWNED BY public.detalleventas.id;
          public          postgres    false    234            �            1259    34256 
   inventario    TABLE     �   CREATE TABLE public.inventario (
    id_movimiento integer NOT NULL,
    id_producto integer,
    tipo_movimiento character varying(50) NOT NULL,
    cantidad integer NOT NULL,
    fecha date DEFAULT CURRENT_DATE
);
    DROP TABLE public.inventario;
       public         heap    postgres    false            �            1259    34255    inventario_id_movimiento_seq    SEQUENCE     �   CREATE SEQUENCE public.inventario_id_movimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.inventario_id_movimiento_seq;
       public          postgres    false    225            T           0    0    inventario_id_movimiento_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.inventario_id_movimiento_seq OWNED BY public.inventario.id_movimiento;
          public          postgres    false    224            �            1259    34270    marcas    TABLE     j   CREATE TABLE public.marcas (
    id_marca integer NOT NULL,
    nombre character varying(100) NOT NULL
);
    DROP TABLE public.marcas;
       public         heap    postgres    false            �            1259    34269    marcas_id_marca_seq    SEQUENCE     �   CREATE SEQUENCE public.marcas_id_marca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.marcas_id_marca_seq;
       public          postgres    false    227            U           0    0    marcas_id_marca_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.marcas_id_marca_seq OWNED BY public.marcas.id_marca;
          public          postgres    false    226            �            1259    34210    metodos_pago    TABLE     u   CREATE TABLE public.metodos_pago (
    id_metodo_pago integer NOT NULL,
    metodo character varying(50) NOT NULL
);
     DROP TABLE public.metodos_pago;
       public         heap    postgres    false            	           1259    35194    metodos_pago_bancos    TABLE     p   CREATE TABLE public.metodos_pago_bancos (
    id_metodo_pago integer NOT NULL,
    id_banco integer NOT NULL
);
 '   DROP TABLE public.metodos_pago_bancos;
       public         heap    postgres    false            �            1259    34209    metodos_pago_id_metodo_pago_seq    SEQUENCE     �   CREATE SEQUENCE public.metodos_pago_id_metodo_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.metodos_pago_id_metodo_pago_seq;
       public          postgres    false    223            V           0    0    metodos_pago_id_metodo_pago_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.metodos_pago_id_metodo_pago_seq OWNED BY public.metodos_pago.id_metodo_pago;
          public          postgres    false    222                       1259    35251    movimientos_caja    TABLE     �   CREATE TABLE public.movimientos_caja (
    id integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tipo character varying(50),
    descripcion text,
    monto numeric(10,2) NOT NULL,
    idabrircaja integer
);
 $   DROP TABLE public.movimientos_caja;
       public         heap    postgres    false            
           1259    35250    movimientos_caja_id_seq    SEQUENCE     �   CREATE SEQUENCE public.movimientos_caja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.movimientos_caja_id_seq;
       public          postgres    false    267            W           0    0    movimientos_caja_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.movimientos_caja_id_seq OWNED BY public.movimientos_caja.id;
          public          postgres    false    266                       1259    35170    numero_factura_seq    SEQUENCE     {   CREATE SEQUENCE public.numero_factura_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.numero_factura_seq;
       public          postgres    false                       1259    35136    pagos    TABLE       CREATE TABLE public.pagos (
    id integer NOT NULL,
    fecha date NOT NULL,
    estado character varying(20) DEFAULT 'PENDIENTE'::character varying NOT NULL,
    idproveedores integer NOT NULL,
    idabrircaja integer NOT NULL,
    numero integer NOT NULL
);
    DROP TABLE public.pagos;
       public         heap    postgres    false                       1259    35135    pagos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.pagos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.pagos_id_seq;
       public          postgres    false    259            X           0    0    pagos_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.pagos_id_seq OWNED BY public.pagos.id;
          public          postgres    false    258            �            1259    34436 
   personales    TABLE     e  CREATE TABLE public.personales (
    id_personal integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    ci character varying(20) NOT NULL,
    fecha_nacimiento date NOT NULL,
    direccion character varying(100) NOT NULL,
    telefono character varying(20) NOT NULL,
    idciudad integer NOT NULL
);
    DROP TABLE public.personales;
       public         heap    postgres    false            �            1259    34435    personales_id_personal_seq    SEQUENCE     �   CREATE SEQUENCE public.personales_id_personal_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.personales_id_personal_seq;
       public          postgres    false    241            Y           0    0    personales_id_personal_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.personales_id_personal_seq OWNED BY public.personales.id_personal;
          public          postgres    false    240            �            1259    34105 	   productos    TABLE       CREATE TABLE public.productos (
    id_producto integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    precio integer NOT NULL,
    cantidad integer NOT NULL,
    id_categoria integer,
    id_marca integer,
    iva integer
);
    DROP TABLE public.productos;
       public         heap    postgres    false            �            1259    34104    productos_id_producto_seq    SEQUENCE     �   CREATE SEQUENCE public.productos_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.productos_id_producto_seq;
       public          postgres    false    219            Z           0    0    productos_id_producto_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.productos_id_producto_seq OWNED BY public.productos.id_producto;
          public          postgres    false    218            �            1259    34198    proveedores    TABLE     �   CREATE TABLE public.proveedores (
    id_proveedor integer NOT NULL,
    nombre character varying(100) NOT NULL,
    ruc character varying(15),
    telefono character varying(15),
    correo character varying(100),
    id_ciudad integer
);
    DROP TABLE public.proveedores;
       public         heap    postgres    false            �            1259    34197    proveedores_id_proveedor_seq    SEQUENCE     �   CREATE SEQUENCE public.proveedores_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.proveedores_id_proveedor_seq;
       public          postgres    false    221            [           0    0    proveedores_id_proveedor_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.proveedores_id_proveedor_seq OWNED BY public.proveedores.id_proveedor;
          public          postgres    false    220            �            1259    34428    usuarios    TABLE       CREATE TABLE public.usuarios (
    id integer NOT NULL,
    datos character varying(100) NOT NULL,
    usuario character varying(100) NOT NULL,
    clave character varying(50) NOT NULL,
    rol character varying(20) NOT NULL,
    estado character(20) DEFAULT 'A'::bpchar NOT NULL
);
    DROP TABLE public.usuarios;
       public         heap    postgres    false            �            1259    34427    usuarios_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.usuarios_id_seq;
       public          postgres    false    239            \           0    0    usuarios_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;
          public          postgres    false    238            �            1259    34313    ventas    TABLE     $  CREATE TABLE public.ventas (
    id integer NOT NULL,
    id_cliente integer NOT NULL,
    fecha date NOT NULL,
    estado character varying DEFAULT 'pendiente'::character varying NOT NULL,
    total integer DEFAULT 0 NOT NULL,
    numero integer NOT NULL,
    condicion character varying
);
    DROP TABLE public.ventas;
       public         heap    postgres    false            �            1259    34312    ventas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ventas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.ventas_id_seq;
       public          postgres    false    231            ]           0    0    ventas_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.ventas_id_seq OWNED BY public.ventas.id;
          public          postgres    false    230                       1259    35299    ventas_numero_seq    SEQUENCE     �   CREATE SEQUENCE public.ventas_numero_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.ventas_numero_seq;
       public          postgres    false    231            ^           0    0    ventas_numero_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.ventas_numero_seq OWNED BY public.ventas.numero;
          public          postgres    false    269                       2604    35184    Banco id    DEFAULT     h   ALTER TABLE ONLY public."Banco" ALTER COLUMN id SET DEFAULT nextval('public."Banco_id_seq"'::regclass);
 9   ALTER TABLE public."Banco" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    264    263    264                       2604    34519    abrircaja id    DEFAULT     l   ALTER TABLE ONLY public.abrircaja ALTER COLUMN id SET DEFAULT nextval('public.abrircaja_id_seq'::regclass);
 ;   ALTER TABLE public.abrircaja ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244    245            	           2604    34547    ajusteinventario id    DEFAULT     z   ALTER TABLE ONLY public.ajusteinventario ALTER COLUMN id SET DEFAULT nextval('public.ajusteinventario_id_seq'::regclass);
 B   ALTER TABLE public.ajusteinventario ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    246    247    247            �           2604    34101    categorias id_categoria    DEFAULT     �   ALTER TABLE ONLY public.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('public.categorias_id_categoria_seq'::regclass);
 F   ALTER TABLE public.categorias ALTER COLUMN id_categoria DROP DEFAULT;
       public          postgres    false    216    217    217                       2604    34503    cerrarcaja id    DEFAULT     n   ALTER TABLE ONLY public.cerrarcaja ALTER COLUMN id SET DEFAULT nextval('public.cerrarcaja_id_seq'::regclass);
 <   ALTER TABLE public.cerrarcaja ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    242    243    243            �           2604    34087    ciudades id_ciudad    DEFAULT     x   ALTER TABLE ONLY public.ciudades ALTER COLUMN id_ciudad SET DEFAULT nextval('public.ciudades_id_ciudad_seq'::regclass);
 A   ALTER TABLE public.ciudades ALTER COLUMN id_ciudad DROP DEFAULT;
       public          postgres    false    215    214    215            �           2604    34295    clientes id_cliente    DEFAULT     z   ALTER TABLE ONLY public.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('public.clientes_id_cliente_seq'::regclass);
 B   ALTER TABLE public.clientes ALTER COLUMN id_cliente DROP DEFAULT;
       public          postgres    false    229    228    229                       2604    34997 	   cobros id    DEFAULT     f   ALTER TABLE ONLY public.cobros ALTER COLUMN id SET DEFAULT nextval('public.cobros_id_seq'::regclass);
 8   ALTER TABLE public.cobros ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    250    251    251                       2604    35274    cobros numero    DEFAULT     n   ALTER TABLE ONLY public.cobros ALTER COLUMN numero SET DEFAULT nextval('public.cobros_numero_seq'::regclass);
 <   ALTER TABLE public.cobros ALTER COLUMN numero DROP DEFAULT;
       public          postgres    false    268    251            �           2604    34332 
   compras id    DEFAULT     h   ALTER TABLE ONLY public.compras ALTER COLUMN id SET DEFAULT nextval('public.compras_id_seq'::regclass);
 9   ALTER TABLE public.compras ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    233    233                       2604    35024    cuentasclientes id    DEFAULT     x   ALTER TABLE ONLY public.cuentasclientes ALTER COLUMN id SET DEFAULT nextval('public.cuentasclientes_id_seq'::regclass);
 A   ALTER TABLE public.cuentasclientes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    255    254    255                       2604    35065    cuentasproveedores id    DEFAULT     ~   ALTER TABLE ONLY public.cuentasproveedores ALTER COLUMN id SET DEFAULT nextval('public.cuentasproveedores_id_seq'::regclass);
 D   ALTER TABLE public.cuentasproveedores ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    257    256    257                       2604    34561    detalleajuste id    DEFAULT     t   ALTER TABLE ONLY public.detalleajuste ALTER COLUMN id SET DEFAULT nextval('public.detalleajuste_id_seq'::regclass);
 ?   ALTER TABLE public.detalleajuste ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    249    248    249                       2604    35017    detallecobros iddetallecobros    DEFAULT     �   ALTER TABLE ONLY public.detallecobros ALTER COLUMN iddetallecobros SET DEFAULT nextval('public.detallecobros_iddetallecobros_seq'::regclass);
 L   ALTER TABLE public.detallecobros ALTER COLUMN iddetallecobros DROP DEFAULT;
       public          postgres    false    252    253    253                       2604    34354    detallecompras id    DEFAULT     v   ALTER TABLE ONLY public.detallecompras ALTER COLUMN id SET DEFAULT nextval('public.detallecompras_id_seq'::regclass);
 @   ALTER TABLE public.detallecompras ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    236    237                       2604    35157    detallepagos iddetallepagos    DEFAULT     �   ALTER TABLE ONLY public.detallepagos ALTER COLUMN iddetallepagos SET DEFAULT nextval('public.detallepagos_iddetallepagos_seq'::regclass);
 J   ALTER TABLE public.detallepagos ALTER COLUMN iddetallepagos DROP DEFAULT;
       public          postgres    false    261    260    261                       2604    34342    detalleventas id    DEFAULT     t   ALTER TABLE ONLY public.detalleventas ALTER COLUMN id SET DEFAULT nextval('public.detalleventas_id_seq'::regclass);
 ?   ALTER TABLE public.detalleventas ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    235    235            �           2604    34259    inventario id_movimiento    DEFAULT     �   ALTER TABLE ONLY public.inventario ALTER COLUMN id_movimiento SET DEFAULT nextval('public.inventario_id_movimiento_seq'::regclass);
 G   ALTER TABLE public.inventario ALTER COLUMN id_movimiento DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    34273    marcas id_marca    DEFAULT     r   ALTER TABLE ONLY public.marcas ALTER COLUMN id_marca SET DEFAULT nextval('public.marcas_id_marca_seq'::regclass);
 >   ALTER TABLE public.marcas ALTER COLUMN id_marca DROP DEFAULT;
       public          postgres    false    226    227    227            �           2604    34213    metodos_pago id_metodo_pago    DEFAULT     �   ALTER TABLE ONLY public.metodos_pago ALTER COLUMN id_metodo_pago SET DEFAULT nextval('public.metodos_pago_id_metodo_pago_seq'::regclass);
 J   ALTER TABLE public.metodos_pago ALTER COLUMN id_metodo_pago DROP DEFAULT;
       public          postgres    false    222    223    223                       2604    35254    movimientos_caja id    DEFAULT     z   ALTER TABLE ONLY public.movimientos_caja ALTER COLUMN id SET DEFAULT nextval('public.movimientos_caja_id_seq'::regclass);
 B   ALTER TABLE public.movimientos_caja ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    267    266    267                       2604    35139    pagos id    DEFAULT     d   ALTER TABLE ONLY public.pagos ALTER COLUMN id SET DEFAULT nextval('public.pagos_id_seq'::regclass);
 7   ALTER TABLE public.pagos ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258    259                       2604    34439    personales id_personal    DEFAULT     �   ALTER TABLE ONLY public.personales ALTER COLUMN id_personal SET DEFAULT nextval('public.personales_id_personal_seq'::regclass);
 E   ALTER TABLE public.personales ALTER COLUMN id_personal DROP DEFAULT;
       public          postgres    false    241    240    241            �           2604    34108    productos id_producto    DEFAULT     ~   ALTER TABLE ONLY public.productos ALTER COLUMN id_producto SET DEFAULT nextval('public.productos_id_producto_seq'::regclass);
 D   ALTER TABLE public.productos ALTER COLUMN id_producto DROP DEFAULT;
       public          postgres    false    219    218    219            �           2604    34201    proveedores id_proveedor    DEFAULT     �   ALTER TABLE ONLY public.proveedores ALTER COLUMN id_proveedor SET DEFAULT nextval('public.proveedores_id_proveedor_seq'::regclass);
 G   ALTER TABLE public.proveedores ALTER COLUMN id_proveedor DROP DEFAULT;
       public          postgres    false    221    220    221                       2604    34431    usuarios id    DEFAULT     j   ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);
 :   ALTER TABLE public.usuarios ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    239    238    239            �           2604    34316 	   ventas id    DEFAULT     f   ALTER TABLE ONLY public.ventas ALTER COLUMN id SET DEFAULT nextval('public.ventas_id_seq'::regclass);
 8   ALTER TABLE public.ventas ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    231    231            �           2604    35300    ventas numero    DEFAULT     n   ALTER TABLE ONLY public.ventas ALTER COLUMN numero SET DEFAULT nextval('public.ventas_numero_seq'::regclass);
 <   ALTER TABLE public.ventas ALTER COLUMN numero DROP DEFAULT;
       public          postgres    false    269    231            7          0    35181    Banco 
   TABLE DATA           -   COPY public."Banco" (id, nombre) FROM stdin;
    public          postgres    false    264   /      $          0    34516 	   abrircaja 
   TABLE DATA           H   COPY public.abrircaja (id, fecha, monto, estado, idusuario) FROM stdin;
    public          postgres    false    245   g/      &          0    34544    ajusteinventario 
   TABLE DATA           O   COPY public.ajusteinventario (id, fecha, tipo, estado, idusuarios) FROM stdin;
    public          postgres    false    247   �/                0    34098 
   categorias 
   TABLE DATA           :   COPY public.categorias (id_categoria, nombre) FROM stdin;
    public          postgres    false    217   i0      "          0    34500 
   cerrarcaja 
   TABLE DATA           K   COPY public.cerrarcaja (id, fecha, monto, estado, idabrircaja) FROM stdin;
    public          postgres    false    243   �0                0    34084    ciudades 
   TABLE DATA           5   COPY public.ciudades (id_ciudad, nombre) FROM stdin;
    public          postgres    false    215   E1                0    34292    clientes 
   TABLE DATA           Z   COPY public.clientes (id_cliente, nombre, ci, direccion, telefono, id_ciudad) FROM stdin;
    public          postgres    false    229   �1      *          0    34994    cobros 
   TABLE DATA           T   COPY public.cobros (id, fecha, estado, idclientes, idabrircaja, numero) FROM stdin;
    public          postgres    false    251   �1                0    34329    compras 
   TABLE DATA           \   COPY public.compras (id, id_proveedor, fecha, estado, total, numero, condicion) FROM stdin;
    public          postgres    false    233   u2      .          0    35021    cuentasclientes 
   TABLE DATA           m   COPY public.cuentasclientes (id, monto, cuota, nrocuota, parcial, vencimiento, estado, idventas) FROM stdin;
    public          postgres    false    255   �2      0          0    35062    cuentasproveedores 
   TABLE DATA           q   COPY public.cuentasproveedores (id, monto, cuota, nrocuota, parcial, vencimiento, estado, idcompras) FROM stdin;
    public          postgres    false    257   h3      (          0    34558    detalleajuste 
   TABLE DATA           [   COPY public.detalleajuste (id, idajusteinve, idproductos, motivo, cant_ajuste) FROM stdin;
    public          postgres    false    249   �3      ,          0    35014    detallecobros 
   TABLE DATA           T   COPY public.detallecobros (iddetallecobros, idcobros, idcuentaclientes) FROM stdin;
    public          postgres    false    253   n4                0    34351    detallecompras 
   TABLE DATA           U   COPY public.detallecompras (id, idcompra, cantidad, precio, id_producto) FROM stdin;
    public          postgres    false    237   �4      4          0    35154    detallepagos 
   TABLE DATA           T   COPY public.detallepagos (iddetallepagos, idpagos, idcuentaproveedores) FROM stdin;
    public          postgres    false    261   �4                0    34339    detalleventas 
   TABLE DATA           S   COPY public.detalleventas (id, idventa, cantidad, precio, id_producto) FROM stdin;
    public          postgres    false    235   5                0    34256 
   inventario 
   TABLE DATA           b   COPY public.inventario (id_movimiento, id_producto, tipo_movimiento, cantidad, fecha) FROM stdin;
    public          postgres    false    225   �5                0    34270    marcas 
   TABLE DATA           2   COPY public.marcas (id_marca, nombre) FROM stdin;
    public          postgres    false    227   �5                0    34210    metodos_pago 
   TABLE DATA           >   COPY public.metodos_pago (id_metodo_pago, metodo) FROM stdin;
    public          postgres    false    223   K6      8          0    35194    metodos_pago_bancos 
   TABLE DATA           G   COPY public.metodos_pago_bancos (id_metodo_pago, id_banco) FROM stdin;
    public          postgres    false    265   �6      :          0    35251    movimientos_caja 
   TABLE DATA           \   COPY public.movimientos_caja (id, fecha, tipo, descripcion, monto, idabrircaja) FROM stdin;
    public          postgres    false    267   �6      2          0    35136    pagos 
   TABLE DATA           V   COPY public.pagos (id, fecha, estado, idproveedores, idabrircaja, numero) FROM stdin;
    public          postgres    false    259   7                 0    34436 
   personales 
   TABLE DATA           x   COPY public.personales (id_personal, nombre, apellido, ci, fecha_nacimiento, direccion, telefono, idciudad) FROM stdin;
    public          postgres    false    241   W7      
          0    34105 	   productos 
   TABLE DATA           t   COPY public.productos (id_producto, nombre, descripcion, precio, cantidad, id_categoria, id_marca, iva) FROM stdin;
    public          postgres    false    219   <8                0    34198    proveedores 
   TABLE DATA           ]   COPY public.proveedores (id_proveedor, nombre, ruc, telefono, correo, id_ciudad) FROM stdin;
    public          postgres    false    221   �:                0    34428    usuarios 
   TABLE DATA           J   COPY public.usuarios (id, datos, usuario, clave, rol, estado) FROM stdin;
    public          postgres    false    239   O;                0    34313    ventas 
   TABLE DATA           Y   COPY public.ventas (id, id_cliente, fecha, estado, total, numero, condicion) FROM stdin;
    public          postgres    false    231   �;      _           0    0    Banco_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public."Banco_id_seq"', 6, true);
          public          postgres    false    263            `           0    0    abrircaja_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.abrircaja_id_seq', 13, true);
          public          postgres    false    244            a           0    0    ajusteinventario_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.ajusteinventario_id_seq', 14, true);
          public          postgres    false    246            b           0    0    categorias_id_categoria_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.categorias_id_categoria_seq', 8, true);
          public          postgres    false    216            c           0    0    cerrarcaja_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.cerrarcaja_id_seq', 10, true);
          public          postgres    false    242            d           0    0    ciudades_id_ciudad_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ciudades_id_ciudad_seq', 7, true);
          public          postgres    false    214            e           0    0    clientes_id_cliente_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.clientes_id_cliente_seq', 4, true);
          public          postgres    false    228            f           0    0    cobros_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.cobros_id_seq', 19, true);
          public          postgres    false    250            g           0    0    cobros_numero_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.cobros_numero_seq', 1, false);
          public          postgres    false    268            h           0    0    compras_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.compras_id_seq', 45, true);
          public          postgres    false    232            i           0    0    cuentasclientes_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.cuentasclientes_id_seq', 18, true);
          public          postgres    false    254            j           0    0    cuentasproveedores_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.cuentasproveedores_id_seq', 9, true);
          public          postgres    false    256            k           0    0    detalleajuste_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.detalleajuste_id_seq', 115, true);
          public          postgres    false    248            l           0    0 !   detallecobros_iddetallecobros_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.detallecobros_iddetallecobros_seq', 14, true);
          public          postgres    false    252            m           0    0    detallecompras_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.detallecompras_id_seq', 8, true);
          public          postgres    false    236            n           0    0    detallepagos_iddetallepagos_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.detallepagos_iddetallepagos_seq', 5, true);
          public          postgres    false    260            o           0    0    detalleventas_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.detalleventas_id_seq', 31, true);
          public          postgres    false    234            p           0    0    inventario_id_movimiento_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.inventario_id_movimiento_seq', 1, false);
          public          postgres    false    224            q           0    0    marcas_id_marca_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.marcas_id_marca_seq', 13, true);
          public          postgres    false    226            r           0    0    metodos_pago_id_metodo_pago_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.metodos_pago_id_metodo_pago_seq', 7, true);
          public          postgres    false    222            s           0    0    movimientos_caja_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.movimientos_caja_id_seq', 1, false);
          public          postgres    false    266            t           0    0    numero_factura_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.numero_factura_seq', 12, true);
          public          postgres    false    262            u           0    0    pagos_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.pagos_id_seq', 5, true);
          public          postgres    false    258            v           0    0    personales_id_personal_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.personales_id_personal_seq', 6, true);
          public          postgres    false    240            w           0    0    productos_id_producto_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.productos_id_producto_seq', 41, true);
          public          postgres    false    218            x           0    0    proveedores_id_proveedor_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.proveedores_id_proveedor_seq', 6, true);
          public          postgres    false    220            y           0    0    usuarios_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.usuarios_id_seq', 10, true);
          public          postgres    false    238            z           0    0    ventas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.ventas_id_seq', 111, true);
          public          postgres    false    230            {           0    0    ventas_numero_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.ventas_numero_seq', 18, true);
          public          postgres    false    269            Q           2606    35188    Banco Banco_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Banco"
    ADD CONSTRAINT "Banco_pkey" PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."Banco" DROP CONSTRAINT "Banco_pkey";
       public            postgres    false    264            ?           2606    34523    abrircaja abrircaja_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.abrircaja
    ADD CONSTRAINT abrircaja_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.abrircaja DROP CONSTRAINT abrircaja_pkey;
       public            postgres    false    245            A           2606    34551 &   ajusteinventario ajusteinventario_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.ajusteinventario
    ADD CONSTRAINT ajusteinventario_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.ajusteinventario DROP CONSTRAINT ajusteinventario_pkey;
       public            postgres    false    247                       2606    34103    categorias categorias_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);
 D   ALTER TABLE ONLY public.categorias DROP CONSTRAINT categorias_pkey;
       public            postgres    false    217            =           2606    34506    cerrarcaja cerrarcaja_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.cerrarcaja
    ADD CONSTRAINT cerrarcaja_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.cerrarcaja DROP CONSTRAINT cerrarcaja_pkey;
       public            postgres    false    243                       2606    34089    ciudades ciudades_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_pkey PRIMARY KEY (id_ciudad);
 @   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT ciudades_pkey;
       public            postgres    false    215            +           2606    34301    clientes clientes_ci_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_ci_key UNIQUE (ci);
 B   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_ci_key;
       public            postgres    false    229            -           2606    34299    clientes clientes_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public            postgres    false    229            E           2606    35001    cobros cobros_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.cobros
    ADD CONSTRAINT cobros_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.cobros DROP CONSTRAINT cobros_pkey;
       public            postgres    false    251            1           2606    34337    compras compras_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.compras DROP CONSTRAINT compras_pkey;
       public            postgres    false    233            I           2606    35030 $   cuentasclientes cuentasclientes_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.cuentasclientes
    ADD CONSTRAINT cuentasclientes_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.cuentasclientes DROP CONSTRAINT cuentasclientes_pkey;
       public            postgres    false    255            K           2606    35071 *   cuentasproveedores cuentasproveedores_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.cuentasproveedores
    ADD CONSTRAINT cuentasproveedores_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.cuentasproveedores DROP CONSTRAINT cuentasproveedores_pkey;
       public            postgres    false    257            C           2606    34565     detalleajuste detalleajuste_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.detalleajuste
    ADD CONSTRAINT detalleajuste_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.detalleajuste DROP CONSTRAINT detalleajuste_pkey;
       public            postgres    false    249            G           2606    35019     detallecobros detallecobros_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.detallecobros
    ADD CONSTRAINT detallecobros_pkey PRIMARY KEY (iddetallecobros);
 J   ALTER TABLE ONLY public.detallecobros DROP CONSTRAINT detallecobros_pkey;
       public            postgres    false    253            5           2606    34356 "   detallecompras detallecompras_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.detallecompras
    ADD CONSTRAINT detallecompras_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.detallecompras DROP CONSTRAINT detallecompras_pkey;
       public            postgres    false    237            O           2606    35159    detallepagos detallepagos_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.detallepagos
    ADD CONSTRAINT detallepagos_pkey PRIMARY KEY (iddetallepagos);
 H   ALTER TABLE ONLY public.detallepagos DROP CONSTRAINT detallepagos_pkey;
       public            postgres    false    261            3           2606    34344     detalleventas detalleventas_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.detalleventas
    ADD CONSTRAINT detalleventas_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.detalleventas DROP CONSTRAINT detalleventas_pkey;
       public            postgres    false    235            '           2606    34262    inventario inventario_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_movimiento);
 D   ALTER TABLE ONLY public.inventario DROP CONSTRAINT inventario_pkey;
       public            postgres    false    225            )           2606    34275    marcas marcas_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (id_marca);
 <   ALTER TABLE ONLY public.marcas DROP CONSTRAINT marcas_pkey;
       public            postgres    false    227            S           2606    35198 ,   metodos_pago_bancos metodos_pago_bancos_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.metodos_pago_bancos
    ADD CONSTRAINT metodos_pago_bancos_pkey PRIMARY KEY (id_metodo_pago, id_banco);
 V   ALTER TABLE ONLY public.metodos_pago_bancos DROP CONSTRAINT metodos_pago_bancos_pkey;
       public            postgres    false    265    265            %           2606    34215    metodos_pago metodos_pago_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id_metodo_pago);
 H   ALTER TABLE ONLY public.metodos_pago DROP CONSTRAINT metodos_pago_pkey;
       public            postgres    false    223            U           2606    35259 &   movimientos_caja movimientos_caja_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.movimientos_caja
    ADD CONSTRAINT movimientos_caja_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.movimientos_caja DROP CONSTRAINT movimientos_caja_pkey;
       public            postgres    false    267            M           2606    35142    pagos pagos_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.pagos DROP CONSTRAINT pagos_pkey;
       public            postgres    false    259            9           2606    34443    personales personales_ci_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.personales
    ADD CONSTRAINT personales_ci_key UNIQUE (ci);
 F   ALTER TABLE ONLY public.personales DROP CONSTRAINT personales_ci_key;
       public            postgres    false    241            ;           2606    34441    personales personales_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.personales
    ADD CONSTRAINT personales_pkey PRIMARY KEY (id_personal);
 D   ALTER TABLE ONLY public.personales DROP CONSTRAINT personales_pkey;
       public            postgres    false    241            !           2606    34112    productos productos_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);
 B   ALTER TABLE ONLY public.productos DROP CONSTRAINT productos_pkey;
       public            postgres    false    219            #           2606    34203    proveedores proveedores_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor);
 F   ALTER TABLE ONLY public.proveedores DROP CONSTRAINT proveedores_pkey;
       public            postgres    false    221            7           2606    34434    usuarios usuarios_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pkey;
       public            postgres    false    239            /           2606    34320    ventas ventas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.ventas DROP CONSTRAINT ventas_pkey;
       public            postgres    false    231            s           2620    35172 &   compras trigger_asignar_numero_factura    TRIGGER     �   CREATE TRIGGER trigger_asignar_numero_factura BEFORE INSERT ON public.compras FOR EACH ROW EXECUTE FUNCTION public.asignar_numero_factura();
 ?   DROP TRIGGER trigger_asignar_numero_factura ON public.compras;
       public          postgres    false    233    272            u           2620    35088 ,   detallecompras trigger_aumentar_stock_compra    TRIGGER     �   CREATE TRIGGER trigger_aumentar_stock_compra AFTER INSERT ON public.detallecompras FOR EACH ROW EXECUTE FUNCTION public.aumentar_stock_compra();
 E   DROP TRIGGER trigger_aumentar_stock_compra ON public.detallecompras;
       public          postgres    false    237    270            v           2620    35372 -   detallecompras trigger_disminuir_stock_compra    TRIGGER     �   CREATE TRIGGER trigger_disminuir_stock_compra AFTER INSERT ON public.detallecompras FOR EACH ROW EXECUTE FUNCTION public.disminuir_stock_compra();
 F   DROP TRIGGER trigger_disminuir_stock_compra ON public.detallecompras;
       public          postgres    false    237    271            t           2620    35370 +   detalleventas trigger_disminuir_stock_venta    TRIGGER     �   CREATE TRIGGER trigger_disminuir_stock_venta AFTER INSERT ON public.detalleventas FOR EACH ROW EXECUTE FUNCTION public.disminuir_stock_venta();
 D   DROP TRIGGER trigger_disminuir_stock_venta ON public.detalleventas;
       public          postgres    false    235    287            r           2620    35353 !   productos trigger_verificar_stock    TRIGGER     �   CREATE TRIGGER trigger_verificar_stock BEFORE INSERT OR DELETE OR UPDATE ON public.productos FOR EACH ROW EXECUTE FUNCTION public.verificar_stock();
 :   DROP TRIGGER trigger_verificar_stock ON public.productos;
       public          postgres    false    219    275            Y           2606    34302     clientes clientes_id_ciudad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_id_ciudad_fkey FOREIGN KEY (id_ciudad) REFERENCES public.ciudades(id_ciudad);
 J   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_id_ciudad_fkey;
       public          postgres    false    3357    215    229            j           2606    35072 4   cuentasproveedores cuentasproveedores_idcompras_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cuentasproveedores
    ADD CONSTRAINT cuentasproveedores_idcompras_fkey FOREIGN KEY (idcompras) REFERENCES public.compras(id);
 ^   ALTER TABLE ONLY public.cuentasproveedores DROP CONSTRAINT cuentasproveedores_idcompras_fkey;
       public          postgres    false    233    257    3377            m           2606    35160 2   detallepagos detallepagos_idcuentaproveedores_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detallepagos
    ADD CONSTRAINT detallepagos_idcuentaproveedores_fkey FOREIGN KEY (idcuentaproveedores) REFERENCES public.cuentasproveedores(id);
 \   ALTER TABLE ONLY public.detallepagos DROP CONSTRAINT detallepagos_idcuentaproveedores_fkey;
       public          postgres    false    261    257    3403            n           2606    35165 &   detallepagos detallepagos_idpagos_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detallepagos
    ADD CONSTRAINT detallepagos_idpagos_fkey FOREIGN KEY (idpagos) REFERENCES public.pagos(id);
 P   ALTER TABLE ONLY public.detallepagos DROP CONSTRAINT detallepagos_idpagos_fkey;
       public          postgres    false    259    261    3405            o           2606    35204    metodos_pago_bancos fk_banco    FK CONSTRAINT     �   ALTER TABLE ONLY public.metodos_pago_bancos
    ADD CONSTRAINT fk_banco FOREIGN KEY (id_banco) REFERENCES public."Banco"(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.metodos_pago_bancos DROP CONSTRAINT fk_banco;
       public          postgres    false    265    3409    264            p           2606    35199 #   metodos_pago_bancos fk_metodos_pago    FK CONSTRAINT     �   ALTER TABLE ONLY public.metodos_pago_bancos
    ADD CONSTRAINT fk_metodos_pago FOREIGN KEY (id_metodo_pago) REFERENCES public.metodos_pago(id_metodo_pago) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.metodos_pago_bancos DROP CONSTRAINT fk_metodos_pago;
       public          postgres    false    3365    223    265            Z           2606    34321    ventas id_cliente    FK CONSTRAINT     ~   ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT id_cliente FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente);
 ;   ALTER TABLE ONLY public.ventas DROP CONSTRAINT id_cliente;
       public          postgres    false    231    3373    229            [           2606    34362    detalleventas id_producto    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalleventas
    ADD CONSTRAINT id_producto FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) NOT VALID;
 C   ALTER TABLE ONLY public.detalleventas DROP CONSTRAINT id_producto;
       public          postgres    false    3361    219    235            ]           2606    34378    detallecompras id_producto    FK CONSTRAINT     �   ALTER TABLE ONLY public.detallecompras
    ADD CONSTRAINT id_producto FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) NOT VALID;
 D   ALTER TABLE ONLY public.detallecompras DROP CONSTRAINT id_producto;
       public          postgres    false    237    3361    219            `           2606    34531    cerrarcaja idabrircaja    FK CONSTRAINT     �   ALTER TABLE ONLY public.cerrarcaja
    ADD CONSTRAINT idabrircaja FOREIGN KEY (idabrircaja) REFERENCES public.abrircaja(id) NOT VALID;
 @   ALTER TABLE ONLY public.cerrarcaja DROP CONSTRAINT idabrircaja;
       public          postgres    false    243    245    3391            e           2606    35008    cobros idabrircaja    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros
    ADD CONSTRAINT idabrircaja FOREIGN KEY (idabrircaja) REFERENCES public.abrircaja(id) NOT VALID;
 <   ALTER TABLE ONLY public.cobros DROP CONSTRAINT idabrircaja;
       public          postgres    false    3391    251    245            c           2606    34576    detalleajuste idajusteinve    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalleajuste
    ADD CONSTRAINT idajusteinve FOREIGN KEY (idajusteinve) REFERENCES public.ajusteinventario(id) NOT VALID;
 D   ALTER TABLE ONLY public.detalleajuste DROP CONSTRAINT idajusteinve;
       public          postgres    false    247    249    3393            f           2606    35003    cobros idclientes    FK CONSTRAINT     �   ALTER TABLE ONLY public.cobros
    ADD CONSTRAINT idclientes FOREIGN KEY (idclientes) REFERENCES public.clientes(id_cliente) NOT VALID;
 ;   ALTER TABLE ONLY public.cobros DROP CONSTRAINT idclientes;
       public          postgres    false    251    3373    229            g           2606    35036    detallecobros idcobros    FK CONSTRAINT     �   ALTER TABLE ONLY public.detallecobros
    ADD CONSTRAINT idcobros FOREIGN KEY (idcobros) REFERENCES public.cobros(id) NOT VALID;
 @   ALTER TABLE ONLY public.detallecobros DROP CONSTRAINT idcobros;
       public          postgres    false    253    3397    251            ^           2606    34357    detallecompras idcompra    FK CONSTRAINT     �   ALTER TABLE ONLY public.detallecompras
    ADD CONSTRAINT idcompra FOREIGN KEY (idcompra) REFERENCES public.compras(id) NOT VALID;
 A   ALTER TABLE ONLY public.detallecompras DROP CONSTRAINT idcompra;
       public          postgres    false    237    3377    233            h           2606    35041    detallecobros idcuentaclientes    FK CONSTRAINT     �   ALTER TABLE ONLY public.detallecobros
    ADD CONSTRAINT idcuentaclientes FOREIGN KEY (idcuentaclientes) REFERENCES public.cuentasclientes(id) NOT VALID;
 H   ALTER TABLE ONLY public.detallecobros DROP CONSTRAINT idcuentaclientes;
       public          postgres    false    255    253    3401            d           2606    34581    detalleajuste idproductos    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalleajuste
    ADD CONSTRAINT idproductos FOREIGN KEY (idproductos) REFERENCES public.productos(id_producto) NOT VALID;
 C   ALTER TABLE ONLY public.detalleajuste DROP CONSTRAINT idproductos;
       public          postgres    false    3361    219    249            a           2606    34524    abrircaja idusuario    FK CONSTRAINT     w   ALTER TABLE ONLY public.abrircaja
    ADD CONSTRAINT idusuario FOREIGN KEY (idusuario) REFERENCES public.usuarios(id);
 =   ALTER TABLE ONLY public.abrircaja DROP CONSTRAINT idusuario;
       public          postgres    false    245    239    3383            b           2606    34571    ajusteinventario idusuarios    FK CONSTRAINT     �   ALTER TABLE ONLY public.ajusteinventario
    ADD CONSTRAINT idusuarios FOREIGN KEY (idusuarios) REFERENCES public.usuarios(id) NOT VALID;
 E   ALTER TABLE ONLY public.ajusteinventario DROP CONSTRAINT idusuarios;
       public          postgres    false    239    3383    247            \           2606    34367    detalleventas idventa    FK CONSTRAINT        ALTER TABLE ONLY public.detalleventas
    ADD CONSTRAINT idventa FOREIGN KEY (idventa) REFERENCES public.ventas(id) NOT VALID;
 ?   ALTER TABLE ONLY public.detalleventas DROP CONSTRAINT idventa;
       public          postgres    false    231    3375    235            i           2606    35031    cuentasclientes idventas    FK CONSTRAINT     y   ALTER TABLE ONLY public.cuentasclientes
    ADD CONSTRAINT idventas FOREIGN KEY (idventas) REFERENCES public.ventas(id);
 B   ALTER TABLE ONLY public.cuentasclientes DROP CONSTRAINT idventas;
       public          postgres    false    255    231    3375            X           2606    34263 &   inventario inventario_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto);
 P   ALTER TABLE ONLY public.inventario DROP CONSTRAINT inventario_id_producto_fkey;
       public          postgres    false    219    225    3361            q           2606    35260 2   movimientos_caja movimientos_caja_idabrircaja_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.movimientos_caja
    ADD CONSTRAINT movimientos_caja_idabrircaja_fkey FOREIGN KEY (idabrircaja) REFERENCES public.abrircaja(id);
 \   ALTER TABLE ONLY public.movimientos_caja DROP CONSTRAINT movimientos_caja_idabrircaja_fkey;
       public          postgres    false    3391    245    267            k           2606    35143    pagos pagos_idabrircaja_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_idabrircaja_fkey FOREIGN KEY (idabrircaja) REFERENCES public.abrircaja(id);
 F   ALTER TABLE ONLY public.pagos DROP CONSTRAINT pagos_idabrircaja_fkey;
       public          postgres    false    245    259    3391            l           2606    35148    pagos pagos_idproveedores_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_idproveedores_fkey FOREIGN KEY (idproveedores) REFERENCES public.proveedores(id_proveedor);
 H   ALTER TABLE ONLY public.pagos DROP CONSTRAINT pagos_idproveedores_fkey;
       public          postgres    false    3363    259    221            _           2606    34444 #   personales personales_idciudad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.personales
    ADD CONSTRAINT personales_idciudad_fkey FOREIGN KEY (idciudad) REFERENCES public.ciudades(id_ciudad);
 M   ALTER TABLE ONLY public.personales DROP CONSTRAINT personales_idciudad_fkey;
       public          postgres    false    241    215    3357            V           2606    34113 %   productos productos_id_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria);
 O   ALTER TABLE ONLY public.productos DROP CONSTRAINT productos_id_categoria_fkey;
       public          postgres    false    217    3359    219            W           2606    34204 &   proveedores proveedores_id_ciudad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_id_ciudad_fkey FOREIGN KEY (id_ciudad) REFERENCES public.ciudades(id_ciudad);
 P   ALTER TABLE ONLY public.proveedores DROP CONSTRAINT proveedores_id_ciudad_fkey;
       public          postgres    false    215    221    3357            7   D   x��;
�@����~� Q��l��ϡS�+\04�+Ό��(qn����t��z[ƿ�\���w      $   k   x�u�;
�0��zs���M���UX	����CE�D�T?|�%�:F��4L1v�Bj\	�Mu	�,2hKn�@p���y.eI�Po�'��l�p9u�<��ԭ2��O8~      &   w   x�3�4202�5��52�LI-N.M�+��tv�sv�qt��4�24DV�X�V������UbDX�1v�P� �q������؜��� �ߒ�C�6B}`h�6������ ��\�         T   x�3�tLN�,I-�2���J-J,�2�H��
�r�^XX���X������_T��e����[��_�e��ZT���	d��qqq ���      "   h   x�m��
� г�/�ή��:����H(��=���S��%{Nܺ��Πc�R��I3��1d�(�Xc���G�!�Uz��O�F,��*�	�2�         L   x�3�t�,MILQHI�Qp-.I�2�t�KN,�KL�<�9�˄381O�'�(5�*�˔ӧ��4�ːӱ�4�"F��� [*=         L   x�3��*M�S8��(����Ș3%5-5�8�(�����Ӑˈ�1/Q����\�S3�Ĳ���
N#�=... w*�      *   h   x�}�;� ��z�.�AIbLHV6���ClD��Η��Zt��"���F?-��y��<�`_��9$�vy�<��Q�s����� �����tݫl�ao �34         `   x�31�4�4202�54�5��t��K�ɬJL��4�062�44�L��+
p�#�5�t�+�)434620�44�L.JM�,�4�i*X1����=... �� �      .   s   x���;�@��s�D{�e��P������7�D:�zc)��]UbSKm�˱ܖ�.=�w����GUD�5�3�oD5D���!Gl���V���c_��?��
�a�,��� ��7D      0   /   x���434620�4BN##]C#]Cs� GwGNc�=... ��      (   �   x�u�;�0��ٹ��;3e� HU�v`!Rĥ9C/ָe{���qR<P�kk���2^��T8�)�ɢH���i�������]�(<C �+@d �Vdʱ�����#������D��~ߓ)0�F��&(Z�#�H�zD�%;qc�����H�������o'�GaG�1���Ƙ��Ә      ,   4   x�ʹ�0A{'�P.�'�{��+���xǁ=>�8�[ʙ���?�nA         2   x�=ɱ  �:�	�0�?��X�}A7d�ӹ ���Ɔ���$���      4      x�3�4������ 	\h         �   x�U��1�C0.]�����~��C%�2`0��Hq� ȑ|H '��&��cG�2����ER��/������mn���۶:*kp�AbUM���Kt6���F�����ӹ�W�B�
�*���+�5>���G���|6�            x������ � �         g   x���
�@��ޏ	񑇥"6J��I3�:	�k�?�dœ�2G��YX������.�j�-򊗬ob��;��6�FVx�n���3;��5&&|�H��H�         U   x�3�I,�J-ITHIUp.:�2%�$�ˈ3�(1�8-�(5/93Q�)1/9�(3�˘�5-5�$�,�˔30�ˌ�9#��4�+F��� W      8   >   x�ʱ  ���=����(�̊f]:d��4�qs7ƃ<x��ŋ/^�mIe+      :      x������ � �      2   ,   x�3�4202�54�54�t��s��rt��4�44�4����� ���          �   x�%�=N�0����)rG�$qIB ��i,lV��6�	{�-)��cQ�<zg���oM�6�'����cczO����_&��xu�ܗ|ٯ+�e�K�$)�5�oa���#彆�k��k��^#^䚖�H�Av�i8���f&Xaq�^J��qcb�1=���(����rN8<m����#禩GI�_���R��@��Q���G�      
   �  x�mT;s�0��_��]t�d�1:�uK�ks�%L�6s4��r���ءC�[W���?d�g�x} >��ޫ�q�R��
᫒�7J����;d�A�b��ѣءm�U^�P���y���\
ň>0�	dt$���8�R�-�Z�J�`Q-��FS�.���J��ɾ����-�,�@��{�MnV�a�'�ڠ?��J���}�*�N��:�y�>q��9:��s�k_쵍��bǭ9wm��[���E���􍡒l�IQч��<��%��'�C��J���"?(&l:�&0��L��J�_B����M��J����l�L���4Bg�����H�Jo\�����r2��l�$�·-�j���K�k��@�~<���2!��7�k�d:����}�qԦ�gyR�A��J7xm3X�Uԉ��c�Kx�j�ٱ�L���^6.�l�ht�UJ��#��b^�
�p{�}yY��K�����9H1�m���7�]�J�,.�,���G;��x�^ouP���WU'��V��i�|��!R8����p��3Z�6����F�#\�������tM��:q����"3��c�G��@�#MN������lIi*��rp�h:[��0Q��T+ɤ��K⢁���Ӯ�g�3�g�ِ��伬�+�z����:\�WO7�2W0�6�kf���i�$�yN�9         C   x�3�t��M�K�442�4��0���s3s���s9��8�s�2K�9ML�����"Hꌸb���� �
�         j   x�3�,�,�L�KTHO,J�Ls9��9]|=�<�C�]��80�!grbNYfI�Br~NnbgJfjz>Xwhp�c��?}�>�^�~�9�Y@]��=������� 2�&;         �   x���9�0��܅���L�S�A!)"MN���E(��g�	%���$n���ݧiG9?��c���
��j
+~=�n��
�������Yk"����PI�f�S�����34{$$�4yq�Te�=Q�{m,��%��	�y�.m��CڡYk���l��@��O�S3�0m�E+�-��U�؝Jͤ���B�XC�/`�Uq��^ ;�p<���>���.ҝ�_������d     