--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.4

-- Started on 2017-09-16 22:17:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2435 (class 1262 OID 19675)
-- Name: dw4j; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE dw4j WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Argentina.1252' LC_CTYPE = 'Spanish_Argentina.1252';


\connect dw4j

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12387)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2437 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 222 (class 1255 OID 19676)
-- Name: f_buscar_categoria(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_categoria(p_idcategoria integer, p_idlibreria integer, p_categoria character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_cat refcursor;
  begin


    if p_idCategoria > 0 then

        open cursor_cat for
          select c.id_categoria, c.id_libreria, c.categoria, c.id_estatus, e.estatus
              from categoria c inner join estatus e on c.id_estatus=e.id_estatus
          where c.id_categoria=p_idcategoria
          order by c.categoria;

    elsif p_idLibreria > 0 then

        open cursor_cat for
          select c.id_categoria, c.id_libreria, c.categoria, c.id_estatus, e.estatus
              from categoria c inner join estatus e on c.id_estatus=e.id_estatus
          where c.id_libreria=p_idlibreria
          order by c.categoria;

    elsif p_categoria is not null then
        open cursor_cat for
          select c.id_categoria, c.id_libreria, c.categoria, c.id_estatus, e.estatus
              from categoria c inner join estatus e on c.id_estatus=e.id_estatus
          where c.categoria=p_categoria
          order by c.categoria;
    else
        open cursor_cat for
          select c.id_categoria, c.id_libreria, c.categoria, c.id_estatus, e.estatus
              from categoria c inner join estatus e on c.id_estatus=e.id_estatus
           order by c.categoria;
    end if;
    return cursor_cat;
    close cursor_cat;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 223 (class 1255 OID 19677)
-- Name: f_buscar_causas_rechazo(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_causas_rechazo() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_causa refcursor;
  begin

    open cursor_causa for
      select id_causa, causa from causa;

    return cursor_causa;
    close cursor_causa;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 224 (class 1255 OID 19678)
-- Name: f_buscar_configuracion(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_configuracion() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_conf refcursor;
  begin

    open cursor_conf for
      select * from configuracion;

    return cursor_conf;
    close cursor_conf;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 239 (class 1255 OID 19679)
-- Name: f_buscar_datos_combo(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_datos_combo(p_idcodigoindice integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_cbo refcursor;
  begin

    open cursor_cbo for
       select l.id_lista, l.codigo_indice, l.descripcion, a.indice
             from lista_desplegables l inner join indices a on l.codigo_indice=a.codigo
       where l.codigo_indice=p_idcodigoindice
       order by l.descripcion;


    return cursor_cbo;
    close cursor_cbo;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 240 (class 1255 OID 19680)
-- Name: f_buscar_datosdoc(integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_datosdoc(p_idinfodocumento integer, p_versiondoc integer, p_idexpediente character varying, p_numerodoc integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE

    cursor_doc refcursor;
  begin

    open cursor_doc for
      select i.*, d.*, c.id_categoria, s.id_subcategoria,
             t.tipo_documento tipoDoc, e.estatus_documento estatusArchivo
          from infodocumento i
          inner join datos_infodocumento d on i.id_infodocumento=d.id_infodocumento
          inner join tipodocumento t on i.id_documento=t.id_documento
          inner join subcategoria s on t.id_subcategoria=s.id_subcategoria
          inner join categoria c on s.id_categoria=c.id_categoria
          inner join estatus_documento e on i.estatus_documento=e.id_estatus_documento
      where i.id_infodocumento=p_idinfodocumento and i.id_expediente=p_idexpediente
            and i.version=p_versiondoc and i.numero_documento=p_numerodoc
            and i.estatus_documento=2;

     return cursor_doc;
     close cursor_doc;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 221 (class 1255 OID 19681)
-- Name: f_buscar_estatus(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_estatus(p_idestatus integer, p_estatus character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_est refcursor;
  begin

    if p_idestatus > 0 then
      open cursor_est for
         select id_estatus, estatus from estatus where id_estatus=p_idestatus;
    elsif p_estatus is not null then
      open cursor_est for
         select id_estatus, estatus from estatus where estatus=p_estatus;
    end if;

    return cursor_est;
    close cursor_est;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 241 (class 1255 OID 19682)
-- Name: f_buscar_expediente(character varying, integer, integer, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_expediente(p_expediente character varying, p_idlibreria integer, p_idcategoria integer, p_flag character) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_expe refcursor;
  begin

   if (p_flag = '1') then

      open cursor_expe for
         select distinct e.expediente, e.id_libreria, e.id_categoria, e.valor, e.fecha_indice, a.id_indice,
                c.categoria, l.libreria, a.indice, a.tipo, a.codigo, a.clave
             from expedientes e inner join indices a
                     on (e.id_categoria=a.id_categoria and e.id_indice=a.id_indice)
                  inner join categoria c on e.id_categoria=c.id_categoria
                  inner join libreria l on e.id_libreria=l.id_libreria
              where e.expediente=p_expediente and a.id_categoria=p_idcategoria
                and e.id_libreria=p_idlibreria
              order by a.id_indice;
    else
      open cursor_expe for
         select e.*, c.categoria, l.libreria
             from expedientes e inner join categoria c on e.id_categoria=c.id_categoria
                  inner join libreria l on e.id_libreria=l.id_libreria
             where e.expediente=p_expediente;
    end if;
    return cursor_expe;
    close cursor_expe;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 242 (class 1255 OID 19683)
-- Name: f_buscar_expediente_dinamico(character varying, character varying, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_expediente_dinamico(p_filtro character varying, p_idexpediente character varying, p_flag character) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_expe refcursor;
    query character varying;
  begin

   query:=null;
   
  if p_flag = '1' then
  
	  query:='select distinct e.expediente, e.valor, e.fecha_indice, i.* 
		 from expedientes e 
		 inner join indices i on e.id_indice=i.id_indice 
		 inner join libreria l on e.id_libreria=l.id_libreria 
		 inner join categoria c on e.id_categoria=c.id_categoria 
		 inner join subcategoria s on c.id_categoria=s.id_categoria 
		 inner join tipodocumento t on s.id_subcategoria=t.id_subcategoria '
		 ||p_filtro;
		 
   elsif p_flag = '0' then
   
          query:='select distinct e.expediente, e.valor, e.fecha_indice, i.*  
		 from expedientes e 
		 inner join indices i on e.id_indice=i.id_indice 
		 inner join infodocumento d on e.expediente=d.id_expediente 
		 inner join libreria l on e.id_libreria=l.id_libreria 
		 inner join categoria c on e.id_categoria=c.id_categoria 
		 inner join subcategoria s on c.id_categoria=s.id_categoria 
		 inner join tipodocumento t on s.id_subcategoria=t.id_subcategoria '
                 ||p_filtro;
                 
   end if;

   if query is null and p_filtro is null then

         open cursor_expe for
           select distinct i.indice, e.valor, e.fecha_indice, i.id_indice, i.id_categoria, i.tipo, i.codigo, i.clave
		    from expedientes e 
		    inner join indices i on e.id_indice=i.id_indice 
		    where e.expediente=p_idexpediente
		    order by i.id_indice;
		    
        return cursor_expe;
        close cursor_expe;
   else
     OPEN cursor_expe FOR execute query;
      return cursor_expe;
      close cursor_expe;
   end if;
   	
  
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 243 (class 1255 OID 19684)
-- Name: f_buscar_expediente_reporte(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_expediente_reporte(p_idcategoria integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_expe refcursor;
  begin

   open cursor_expe for
   SELECT distinct e.expediente, e.valor, e.fecha_indice,  
        i.id_indice, i.indice, i.tipo, i.codigo, i.clave, e.id_libreria, e.id_categoria
  FROM expedientes e inner join indices i on e.id_indice=i.id_indice
  where e.id_categoria=p_idcategoria
  order by e.expediente, i.id_indice;

    return cursor_expe;
    close cursor_expe;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 244 (class 1255 OID 19685)
-- Name: f_buscar_fabrica(character varying, date, date, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_fabrica(p_usuario character varying, p_fechadesde date, p_fechahasta date, p_estatusdocumento integer, p_idcategoria integer, p_expediente character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_user refcursor;
    sfabrica char(1);
  begin

    select t.fabrica into sfabrica from fabrica t where t.usuario=p_usuario;

    if p_fechadesde is not null and p_fechahasta is not null then

      open cursor_user for
        select distinct e.expediente, e.valor, e.fecha_indice, i.*, f.fabrica
           from infodocumento d inner join expedientes e
              on d.id_expediente=e.expediente
           inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
           inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
           inner join fabrica f on f.usuario=di.usuario_digitalizo
           inner join usuario u on u.id_usuario=f.usuario
         where di.fecha_digitalizacion between CAST (p_fechadesde AS DATE)
           and CAST (p_fechahasta AS DATE)
           and d.estatus_documento=p_estatusdocumento
           and f.fabrica=sfabrica
           and i.id_categoria=p_idcategoria
           order by e.expediente, i.id_indice;

    elsif p_fechadesde is not null then

        open cursor_user for
        select distinct e.expediente, e.valor, e.fecha_indice, i.*, f.fabrica
           from infodocumento d inner join expedientes e
              on d.id_expediente=e.expediente
           inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
           inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
           inner join fabrica f on f.usuario=di.usuario_digitalizo
           inner join usuario u on u.id_usuario=f.usuario
         where di.fecha_digitalizacion >= CAST (p_fechadesde AS DATE)
           and d.estatus_documento=p_estatusdocumento
           and f.fabrica=sfabrica
           and i.id_categoria=p_idcategoria
           order by e.expediente, i.id_indice;

    elsif p_fechahasta is not null then

        open cursor_user for
        select distinct e.expediente, e.valor, e.fecha_indice, i.*, f.fabrica
           from infodocumento d inner join expedientes e
              on d.id_expediente=e.expediente
           inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
           inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
           inner join fabrica f on f.usuario=di.usuario_digitalizo
           inner join usuario u on u.id_usuario=f.usuario
         where di.fecha_digitalizacion <= CAST (p_fechahasta AS DATE)
           and d.estatus_documento=p_estatusdocumento
           and f.fabrica=sfabrica
           and i.id_categoria=p_idcategoria
           order by e.expediente, i.id_indice;

    elsif p_expediente is not null then

         open cursor_user for
            select distinct e.expediente, e.valor, e.fecha_indice, i.*, f.fabrica
               from infodocumento d inner join expedientes e
                  on d.id_expediente=e.expediente
               inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
               inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
               inner join fabrica f on f.usuario=di.usuario_digitalizo
               inner join usuario u on u.id_usuario=f.usuario
             where d.id_expediente = p_expediente
               and d.estatus_documento=p_estatusdocumento
               and f.fabrica=sfabrica
               and i.id_categoria=p_idcategoria
               order by e.expediente, i.id_indice;
    else

      open cursor_user for
        select distinct e.expediente, e.valor, e.fecha_indice, i.*, f.fabrica
           from infodocumento d inner join expedientes e
              on d.id_expediente=e.expediente
           inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
           inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
           inner join fabrica f on f.usuario=di.usuario_digitalizo
           inner join usuario u on u.id_usuario=f.usuario
         where d.estatus_documento=p_estatusdocumento
           and f.fabrica=sfabrica
           and i.id_categoria=p_idcategoria
           order by e.expediente, i.id_indice;
    end if;

    return cursor_user;
    close cursor_user;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 245 (class 1255 OID 19686)
-- Name: f_buscar_fisico_documento(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_fisico_documento(p_iddocumento integer, p_numerodoc integer, p_idexpediente character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_doc refcursor;
  begin

    open cursor_doc for
        select i.*, c.id_categoria, s.id_subcategoria, t.tipo_documento tipoDoc,
               e.estatus_documento estatusArchivo
           from infodocumento i inner join datos_infodocumento d on i.id_infodocumento=d.id_infodocumento
                                inner join estatus_documento e on i.estatus_documento=e.id_estatus_documento
                                inner join tipodocumento t on i.id_documento=t.id_documento
                                inner join subcategoria s on t.id_subcategoria=s.id_subcategoria
                                inner join categoria c on s.id_categoria=c.id_categoria
           where i.id_documento=p_iddocumento and i.id_expediente=p_idexpediente
                 and i.numero_documento=p_numerodoc and i.estatus_documento<>2
           order by i.version desc;

  return cursor_doc;
  close cursor_doc;
  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 246 (class 1255 OID 19687)
-- Name: f_buscar_foto_ficha(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_foto_ficha(p_idexpediente character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
 DECLARE
    cursor_ficha refcursor;
  begin

    open cursor_ficha for
        select t.id_documento, i.id_infodocumento, i.nombre_archivo as nombreArchivo,
               t.tipo_documento as tipoDocumento, i.estatus_documento, i.ruta_archivo
          from tipodocumento t inner join infodocumento i on t.id_documento=i.id_documento
          where i.id_expediente=p_idexpediente and t.ficha='1';

    return cursor_ficha;
    close cursor_ficha;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 247 (class 1255 OID 19688)
-- Name: f_buscar_indice_datosadicional(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_indice_datosadicional(p_idtipodocumento integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_dato refcursor;
  begin

    open cursor_dato for
       select *
         from dato_adicional t
         where t.id_documento = p_idtipodocumento
         order by t.id_dato_adicional;

    return cursor_dato;
    close cursor_dato;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 225 (class 1255 OID 19689)
-- Name: f_buscar_indices(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_indices(p_idcategoria integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_arg refcursor;
  begin

    open cursor_arg for
       select * from indices i where id_categoria=p_idcategoria order by i.id_indice;
    return cursor_arg;
    close cursor_arg;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 248 (class 1255 OID 19690)
-- Name: f_buscar_infodocumento(character varying, character varying, integer, character, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_infodocumento(p_idexpediente character varying, p_ids_documento character varying, p_estatusdoc integer, p_redigitalizo character, p_estatusaprobado integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_infodoc refcursor;
    query character varying;
  begin

   if p_estatusaprobado = 1 then
   
      --open cursor_infodoc for
        query:='select distinct i.id_infodocumento, t.tipo_documento tipoDoc, t.id_documento,
               i.nombre_archivo, i.ruta_archivo, i.paginas, i.version, i.formato, i.id_expediente,
               i.numero_documento, i.fecha_vencimiento, d.dato_adicional, d.fecha_digitalizacion,
               i.estatus_documento idStatus, d.usuario_digitalizo, d.fecha_aprobacion, d.usuario_aprobacion,
               d.fecha_rechazo, d.usuario_rechazo, d.motivo_rechazo, d.causa_rechazo, i.re_digitalizado,
               s.estatus_documento, t.dato_adicional as datipodoc
           from infodocumento i inner join datos_infodocumento d on i.id_infodocumento=d.id_infodocumento
                inner join tipodocumento t on i.id_documento=t.id_documento
                inner join expedientes e on e.expediente=i.id_expediente
                inner join estatus_documento s on s.id_estatus_documento=i.estatus_documento
           where i.id_expediente='''||p_idexpediente||'''
                 --and i.id_documento=p_ids_documento
                 and i.id_documento in ('||p_ids_documento||')
                 and (i.estatus_documento='||p_estatusdoc||' or i.estatus_documento='||p_estatusaprobado||')
                 and i.re_digitalizado='''||p_redigitalizo||'''
           order by t.tipo_documento, i.numero_documento, i.version desc';
   else

     --open cursor_infodoc for
        query:='select distinct i.id_infodocumento, t.tipo_documento tipoDoc, t.id_documento,
               i.nombre_archivo, i.ruta_archivo, i.paginas, i.version, i.formato, i.id_expediente,
               i.numero_documento, i.fecha_vencimiento, d.dato_adicional, d.fecha_digitalizacion,
               i.estatus_documento idStatus, d.usuario_digitalizo, d.fecha_aprobacion, d.usuario_aprobacion,
               d.fecha_rechazo, d.usuario_rechazo, d.motivo_rechazo, d.causa_rechazo, i.re_digitalizado,
               s.estatus_documento, t.dato_adicional as datipodoc
           from infodocumento i inner join datos_infodocumento d on i.id_infodocumento=d.id_infodocumento
                inner join tipodocumento t on i.id_documento=t.id_documento
                inner join expedientes e on e.expediente=i.id_expediente
                inner join estatus_documento s on s.id_estatus_documento=i.estatus_documento
           where e.expediente='''||p_idexpediente||'''
                 --and i.id_documento=p_ids_documento
                 and i.id_documento in ('||p_ids_documento||')
                 and i.estatus_documento='||p_estatusdoc||' and i.re_digitalizado='''||p_redigitalizo||'''
           order by t.tipo_documento, i.numero_documento, i.version desc';

   end if;

    OPEN cursor_infodoc FOR execute query;
   
    return cursor_infodoc;
    close cursor_infodoc;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 249 (class 1255 OID 19691)
-- Name: f_buscar_infodocumento_elimina(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_infodocumento_elimina(p_idinfodocumento integer, p_iddocumento integer, p_idexpediente character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
     cursor_info refcursor;
  begin

  if p_idinfodocumento > 0 then

    open cursor_info for
    select * from infodocumento where id_infodocumento=p_idinfodocumento;

  elsif p_iddocumento > 0 then

    open cursor_info for
    select * from infodocumento i inner join tipodocumento t on i.id_documento=t.id_documento
    where i.id_documento=p_iddocumento and i.id_expediente=p_idexpediente
    order by numero_documento, version;

  end if;
  return cursor_info;
  close cursor_info;
  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 250 (class 1255 OID 19692)
-- Name: f_buscar_informaciondoc(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_informaciondoc(p_idsdocumento integer, p_idexpediente character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE

  cursor_infdoc refcursor;

  begin

    open cursor_infdoc for
         select distinct i.id_infodocumento, t.tipo_documento tipoDoc, t.id_documento, i.nombre_archivo,
              i.ruta_archivo, i.paginas, i.formato, i.version, i.id_expediente, i.numero_documento,
              i.fecha_vencimiento, d.dato_adicional, d.fecha_digitalizacion, d.usuario_digitalizo,
              i.estatus_documento, d.fecha_aprobacion, d.usuario_aprobacion, d.fecha_rechazo,
              d.usuario_rechazo, d.motivo_rechazo, d.causa_rechazo, i.re_digitalizado,
              s.estatus_documento
            from infodocumento i
            inner join datos_infodocumento d on i.id_infodocumento=d.id_infodocumento
            inner join tipodocumento t on i.id_documento=t.id_documento
            inner join expedientes e on i.id_expediente=e.expediente
            inner join estatus_documento s on i.estatus_documento=s.id_estatus_documento
            --where e.id_expediente=p_idexpediente and i.id_documento in (p_idsdocumento)
            where i.id_expediente=p_idexpediente and i.id_documento=p_idsdocumento
                  and i.estatus_documento=2 and i.re_digitalizado=0;
            /*select distinct i.id_infodocumento, t.tipo_documento tipoDoc, t.id_documento, i.nombre_archivo,
              i.ruta_archivo, i.paginas, i.formato, i.version, i.id_expediente, i.numero_documento,
              i.fecha_vencimiento, d.dato_adicional, d.fecha_digitalizacion, d.usuario_digitalizo,
              i.estatus_documento, d.fecha_aprobacion, d.usuario_aprobacion, d.fecha_rechazo,
              d.usuario_rechazo, d.motivo_rechazo, d.causa_rechazo, i.re_digitalizado,
              s.estatus_documento
            from infodocumento i
            inner join datos_infodocumento d on i.id_infodocumento=d.id_infodocumento
            inner join tipodocumento t on i.id_documento=t.id_documento
            inner join expediente e on i.id_expediente=e.id_expediente
            inner join estatus_documento s on i.estatus_documento=s.id_estatus_documento
            --where e.id_expediente=p_idexpediente and i.id_documento in (p_idsdocumento)
            where i.id_expediente=p_idexpediente and i.id_documento=p_idsdocumento
                  and i.estatus_documento=2 and i.re_digitalizado=0;*/

       return cursor_infdoc;
       close cursor_infdoc;
	   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 251 (class 1255 OID 19693)
-- Name: f_buscar_lib_cat_indice_perfil(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_lib_cat_indice_perfil() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$  DECLARE
    cursor_user refcursor;
  begin
   
    open cursor_user for
        select  p.id_usuario usuario, r.rol,
                p.id_libreria, l.libreria, el.estatus status_lib,
                p.id_categoria, c.categoria, i.id_indice, i.indice, i.clave, 
                i.tipo, i.codigo, ec.estatus status_cat
           from perfil p
                inner join rol r on p.id_rol=r.id_rol
                inner join libreria l on p.id_libreria=l.id_libreria
                inner join estatus el on l.id_estatus=el.id_estatus
                inner join categoria c on p.id_categoria=c.id_categoria
                inner join estatus ec on c.id_estatus=ec.id_estatus
                inner join indices i on i.id_categoria=c.id_categoria
           where p.id_usuario=p_usuario and r.rol=p_perfil and i.clave != ''
                 and i.clave != 'o' and i.clave != 'O'
           order by l.libreria, c.categoria, i.clave desc;
    return cursor_user;
    close cursor_user;
  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 252 (class 1255 OID 19694)
-- Name: f_buscar_lib_cat_indice_perfil(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_lib_cat_indice_perfil(p_usuario character varying, p_perfil character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_user refcursor;
  begin
   
    open cursor_user for
        select  p.id_usuario usuario, r.rol,
                p.id_libreria, l.libreria, el.estatus status_lib,
                p.id_categoria, c.categoria, i.id_indice, i.indice, i.clave, 
                i.tipo, i.codigo, ec.estatus status_cat
           from perfil p
                inner join rol r on p.id_rol=r.id_rol
                inner join libreria l on p.id_libreria=l.id_libreria
                inner join estatus el on l.id_estatus=el.id_estatus
                inner join categoria c on p.id_categoria=c.id_categoria
                inner join estatus ec on c.id_estatus=ec.id_estatus
                inner join indices i on i.id_categoria=c.id_categoria
           where p.id_usuario=p_usuario and r.rol=p_perfil and i.clave != ''
                 and i.clave != 'o' and i.clave != 'O'
           order by l.libreria, c.categoria, i.clave desc;
    return cursor_user;
    close cursor_user;
  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 253 (class 1255 OID 19695)
-- Name: f_buscar_lib_cat_perfil(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_lib_cat_perfil(p_usuario character varying, p_perfil character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_user refcursor;
  begin
   
    open cursor_user for
        select p.id_usuario usuario, r.rol,
               p.id_libreria, l.libreria, el.estatus status_lib,
               p.id_categoria, c.categoria, ec.estatus status_cat
           from perfil p
                inner join rol r on p.id_rol=r.id_rol
                inner join libreria l on p.id_libreria=l.id_libreria
                inner join estatus el on l.id_estatus=el.id_estatus
                inner join categoria c on p.id_categoria=c.id_categoria
                inner join estatus ec on c.id_estatus=ec.id_estatus
           where p.id_usuario=p_usuario and r.rol=p_perfil
           order by l.libreria, c.categoria;
    return cursor_user;
    close cursor_user;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 254 (class 1255 OID 19696)
-- Name: f_buscar_libreria(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_libreria(p_idlibreria integer, p_libreria character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_lib refcursor;
  begin

    if p_idlibreria > 0 then

      open cursor_lib for
      select l.id_libreria, l.libreria, l.id_estatus, e.estatus status
             from libreria l inner join estatus e on l.id_estatus=e.id_estatus
             where l.id_libreria=p_idlibreria
             order by l.libreria asc;

    elsif p_libreria is not null then

      open cursor_lib for
      select l.id_libreria, l.libreria, l.id_estatus, e.estatus status
             from libreria l inner join estatus e on l.id_estatus=e.id_estatus
             where l.libreria=p_libreria
             order by l.libreria asc;

    else

      open cursor_lib for
      select l.id_libreria, l.libreria, l.id_estatus, e.estatus status
             from libreria l inner join estatus e on l.id_estatus=e.id_estatus
             order by l.libreria asc;

    end if;
    return cursor_lib;
    close cursor_lib;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 255 (class 1255 OID 19697)
-- Name: f_buscar_libreriascategorias(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_libreriascategorias() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_libcat refcursor;
  begin

    open cursor_libcat for
       select l.id_libreria, l.libreria descLibreria, c.id_categoria, c.categoria descCategoria,
              r.id_rol, r.rol descRol, e.id_estatus, e.estatus desEstatus
          from libreria l inner join categoria c on l.id_libreria=c.id_libreria
                          inner join estatus e
                                 on (l.id_estatus=e.id_estatus and c.id_estatus=e.id_estatus),
                          rol r
          where e.id_estatus=1
          order by l.libreria, c.categoria;

    return cursor_libcat;
    close cursor_libcat;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 256 (class 1255 OID 19698)
-- Name: f_buscar_no_fabrica(date, date, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_no_fabrica(p_fechadesde date, p_fechahasta date, p_estatusdocumento integer, p_idcategoria integer, p_expedeinte character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

  DECLARE
    cursor_user refcursor;

  begin

    if p_fechadesde is not null and p_fechahasta is not null then

      open cursor_user for
        select distinct e.expediente, e.valor, e.fecha_indice, i.*
           from infodocumento d inner join expedientes e
              on d.id_expediente=e.expediente
           inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
           inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
         where di.fecha_digitalizacion between CAST (p_fechadesde AS DATE)
           and CAST (p_fechahasta AS DATE)
           and d.estatus_documento=p_estatusdocumento
           and i.id_categoria=p_idcategoria
           order by i.id_indice;

    elsif p_fechadesde is not null then

        open cursor_user for
        select distinct e.expediente, e.valor, e.fecha_indice, i.*
           from infodocumento d inner join expedientes e
              on d.id_expediente=e.expediente
           inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
           inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
         where di.fecha_digitalizacion >= CAST (p_fechadesde AS DATE)
           and d.estatus_documento=p_estatusdocumento
           and i.id_categoria=p_idcategoria
           order by i.id_indice;

    elsif p_fechahasta is not null then

        open cursor_user for
        select distinct e.expediente, e.valor, e.fecha_indice, i.*
           from infodocumento d inner join expedientes e
              on d.id_expediente=e.expediente
           inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
           inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
         where di.fecha_digitalizacion <= CAST (p_fechahasta AS DATE)
           and d.estatus_documento=p_estatusdocumento
           and i.id_categoria=p_idcategoria
           order by i.id_indice;

    elsif p_expedeinte is not null then

         open cursor_user for
            select distinct e.expediente, e.valor, e.fecha_indice, i.*
               from infodocumento d inner join expedientes e
                  on d.id_expediente=e.expediente
               inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
               inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
             where d.id_expediente = p_expedeinte
               and d.estatus_documento=p_estatusdocumento
               and i.id_categoria=p_idcategoria
               order by i.id_indice;
    else

      open cursor_user for
        select distinct e.expediente, e.valor, e.fecha_indice, i.*
           from infodocumento d inner join expedientes e
              on d.id_expediente=e.expediente
           inner join indices i on (i.id_indice=e.id_indice and i.id_categoria=e.id_categoria)
           inner join datos_infodocumento di on di.id_infodocumento=d.id_infodocumento
         where d.estatus_documento=p_estatusdocumento
           and i.id_categoria=p_idcategoria
           order by i.id_indice;
    end if;

    return cursor_user;
    close cursor_user;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;

$$;


--
-- TOC entry 257 (class 1255 OID 19699)
-- Name: f_buscar_perfil(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_perfil(p_idusuario character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_perfil refcursor;
  begin

    open cursor_perfil for
        select distinct u.nombre, u.apellido, u.id_usuario, e.estatus estatus_usuario,
               f.fabrica pertenece, r.rol,
               l.id_libreria, l.libreria,
               c.id_categoria, c.categoria
            from usuario u full join perfil p on u.id_usuario=p.id_usuario
                           full join estatus e on u.id_estatus=e.id_estatus
                           full join fabrica f on u.id_usuario=f.usuario
                           full join rol r on p.id_rol=r.id_rol
                           full join libreria l on p.id_libreria=l.id_libreria
                           full join categoria c on p.id_categoria=c.id_categoria
             where u.id_usuario=p_idusuario
             order by l.libreria, c.categoria;


    return cursor_perfil;
    close cursor_perfil;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 258 (class 1255 OID 19700)
-- Name: f_buscar_subcategoria(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_subcategoria(p_idcategoria integer, p_idsubcategoria integer, p_subcategoria character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_subcat refcursor;
  begin

    if p_idcategoria > 0 then

      open cursor_subcat for
          select s.id_subcategoria, s.id_categoria, s.subcategoria, s.id_estatus, e.estatus
             from subcategoria s inner join estatus e on s.id_estatus=e.id_estatus
          where s.id_categoria=p_idcategoria
          order by s.subcategoria;

    elsif p_idsubcategoria > 0 then

      open cursor_subcat for
          select s.id_subcategoria, s.id_categoria, s.subcategoria, s.id_estatus, e.estatus
             from subcategoria s inner join estatus e on s.id_estatus=e.id_estatus
          where s.id_subcategoria=p_idsubcategoria
          order by s.subcategoria;

    elsif p_subcategoria is not null then

      open cursor_subcat for
          select s.id_subcategoria, s.id_categoria, s.subcategoria, s.id_estatus, e.estatus
             from subcategoria s inner join estatus e on s.id_estatus=e.id_estatus
          where s.subcategoria=p_subcategoria
          order by s.subcategoria;

    else

      open cursor_subcat for
          select s.id_subcategoria, s.id_categoria, s.subcategoria, s.id_estatus, e.estatus
             from subcategoria s inner join estatus e on s.id_estatus=e.id_estatus
             order by s.subcategoria;
    end if;
    return cursor_subcat;
    close cursor_subcat;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 259 (class 1255 OID 19701)
-- Name: f_buscar_subcategorias(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_subcategorias(p_idscategorias character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
 DECLARE
    curor_doc refcursor;
    query character varying;
  begin

    query:='select s.*, e.*
       from subcategoria s inner join estatus e on s.id_estatus=e.id_estatus
       where s.id_categoria in ('||p_idscategorias||') and e.id_estatus=1
       order by s.id_subcategoria';

    OPEN curor_doc FOR execute query;
     
    return curor_doc;
    close curor_doc;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 260 (class 1255 OID 19702)
-- Name: f_buscar_tipo_documento(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_tipo_documento(p_idssucategorias character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
 DECLARE
    curor_doc refcursor;
    query character varying;
  begin

    query:='select t.*, e.*
       from tipodocumento t inner join estatus e on t.id_estatus=e.id_estatus
       where t.id_subcategoria in ('||p_idssucategorias||') and e.id_estatus=1
       order by t.id_documento';

    OPEN curor_doc FOR execute query;

    /*open curor_doc for
     select t.*, e.*
       from tipodocumento t inner join estatus e on t.id_estatus=e.id_estatus
       where t.id_subcategoria in (p_idssucategorias) and e.id_estatus=1;
       --where t.id_subcategoria = p_idssucategorias and e.id_estatus=1;*/
     
    return curor_doc;
    close curor_doc;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 261 (class 1255 OID 19703)
-- Name: f_buscar_tipo_documento(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_tipo_documento(p_idcategoria integer, p_idsubcategoria integer, p_tipodocumemto character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_tipodoc refcursor;
  begin

    if p_idCategoria > 0 and p_idSubCategoria > 0 then

      open cursor_tipodoc for
         select t.id_documento, t.id_categoria, t.id_subcategoria, t.tipo_documento,
                t.id_estatus, t.vencimiento, t.dato_adicional, t.ficha, e.estatus
            from tipodocumento t inner join estatus e on t.id_estatus=e.id_estatus
         where t.id_categoria=p_idcategoria and t.id_subcategoria=p_idsubcategoria
         order by t.tipo_documento;

    elsif p_idCategoria > 0 then

      open cursor_tipodoc for
         select t.id_documento, t.id_categoria, t.id_subcategoria, t.tipo_documento,
                t.id_estatus, t.vencimiento, t.dato_adicional, t.ficha, e.estatus
            from tipodocumento t inner join estatus e on t.id_estatus=e.id_estatus
         where t.id_categoria=p_idcategoria order by t.tipo_documento;

    elsif p_idSubCategoria > 0 then

      open cursor_tipodoc for
         select t.id_documento, t.id_categoria, t.id_subcategoria, t.tipo_documento,
                t.id_estatus, t.vencimiento, t.dato_adicional, t.ficha, e.estatus
            from tipodocumento t inner join estatus e on t.id_estatus=e.id_estatus
         where t.id_subcategoria=p_idsubcategoria order by t.tipo_documento;

    elsif p_tipodocumemto is not null then

      open cursor_tipodoc for
         select t.id_documento, t.id_categoria, t.id_subcategoria, t.tipo_documento,
                t.id_estatus, t.vencimiento, t.dato_adicional, t.ficha, e.estatus
            from tipodocumento t inner join estatus e on t.id_estatus=e.id_estatus
         where t.tipo_documento=p_tipodocumemto order by t.tipo_documento;

    else

      open cursor_tipodoc for
         select t.id_documento, t.id_categoria, t.id_subcategoria, t.tipo_documento,
                t.id_estatus, t.vencimiento, t.dato_adicional, t.ficha, e.estatus
            from tipodocumento t inner join estatus e on t.id_estatus=e.id_estatus
            order by t.tipo_documento;

    end if;
    return cursor_tipodoc;
    close cursor_tipodoc;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 262 (class 1255 OID 19704)
-- Name: f_buscar_ultima_version(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_ultima_version(p_iddocumento integer, p_idexpediente character varying, p_numerodocumento integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_ver refcursor;
  begin

    open cursor_ver for
      select max(i.version) as version
        from infodocumento i
        where i.id_documento=p_iddocumento
              and i.id_expediente=p_idexpediente
              and i.numero_documento=p_numerodocumento
              and i.estatus_documento<>2;

  return cursor_ver;
  close cursor_ver;
  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 263 (class 1255 OID 19705)
-- Name: f_buscar_ultimo_numero(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_ultimo_numero(p_iddocumento integer, p_idexpediente character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
  DECLARE
    numero_doc integer;
  begin

   numero_doc := -1;
   
   select max(numero_documento) as numeroDocumento into numero_doc from infodocumento
   where id_documento=p_iddocumento and id_expediente=p_idexpediente;

   return numero_doc;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 264 (class 1255 OID 19706)
-- Name: f_buscar_usuario_fabrica(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_usuario_fabrica(p_usuario character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_fab refcursor;
  begin

    open cursor_fab for
       select usuario, fabrica from fabrica f where f.usuario=p_usuario;


    return cursor_fab;
    close cursor_fab;
    
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 265 (class 1255 OID 19707)
-- Name: f_buscar_valor_dato_adicional(integer, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_valor_dato_adicional(p_idocumento integer, p_idexpediente character varying, p_numerodoc integer, p_version integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_dato refcursor;
  begin

    open cursor_dato for
       select *
           from dato_adicional d
             inner join valor_dato_adicional v on d.id_dato_adicional=v.id_dato_adicional
           where d.id_documento=p_idocumento
                and v.expediente=p_idexpediente
                and v.numero=p_numerodoc
                and v.version=p_version;

  return cursor_dato;
  close cursor_dato;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 266 (class 1255 OID 19708)
-- Name: f_buscar_valor_datoadicional(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_buscar_valor_datoadicional(p_idindicedato integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_cbo refcursor;
  begin

    open cursor_cbo for
       select l.id_lista, l.codigo_indice, l.descripcion, a.indice_adicional
             from lista_desplegables l inner join dato_adicional a on l.codigo_indice=a.codigo
       where l.codigo_indice=p_idindicedato
       order by l.descripcion;


    return cursor_cbo;
    close cursor_cbo;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 267 (class 1255 OID 19709)
-- Name: f_comprobar_foto_ficha(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_comprobar_foto_ficha(p_idtipodocumento integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_foto refcursor;
  begin

    open cursor_foto for
       select ficha from tipodocumento where id_documento=p_idtipodocumento;

    return cursor_foto;
    close cursor_foto;
  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 268 (class 1255 OID 19710)
-- Name: f_comprobar_nombre_archivo(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_comprobar_nombre_archivo(p_idinfodocumento integer, p_idexpediente character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
  DECLARE
    nombre varchar(255);
  begin

   nombre := null;
   
   select nombre_archivo into nombre from infodocumento
   where id_infodocumento= p_idinfodocumento and id_expediente=p_idexpediente;

   return nombre;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 269 (class 1255 OID 19711)
-- Name: f_comprobar_numero_documento(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_comprobar_numero_documento(p_iddocumento integer, p_idexpediente character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_numdoc refcursor;
  begin

   open cursor_numdoc for
   select numero_documento  from infodocumento
   where id_documento=p_iddocumento and id_expediente=p_idexpediente
   order by numero_documento;

   return cursor_numdoc;
   close cursor_numdoc;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 270 (class 1255 OID 19712)
-- Name: f_crear_sesion(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_crear_sesion(p_usuario character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_user refcursor;
  begin
   
    open cursor_user for
       select distinct r.rol desc_rol, e.estatus estatus_usuario, u.id_usuario id_user,
              u.nombre, u.apellido, u.cedula, u.id_estatus
           from usuario u inner join estatus e on u.id_estatus=e.id_estatus
                inner join perfil p on p.id_usuario=u.id_usuario
                inner join rol r on r.id_rol=p.id_rol
           where u.id_usuario=p_usuario;
    return cursor_user;
    close cursor_user;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 271 (class 1255 OID 19713)
-- Name: f_eliminar_archivo(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_eliminar_archivo(p_idinfodocumento integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE

    cursor_eliminar refcursor;
  begin

   open cursor_eliminar for
        select t.ruta_archivo, t.nombre_archivo from infodocumento t where t.id_infodocumento=p_idinfodocumento;

    return cursor_eliminar;
    close cursor_eliminar;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 272 (class 1255 OID 19714)
-- Name: f_foliatura_buscar_expediente(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_foliatura_buscar_expediente(p_idexpediente character varying, p_idlibreria integer, p_idcategoria integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_folio refcursor;
  begin
  
    open cursor_folio for
        select i.id_expediente, l.id_libreria, c.id_categoria, s.id_subcategoria,
               t.id_documento, i.id_infodocumento, t.tipo_documento as documento,
               i.paginas as cantidadPAginas 
     from infodocumento i 
         inner join tipodocumento t on i.id_documento=t.id_documento
         inner join subcategoria s on s.id_subcategoria=t.id_subcategoria
         inner join categoria c on c.id_categoria=t.id_categoria
         inner join libreria l on l.id_libreria=c.id_libreria
        where i.id_expediente=p_idexpediente and i.estatus_documento=1 and
              l.id_libreria=p_idlibreria and c.id_categoria=p_idcategoria
        order by t.id_documento, i.numero_documento desc, i.version desc;

    return cursor_folio;
    close cursor_folio;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 273 (class 1255 OID 19715)
-- Name: f_informacion_tabla(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_informacion_tabla(p_tabla character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_tabla refcursor;
  begin

    open cursor_tabla for
      SELECT s.OWNER, s.TABLE_NAME, s.COLUMN_NAME, s.DATA_TYPE
          FROM all_tab_columns s
      WHERE
      --owner = 'GESTORDOCUMENTAL' and
      table_name=p_tabla;
      return cursor_tabla;
      close cursor_tabla;
	  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 275 (class 1255 OID 19716)
-- Name: f_modificar_indices(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_modificar_indices(p_idexpedientenuevo character varying, p_idexpedienteviejo character varying, p_flag character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
 DECLARE
    curor_indice refcursor;
  begin
    
    if p_flag = '0' then
    
      open curor_indice for
         select expediente from expedientes where expediente=p_idexpedientenuevo;
      return curor_indice;
      close curor_indice;
      
    elsif p_flag = '1' then
      
      delete from expedientes where expediente=p_idexpedienteviejo;

      update infodocumento set id_expediente=p_idexpedientenuevo where id_expediente=p_idexpedienteviejo;
      return curor_indice;
    end if;
    
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 276 (class 1255 OID 19717)
-- Name: f_usuarios(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_usuarios() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_user refcursor;
  begin

    open cursor_user for
       select u.id_usuario, u.nombre, u.apellido, u.cedula, u.sexo,
              e.id_estatus, e.estatus
       from usuario u inner join estatus e on u.id_estatus=e.id_estatus
       order by u.id_usuario;

       return cursor_user;
       close cursor_user;
	   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 277 (class 1255 OID 19718)
-- Name: f_verificar_usuario(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_verificar_usuario(p_usuario character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cursor_user refcursor;
  begin

   if p_usuario is not null then

    open cursor_user for
      select u.id_usuario, u.nombre, u.apellido, u.password passUser, e.id_estatus, e.estatus, c.*
      from usuario u inner join estatus e on u.id_estatus=e.id_estatus,
      configuracion c
      where u.id_usuario = p_usuario;

   else

     open cursor_user for
       select u.id_usuario, u.nombre, u.apellido, u.cedula, u.id_estatus, e.estatus
       from usuario u inner join estatus e on u.id_estatus=e.id_estatus
       order by u.id_usuario;

   end if;
    return cursor_user;
    close cursor_user;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 278 (class 1255 OID 19719)
-- Name: p_actualiza_codigo_combo(integer, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualiza_codigo_combo(p_codigocombo integer, p_flag character) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    if p_flag = '0' then

      update indices set codigo = p_codigocombo where id_indice = p_codigocombo;

    elsif p_flag = '1' then

      update dato_adicional  set codigo = p_codigocombo where id_dato_adicional = p_codigocombo;

    end if;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 279 (class 1255 OID 19720)
-- Name: p_actualiza_nombre_archivo(character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualiza_nombre_archivo(p_nombrearchivo character varying, p_idinfodocumento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   update infodocumento set nombre_archivo=p_nombrearchivo
        where id_infodocumento=p_idinfodocumento;
		
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 280 (class 1255 OID 19721)
-- Name: p_actualiza_numero_da(integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualiza_numero_da(p_idvalor integer, p_numerodocumento integer, p_version integer, p_expediente character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    
  begin
  
     update valor_dato_adicional
       set numero = p_numerodocumento
       where id_valor = p_idvalor
         and expediente = p_expediente
         and version=p_version;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 281 (class 1255 OID 19722)
-- Name: p_actualiza_td_foto(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualiza_td_foto(p_idtipodocumento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   update tipodocumento set ficha='1' where id_documento=p_idtipodocumento;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 282 (class 1255 OID 19723)
-- Name: p_actualizar_categorias(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualizar_categorias(p_idcategoria integer, p_idestatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   update categoria set id_estatus=p_idestatus where id_categoria=p_idcategoria;
  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 283 (class 1255 OID 19724)
-- Name: p_actualizar_datos_combo(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualizar_datos_combo(p_idcombo integer, p_dato character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   update lista_desplegables
      set descripcion = p_dato
    where id_lista = p_idcombo;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 284 (class 1255 OID 19725)
-- Name: p_actualizar_indices(integer, integer, character varying, character varying, integer, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualizar_indices(p_idindices integer, p_idcategoria integer, p_indice character varying, p_tipodato character varying, p_codigo integer, p_clave character) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin
    update indices
       set id_categoria = p_idcategoria,
           indice = p_indice,
           tipo = p_tipodato,
           codigo = p_codigo,
           clave = p_clave
     where id_indice = p_idindices;
	 
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 285 (class 1255 OID 19726)
-- Name: p_actualizar_indices(character varying, character varying, integer, character varying, date, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualizar_indices(p_idexpedientenuevo character varying, p_idexpedienteviejo character varying, p_idindice integer, p_valor character varying, p_fechaindice date, p_idlibreria integer, p_idcategoria integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    
  begin

    if (p_idexpedienteviejo = p_idexpedientenuevo) then

      update expedientes
         set valor = p_valor,
             fecha_indice = p_fechaindice
       where id_indice = p_idindice
         and expediente = p_idexpedienteviejo
         and id_libreria = p_idlibreria
         and id_categoria = p_idcategoria;

    else
        insert into expedientes
          (expediente, id_indice, valor, id_libreria, id_categoria)
        values
          (p_idexpedientenuevo, p_idindice, p_valor, p_idlibreria, p_idcategoria);
        
    end if;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 286 (class 1255 OID 19727)
-- Name: p_actualizar_infodocumento(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualizar_infodocumento(p_numerodoc integer, p_idinfodocumento integer, p_idexpediente character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    update infodocumento set numero_documento=p_numerodoc
    where id_infodocumento=p_idinfodocumento and id_expediente=p_idexpediente;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 287 (class 1255 OID 19728)
-- Name: p_actualizar_librerias(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualizar_librerias(p_idlibreria integer, p_idestatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   update libreria set id_estatus=p_idestatus where id_libreria=p_idlibreria;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 226 (class 1255 OID 19729)
-- Name: p_actualizar_subcategorias(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualizar_subcategorias(p_idsubcategoria integer, p_idestatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   update subcategoria set id_estatus=p_idestatus where id_subcategoria=p_idsubcategoria;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 274 (class 1255 OID 19730)
-- Name: p_actualizar_tipodocumento(integer, integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_actualizar_tipodocumento(p_idtipodocumento integer, p_idestatus integer, p_vencimiento character, p_datoadicional character) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   update tipodocumento set id_estatus=p_idestatus, vencimiento=p_vencimiento,
                        dato_adicional=p_datoadicional
   where id_documento=p_idtipodocumento;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 288 (class 1255 OID 19731)
-- Name: p_agrega_usuario(character varying, character varying, character varying, character varying, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agrega_usuario(p_idusuario character varying, p_nombre character varying, p_apellido character varying, p_cedula character varying, p_sexo character) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into usuario
      (id_usuario, nombre, apellido, cedula, sexo, id_estatus)
    values
      (p_idusuario, p_nombre, p_apellido, p_cedula, p_sexo, 1);
	  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 289 (class 1255 OID 19732)
-- Name: p_agregar_categoria(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_categoria(p_idlibreria integer, p_categoria character varying, p_idestatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into categoria
      (id_libreria, categoria, id_estatus)
    values
      (p_idlibreria, p_categoria, p_idestatus);
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;  
  end;$$;


--
-- TOC entry 290 (class 1255 OID 19733)
-- Name: p_agregar_configuracion(character varying, character varying, integer, character varying, character varying, character, character, character, character, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_configuracion(p_nombreservidor character varying, p_nombrebasedato character varying, p_puertobasedato integer, p_usuariobasedato character varying, p_passbasedato character varying, p_calidad character, p_foliatura character, p_ficha character, p_fabrica character, p_elimina character, p_ldap character) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    update configuracion
       set calidad = p_calidad,
           foliatura = p_foliatura,
           server_name = p_nombreservidor,
           database_name = p_nombrebasedato,
           port = p_puertobasedato,
           userbd = p_usuariobasedato,
           password = p_passbasedato,
           ficha = p_ficha,
           fabrica = p_fabrica,
           elimina = p_elimina,
           ldap = p_ldap
     where id_configuracion=1;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;
$$;


--
-- TOC entry 291 (class 1255 OID 19734)
-- Name: p_agregar_datos_combo(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_datos_combo(p_codigoindice integer, p_dato character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into lista_desplegables
      (codigo_indice, descripcion)
    values
      (p_codigoindice, p_dato);
	  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 292 (class 1255 OID 19735)
-- Name: p_agregar_datos_combo_da(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_datos_combo_da(p_iddatoadiciona integer, p_datocombo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin


    insert into lista_desplegables
      (codigo_indice, descripcion)
    values
      (p_iddatoadiciona, p_datocombo);
	  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 293 (class 1255 OID 19736)
-- Name: p_agregar_fabrica(character varying, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_fabrica(p_idusuario character varying, p_pertenece character) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into fabrica(usuario, fabrica)
           values(p_idusuario, p_pertenece);
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;	   
  end;$$;


--
-- TOC entry 294 (class 1255 OID 19737)
-- Name: p_agregar_foliaturas(integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_foliaturas(p_idinfodocumento integer, p_iddocumento integer, p_idexpediente character varying, p_pagina integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into foliatura
      (id_infodocumento, id_documento, id_expediente, pagina)
    values
      (p_idinfodocumento, p_iddocumento, p_idexpediente, p_pagina);
	  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 295 (class 1255 OID 19738)
-- Name: p_agregar_indices(integer, character varying, character varying, integer, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_indices(p_idcategoria integer, p_indice character varying, p_tipodato character varying, p_codigo integer, p_clave character) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into indices
      (id_categoria, indice, tipo, codigo, clave)
    values
      (p_idcategoria, p_indice, p_tipodato, p_codigo, p_clave);
	  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 296 (class 1255 OID 19739)
-- Name: p_agregar_libreria(character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_libreria(p_libreria character varying, p_idestatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into libreria(libreria, id_estatus)
                values(p_libreria, p_idestatus);
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;			
  end;$$;


--
-- TOC entry 297 (class 1255 OID 19740)
-- Name: p_agregar_perfil(integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_perfil(p_idlibreria integer, p_idcategoria integer, p_idusuario character varying, p_idrol integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    if p_idcategoria = 0 and p_idlibreria = 0 then

      insert into perfil(id_usuario, id_rol)
                  values(p_idusuario, p_idrol);

    elsif p_idcategoria = 0 then

      insert into perfil(id_libreria, id_usuario, id_rol)
                  values(p_idlibreria, p_idusuario, p_idrol);
    else

      insert into perfil(id_libreria, id_categoria, id_usuario, id_rol)
                  values(p_idlibreria, p_idcategoria, p_idusuario, p_idrol);
    end if;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 298 (class 1255 OID 19741)
-- Name: p_agregar_registro_archivo(character varying, character varying, integer, character varying, integer, integer, character varying, integer, date, character varying, character varying, integer, integer, character, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_registro_archivo(p_accion character varying, p_nombrearchivo character varying, p_iddocumento integer, p_rutaarchivo character varying, p_cantpaginas integer, p_version integer, p_idexpediente character varying, p_numerodoc integer, p_fechavencimiento date, p_datoadicional character varying, p_usuario character varying, p_idinfodocumento integer, p_estatus integer, p_redigitalizo character, p_formato character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
  DECLARE
   p_idinfodoc integer;
  begin

   
   p_idinfodoc := 0;


   if p_accion = 'versionar' then

     insert into infodocumento(id_documento, id_expediente, nombre_archivo, ruta_archivo, formato, numero_documento, 
                               version, paginas, fecha_vencimiento, estatus_documento, re_digitalizado)
                 values(p_iddocumento, p_idexpediente, p_nombrearchivo, p_rutaarchivo,
                        p_formato, p_numerodoc, p_version, p_cantpaginas, p_fechavencimiento, p_estatus,
                        p_redigitalizo);
	
	 select lastval() into p_idinfodoc;

     if p_idinfodoc > 0 then
        insert into datos_infodocumento(id_infodocumento, fecha_digitalizacion, usuario_digitalizo, dato_adicional)
                    values(p_idinfodoc, now(), p_usuario, p_datoadicional);
      else
        rollback;
      end if;

    elsif p_accion = 'reemplazar' then

      p_idinfodoc := -1;
      update infodocumento set nombre_archivo=p_nombrearchivo, ruta_archivo=p_rutaarchivo, paginas=p_cantpaginas, 
                               version=p_version, id_expediente=p_idexpediente, numero_documento=p_numerodoc, 
                               fecha_vencimiento=p_fechavencimiento, formato=p_formato, estatus_documento=p_estatus
      where id_infodocumento=p_idinfodocumento;

      update datos_infodocumento set fecha_digitalizacion = now(),
                                     usuario_digitalizo = p_usuario,
                                     dato_adicional = p_datoadicional
       where id_infodocumento=p_idinfodocumento;

    elsif p_accion = 'Guardar' then
       insert into infodocumento(id_documento, id_expediente, nombre_archivo, ruta_archivo, formato, numero_documento, 
                                version, paginas, fecha_vencimiento, estatus_documento, re_digitalizado)
                  values(p_iddocumento, p_idexpediente, p_nombrearchivo, p_rutaarchivo, p_formato, 
			 p_numerodoc, p_version, p_cantpaginas, p_fechavencimiento, p_estatus, 0);
	
	 select lastval() into p_idinfodoc;

      if p_idinfodoc > 0 then
        insert into datos_infodocumento(id_infodocumento, fecha_digitalizacion, usuario_digitalizo, dato_adicional)
                    values(p_idinfodoc, now(), p_usuario, p_datoadicional);

         if p_redigitalizo = '1' then
           update infodocumento set re_digitalizado=p_redigitalizo
              where id_infodocumento=p_idinfodocumento;
         end if;
      else
        rollback;
      end if;

    end if;

   return p_idinfodoc;
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
   end;$$;


--
-- TOC entry 299 (class 1255 OID 19742)
-- Name: p_agregar_subcategoria(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_subcategoria(p_idcategoria integer, p_subcategoria character varying, p_idestatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into subcategoria
      (id_categoria, subcategoria, id_estatus)
    values
      (p_idcategoria, p_subcategoria, p_idestatus);
	  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 300 (class 1255 OID 19743)
-- Name: p_agregar_tipodocumento(integer, integer, character varying, integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_agregar_tipodocumento(p_idcategoria integer, p_idsubcategoria integer, p_tipodocumento character varying, p_idestatus integer, p_vencimiento character, p_datoadicional character) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into tipodocumento
      (id_categoria, id_subcategoria, tipo_documento, id_estatus, vencimiento, dato_adicional)
    values
      (p_idcategoria, p_idsubcategoria, p_tipodocumento, p_idestatus, p_vencimiento, p_datoadicional);

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 301 (class 1255 OID 19744)
-- Name: p_aprobar_documento(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_aprobar_documento(p_idinfodocumento integer, p_usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
    estatu integer;
    idInfoDoc integer;
begin

    update infodocumento set estatus_documento=1 where id_infodocumento=p_idinfodocumento;
    --commit;

    select estatus_documento into estatu from infodocumento where id_infodocumento=p_idinfodocumento;

    if estatu > 0 then
    
      select t.id_infodocumento into idInfoDoc from datos_infodocumento t where t.id_infodocumento=p_idinfodocumento;
    
      if idInfoDoc = p_idinfodocumento then
        update datos_infodocumento
           set fecha_aprobacion = now(),
               usuario_aprobacion = p_usuario
         where id_infodocumento = p_idinfodocumento;
      else
        insert into datos_infodocumento(id_infodocumento, fecha_aprobacion, usuario_aprobacion)
                  values(p_idinfodocumento, now(), p_usuario);
      end if;
      
    else
    
      update infodocumento set estatus_documento=0 where id_infodocumento= p_idinfodocumento;
      --commit;
      
    end if;
    
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %', SQLERRM;
 end;$$;


--
-- TOC entry 302 (class 1255 OID 19745)
-- Name: p_eliminar_expediente(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_eliminar_expediente(p_idexpediente character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    delete from expedientes where expediente=p_idexpediente;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 303 (class 1255 OID 19746)
-- Name: p_eliminar_infodocumento(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_eliminar_infodocumento(p_idinfodocumento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
  
  begin

    
    delete from datos_infodocumento where id_infodocumento = p_idinfodocumento;
    delete from infodocumento where id_infodocumento = p_idinfodocumento;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 304 (class 1255 OID 19747)
-- Name: p_eliminar_perfil(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_eliminar_perfil(p_idusuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   delete from perfil where id_usuario=p_idusuario;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 305 (class 1255 OID 19748)
-- Name: p_eliminar_registro_archivo(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_eliminar_registro_archivo(p_idinfodocumento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   delete from datos_infodocumento where id_infodocumento=p_idinfodocumento;
   delete from infodocumento where id_infodocumento=p_idinfodocumento;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 306 (class 1255 OID 19749)
-- Name: p_eliminar_valordatadic(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_eliminar_valordatadic(p_idvalor integer, p_versiondoc integer, p_numerodoc integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    
  begin
  
    delete from valor_dato_adicional
     where id_valor = p_idvalor and version=p_versiondoc and numero=p_numerodoc;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 307 (class 1255 OID 19750)
-- Name: p_guarda_valor_dato_adicional(integer, integer, character varying, integer, integer, character varying, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_guarda_valor_dato_adicional(p_iddatoadicional integer, p_idvalor integer, p_valor character varying, p_numerodocumento integer, p_version integer, p_expediente character varying, p_flag character) RETURNS void
    LANGUAGE plpgsql
    AS $$
  begin


    if p_flag = '0' then

      update valor_dato_adicional
         set valor = p_valor
       where id_valor = p_idvalor
         and numero = p_numerodocumento
         and version = p_version
         and expediente = p_expediente;

    elsif p_flag = '1' then

     insert into valor_dato_adicional
        (id_dato_adicional, valor, numero, version, expediente)
      values
        (p_iddatoadicional, p_valor, p_numerodocumento, p_version, p_expediente);
        
    end if;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 308 (class 1255 OID 19751)
-- Name: p_guardar_expediente(character varying, integer, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_guardar_expediente(p_idexpediente character varying, p_idindice integer, p_valor character varying, p_idlibreria integer, p_idcategoria integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into expedientes
      (expediente, id_indice, valor, id_libreria, id_categoria)
    values
      (p_idexpediente, p_idindice, p_valor, p_idlibreria, p_idcategoria);

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 309 (class 1255 OID 19752)
-- Name: p_guardar_expediente(character varying, integer, character varying, date, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_guardar_expediente(p_idexpediente character varying, p_idindice integer, p_valor character varying, p_fechaindice date, p_idlibreria integer, p_idcategoria integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into expedientes
      (expediente, id_indice, valor, fecha_indice, id_libreria, id_categoria)
    values
      (p_idexpediente, p_idindice, p_valor, p_fechaindice, p_idlibreria, p_idcategoria);

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 310 (class 1255 OID 19753)
-- Name: p_guardar_indice_datoadicional(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_guardar_indice_datoadicional(p_idtipodocumento integer, p_datoadicional character varying, p_tipo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

    insert into dato_adicional
      (indice_adicional, tipo, id_documento)
    values
      (p_datoadicional, p_tipo, p_idtipodocumento);
	  
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 311 (class 1255 OID 19754)
-- Name: p_modificar_usuario(character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_modificar_usuario(p_idusuario character varying, p_idestatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

  begin

   update usuario set id_estatus=p_idestatus where id_usuario=p_idusuario;
   
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 312 (class 1255 OID 19755)
-- Name: p_rechazar_documento(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_rechazar_documento(p_idinfodocumento integer, p_usuario character varying, p_causa character varying, p_motivo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
  DECLARE
    estatu integer;
    idInfoDoc integer;
  begin

    update infodocumento set estatus_documento=2 where id_infodocumento= p_idinfodocumento;
    --commit;

    select estatus_documento into estatu from infodocumento where id_infodocumento=p_idinfodocumento;


    if estatu > 0 then

      select t.id_infodocumento into idInfoDoc from datos_infodocumento t where t.id_infodocumento=p_idinfodocumento;

      if idInfoDoc = p_idinfodocumento then
        update datos_infodocumento
           set fecha_rechazo = now(),
               usuario_rechazo = p_usuario,
               motivo_rechazo = p_motivo,
               causa_rechazo = p_causa
         where id_infodocumento = p_idinfodocumento;
      else

        insert into datos_infodocumento(id_infodocumento, fecha_rechazo, usuario_rechazo, motivo_rechazo, causa_rechazo)
                  values(p_idinfodocumento, now(), p_usuario, p_motivo, p_causa);
      end if;
    else
      update infodocumento set estatus_documento=0 where id_infodocumento= p_idinfodocumento;
      --commit;

    end if;
	
  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'Falló la orden SQL: %', SQLERRM;
  end;$$;


--
-- TOC entry 313 (class 1255 OID 19756)
-- Name: p_traza_elimina_documento(character varying, integer, integer, integer, integer, integer, date, date, date, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION p_traza_elimina_documento(p_idexpedeinte character varying, p_idlibreria integer, p_idcategoria integer, p_idsubcategoria integer, p_iddocumento integer, p_numerodoc integer, p_fechavencimiento date, p_fechadigitalizo date, p_fecharechazo date, p_cantpaginas integer, p_versiondoc integer, p_usuarioelimino character varying, p_usuariodigitalizo character varying, p_usuariorechazo character varying, p_causaelimino character varying, p_motivoelimino character varying, p_causarechazo character varying, p_motivorechazo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
  DECLARE
  
    iddoceliminado integer;

  begin

    insert into documento_eliminado
      (id_expediente, id_libreria, id_categoria, id_subcategoria, id_documento, numero_documento, version, paginas, fecha_vencimiento, fecha_eliminado, usuario_elimino)
    values
      (p_idexpedeinte, p_idlibreria, p_idcategoria, p_idsubcategoria, p_iddocumento, p_numerodoc, p_versiondoc, p_cantpaginas, p_fechavencimiento, now(), p_usuarioelimino);

    select lastval() into iddoceliminado;

    if iddoceliminado > 0 then

	 insert into datos_infodocumento
	(id_doc_eliminado, fecha_digitalizacion, usuario_digitalizo, fecha_rechazo, usuario_rechazo, motivo_rechazo, causa_rechazo, fecha_eliminado, usuario_elimino, motivo_elimino, causa_elimino)
      values
        (iddoceliminado, p_fechadigitalizo, p_usuariodigitalizo, p_fecharechazo, p_usuariorechazo, p_motivorechazo, p_causarechazo, now(), p_usuarioelimino, p_motivoelimino, p_causaelimino);
 
    else
      rollback;
    end if;

  EXCEPTION
     WHEN OTHERS THEN
        RAISE EXCEPTION 'El error fue: %',  SQLERRM;
  end;$$;


--
-- TOC entry 185 (class 1259 OID 19757)
-- Name: sq_categroria; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_categroria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_with_oids = false;

--
-- TOC entry 186 (class 1259 OID 19759)
-- Name: categoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categoria (
    id_categoria integer DEFAULT nextval('sq_categroria'::regclass) NOT NULL,
    id_libreria integer NOT NULL,
    categoria character varying(200) NOT NULL,
    id_estatus integer NOT NULL
);


--
-- TOC entry 187 (class 1259 OID 19763)
-- Name: causa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE causa (
    id_causa integer NOT NULL,
    causa character varying(150) NOT NULL
);


--
-- TOC entry 188 (class 1259 OID 19766)
-- Name: configuracion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE configuracion (
    id_configuracion integer NOT NULL,
    calidad character(1),
    ruta_temporal character varying(50),
    archivo_tif character varying(50),
    archivo_cod character varying(50),
    log character varying(50),
    foliatura character(1),
    server_name character varying(50),
    database_name character varying(50),
    port integer,
    userbd character varying(50),
    password character varying(50),
    ficha character(1),
    fabrica character(1),
    elimina character(1),
    ldap character(1)
);


--
-- TOC entry 189 (class 1259 OID 19769)
-- Name: sq_dato_adicional; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_dato_adicional
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 190 (class 1259 OID 19771)
-- Name: dato_adicional; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE dato_adicional (
    id_dato_adicional integer DEFAULT nextval('sq_dato_adicional'::regclass) NOT NULL,
    indice_adicional character varying(250) NOT NULL,
    tipo character varying(50) NOT NULL,
    id_documento integer NOT NULL,
    codigo integer
);


--
-- TOC entry 191 (class 1259 OID 19775)
-- Name: sq_datos_infodocumento; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_datos_infodocumento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 192 (class 1259 OID 19777)
-- Name: datos_infodocumento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE datos_infodocumento (
    id_datos integer DEFAULT nextval('sq_datos_infodocumento'::regclass) NOT NULL,
    id_infodocumento integer,
    id_doc_eliminado integer,
    fecha_digitalizacion date,
    usuario_digitalizo character varying(30),
    fecha_aprobacion date,
    usuario_aprobacion character varying(30),
    fecha_rechazo date,
    usuario_rechazo character varying(30),
    motivo_rechazo character varying(300),
    causa_rechazo character varying(300),
    fecha_eliminado date,
    usuario_elimino character varying(30),
    motivo_elimino character varying(300),
    causa_elimino character varying(300),
    dato_adicional character varying(30)
);


--
-- TOC entry 193 (class 1259 OID 19784)
-- Name: sq_documento_eliminado; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_documento_eliminado
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 194 (class 1259 OID 19786)
-- Name: documento_eliminado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE documento_eliminado (
    id_doc_eliminado integer DEFAULT nextval('sq_documento_eliminado'::regclass) NOT NULL,
    id_expediente character varying(50) NOT NULL,
    id_libreria integer NOT NULL,
    id_categoria integer NOT NULL,
    id_subcategoria integer NOT NULL,
    id_documento integer NOT NULL,
    numero_documento integer NOT NULL,
    version integer NOT NULL,
    paginas integer NOT NULL,
    fecha_vencimiento date,
    fecha_eliminado date NOT NULL,
    usuario_elimino character varying(30) NOT NULL
);


--
-- TOC entry 195 (class 1259 OID 19790)
-- Name: estatus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE estatus (
    id_estatus integer NOT NULL,
    estatus character varying(100) NOT NULL
);


--
-- TOC entry 196 (class 1259 OID 19793)
-- Name: estatus_documento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE estatus_documento (
    id_estatus_documento integer NOT NULL,
    estatus_documento character varying(20) NOT NULL
);


--
-- TOC entry 197 (class 1259 OID 19796)
-- Name: sq_expediente; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_expediente
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 198 (class 1259 OID 19798)
-- Name: expedientes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE expedientes (
    id_expedientes integer DEFAULT nextval('sq_expediente'::regclass) NOT NULL,
    expediente character varying(250) NOT NULL,
    id_indice integer NOT NULL,
    valor character varying(250),
    fecha_indice date,
    id_libreria integer NOT NULL,
    id_categoria integer NOT NULL
);


--
-- TOC entry 199 (class 1259 OID 19805)
-- Name: fabrica; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fabrica (
    usuario character varying(50) NOT NULL,
    fabrica character(1) NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 19808)
-- Name: sq_foliatura; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_foliatura
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 201 (class 1259 OID 19810)
-- Name: foliatura; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE foliatura (
    id_foliatura integer DEFAULT nextval('sq_foliatura'::regclass) NOT NULL,
    id_infodocumento integer NOT NULL,
    id_documento integer NOT NULL,
    id_expediente character varying(50) NOT NULL,
    pagina integer NOT NULL
);


--
-- TOC entry 202 (class 1259 OID 19814)
-- Name: sq_indices; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_indices
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 203 (class 1259 OID 19816)
-- Name: indices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE indices (
    id_indice integer DEFAULT nextval('sq_indices'::regclass) NOT NULL,
    id_categoria integer NOT NULL,
    indice character varying(250) NOT NULL,
    tipo character varying(50) NOT NULL,
    codigo integer NOT NULL,
    clave character(1)
);


--
-- TOC entry 204 (class 1259 OID 19820)
-- Name: sq_infodocumento; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_infodocumento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 205 (class 1259 OID 19822)
-- Name: infodocumento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE infodocumento (
    id_infodocumento integer DEFAULT nextval('sq_infodocumento'::regclass) NOT NULL,
    id_documento integer NOT NULL,
    id_expediente character varying(50),
    nombre_archivo character varying(1000),
    ruta_archivo character varying(1000),
    formato character varying(4),
    numero_documento integer NOT NULL,
    version integer NOT NULL,
    paginas integer NOT NULL,
    fecha_vencimiento date,
    estatus_documento integer NOT NULL,
    re_digitalizado character(1) NOT NULL
);


--
-- TOC entry 206 (class 1259 OID 19829)
-- Name: sq_libreria; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_libreria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 207 (class 1259 OID 19831)
-- Name: libreria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE libreria (
    id_libreria integer DEFAULT nextval('sq_libreria'::regclass) NOT NULL,
    libreria character varying(200) NOT NULL,
    id_estatus integer NOT NULL
);


--
-- TOC entry 208 (class 1259 OID 19835)
-- Name: sq_combo; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_combo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 209 (class 1259 OID 19837)
-- Name: lista_desplegables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lista_desplegables (
    id_lista integer DEFAULT nextval('sq_combo'::regclass) NOT NULL,
    codigo_indice integer NOT NULL,
    descripcion character varying(200)
);


--
-- TOC entry 210 (class 1259 OID 19841)
-- Name: sq_perfil; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_perfil
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 211 (class 1259 OID 19843)
-- Name: perfil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE perfil (
    id_perfil integer DEFAULT nextval('sq_perfil'::regclass) NOT NULL,
    id_libreria integer,
    id_categoria integer,
    id_usuario character varying(50) NOT NULL,
    id_rol integer NOT NULL
);


--
-- TOC entry 212 (class 1259 OID 19847)
-- Name: reporte; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reporte (
    id_categoria integer,
    expediente character varying(250),
    cedula_de_identidad_de_empleado character varying(250),
    numero_de_solicitud_u_oficio character varying(250),
    apellidos_y_nombres_de_empleado character varying(250),
    organismo_principal character varying(250)
);


--
-- TOC entry 213 (class 1259 OID 19853)
-- Name: rol; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rol (
    id_rol integer NOT NULL,
    rol character varying(50) NOT NULL
);


--
-- TOC entry 214 (class 1259 OID 19856)
-- Name: sq_subcategroria; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_subcategroria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 215 (class 1259 OID 19858)
-- Name: sq_tipo_documento; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_tipo_documento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 216 (class 1259 OID 19860)
-- Name: sq_valor_dato_adicional; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_valor_dato_adicional
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 217 (class 1259 OID 19862)
-- Name: subcategoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE subcategoria (
    id_subcategoria integer DEFAULT nextval('sq_subcategroria'::regclass) NOT NULL,
    id_categoria integer NOT NULL,
    subcategoria character varying(200) NOT NULL,
    id_estatus integer NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 19866)
-- Name: tipodocumento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tipodocumento (
    id_documento integer DEFAULT nextval('sq_tipo_documento'::regclass) NOT NULL,
    id_categoria integer NOT NULL,
    id_subcategoria integer NOT NULL,
    tipo_documento character varying(200) NOT NULL,
    id_estatus integer NOT NULL,
    vencimiento character(1),
    dato_adicional character(1),
    ficha character(1)
);


--
-- TOC entry 219 (class 1259 OID 19870)
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE usuario (
    id_usuario character varying(50) NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    cedula character varying(50),
    sexo character(1),
    id_estatus integer NOT NULL,
    password character varying(16)
);


--
-- TOC entry 220 (class 1259 OID 19873)
-- Name: valor_dato_adicional; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE valor_dato_adicional (
    id_valor integer DEFAULT nextval('sq_valor_dato_adicional'::regclass) NOT NULL,
    id_dato_adicional integer NOT NULL,
    valor character varying(250) NOT NULL,
    numero integer NOT NULL,
    version integer NOT NULL,
    expediente character varying(250) NOT NULL
);


--
-- TOC entry 2396 (class 0 OID 19759)
-- Dependencies: 186
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2397 (class 0 OID 19763)
-- Dependencies: 187
-- Data for Name: causa; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO causa VALUES (1, 'Mala Calidad en la Imagen');
INSERT INTO causa VALUES (2, 'Mala tipificación del Documento');
INSERT INTO causa VALUES (3, 'Los Índices no concuerdan con el Documento');
INSERT INTO causa VALUES (4, 'Mala Orientación del Documento');
INSERT INTO causa VALUES (5, 'Visualización Nula del Documento');
INSERT INTO causa VALUES (6, 'Falla Técnica del Sistema');
INSERT INTO causa VALUES (7, 'Eliminacion de Documento');


--
-- TOC entry 2398 (class 0 OID 19766)
-- Dependencies: 188
-- Data for Name: configuracion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO configuracion VALUES (1, '0', 'temp', 'documento.tiff', 'codificado.cod', '/lib/log4j-config.properties', '0', '192.168.0.182', 'dw4j', 5432, 'cG9zdGdyZXM=', 'ZGV2ZWxjb20=', '0', '0', '1', '1');


--
-- TOC entry 2400 (class 0 OID 19771)
-- Dependencies: 190
-- Data for Name: dato_adicional; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2402 (class 0 OID 19777)
-- Dependencies: 192
-- Data for Name: datos_infodocumento; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2404 (class 0 OID 19786)
-- Dependencies: 194
-- Data for Name: documento_eliminado; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2405 (class 0 OID 19790)
-- Dependencies: 195
-- Data for Name: estatus; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO estatus VALUES (1, 'Activo');
INSERT INTO estatus VALUES (2, 'Inactivo');


--
-- TOC entry 2406 (class 0 OID 19793)
-- Dependencies: 196
-- Data for Name: estatus_documento; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO estatus_documento VALUES (0, 'Pendiente');
INSERT INTO estatus_documento VALUES (1, 'Aprobado');
INSERT INTO estatus_documento VALUES (2, 'Rechazado');


--
-- TOC entry 2408 (class 0 OID 19798)
-- Dependencies: 198
-- Data for Name: expedientes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2409 (class 0 OID 19805)
-- Dependencies: 199
-- Data for Name: fabrica; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2411 (class 0 OID 19810)
-- Dependencies: 201
-- Data for Name: foliatura; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2413 (class 0 OID 19816)
-- Dependencies: 203
-- Data for Name: indices; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2415 (class 0 OID 19822)
-- Dependencies: 205
-- Data for Name: infodocumento; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2417 (class 0 OID 19831)
-- Dependencies: 207
-- Data for Name: libreria; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2419 (class 0 OID 19837)
-- Dependencies: 209
-- Data for Name: lista_desplegables; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2421 (class 0 OID 19843)
-- Dependencies: 211
-- Data for Name: perfil; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO perfil VALUES (1, NULL, NULL, 'dw4jconf', 7);
INSERT INTO perfil VALUES (2, NULL, NULL, 'dw4jconf', 8);


--
-- TOC entry 2422 (class 0 OID 19847)
-- Dependencies: 212
-- Data for Name: reporte; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2423 (class 0 OID 19853)
-- Dependencies: 213
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO rol VALUES (1, 'ADMINISTRADOR');
INSERT INTO rol VALUES (2, 'APROBADOR');
INSERT INTO rol VALUES (3, 'DIGITALIZADOR');
INSERT INTO rol VALUES (4, 'CONSULTAR');
INSERT INTO rol VALUES (5, 'IMPRIMIR');
INSERT INTO rol VALUES (6, 'REPORTES');
INSERT INTO rol VALUES (7, 'CONFIGURADOR');
INSERT INTO rol VALUES (8, 'MANTENIMIENTO');
INSERT INTO rol VALUES (9, 'ELIMINAR');


--
-- TOC entry 2438 (class 0 OID 0)
-- Dependencies: 185
-- Name: sq_categroria; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_categroria', 1, false);


--
-- TOC entry 2439 (class 0 OID 0)
-- Dependencies: 208
-- Name: sq_combo; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_combo', 1, false);


--
-- TOC entry 2440 (class 0 OID 0)
-- Dependencies: 189
-- Name: sq_dato_adicional; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_dato_adicional', 1, false);


--
-- TOC entry 2441 (class 0 OID 0)
-- Dependencies: 191
-- Name: sq_datos_infodocumento; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_datos_infodocumento', 1, false);


--
-- TOC entry 2442 (class 0 OID 0)
-- Dependencies: 193
-- Name: sq_documento_eliminado; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_documento_eliminado', 1, false);


--
-- TOC entry 2443 (class 0 OID 0)
-- Dependencies: 197
-- Name: sq_expediente; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_expediente', 1, false);


--
-- TOC entry 2444 (class 0 OID 0)
-- Dependencies: 200
-- Name: sq_foliatura; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_foliatura', 1, false);


--
-- TOC entry 2445 (class 0 OID 0)
-- Dependencies: 202
-- Name: sq_indices; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_indices', 1, false);


--
-- TOC entry 2446 (class 0 OID 0)
-- Dependencies: 204
-- Name: sq_infodocumento; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_infodocumento', 1, false);


--
-- TOC entry 2447 (class 0 OID 0)
-- Dependencies: 206
-- Name: sq_libreria; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_libreria', 1, false);


--
-- TOC entry 2448 (class 0 OID 0)
-- Dependencies: 210
-- Name: sq_perfil; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_perfil', 3, false);


--
-- TOC entry 2449 (class 0 OID 0)
-- Dependencies: 214
-- Name: sq_subcategroria; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_subcategroria', 1, false);


--
-- TOC entry 2450 (class 0 OID 0)
-- Dependencies: 215
-- Name: sq_tipo_documento; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_tipo_documento', 1, false);


--
-- TOC entry 2451 (class 0 OID 0)
-- Dependencies: 216
-- Name: sq_valor_dato_adicional; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sq_valor_dato_adicional', 1, false);


--
-- TOC entry 2427 (class 0 OID 19862)
-- Dependencies: 217
-- Data for Name: subcategoria; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2428 (class 0 OID 19866)
-- Dependencies: 218
-- Data for Name: tipodocumento; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2429 (class 0 OID 19870)
-- Dependencies: 219
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO usuario VALUES ('dw4jconf', 'Usuario', 'Configurador', NULL, NULL, 1, 'RGV2ZWxjb21HRA==');


--
-- TOC entry 2430 (class 0 OID 19873)
-- Dependencies: 220
-- Data for Name: valor_dato_adicional; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2212 (class 2606 OID 19881)
-- Name: categoria categoria_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_pk PRIMARY KEY (id_categoria);


--
-- TOC entry 2214 (class 2606 OID 19883)
-- Name: causa causa_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY causa
    ADD CONSTRAINT causa_pk PRIMARY KEY (id_causa);


--
-- TOC entry 2222 (class 2606 OID 19885)
-- Name: documento_eliminado documento_eliminado_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documento_eliminado
    ADD CONSTRAINT documento_eliminado_pk PRIMARY KEY (id_doc_eliminado);


--
-- TOC entry 2226 (class 2606 OID 19887)
-- Name: estatus_documento estatus_documento_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY estatus_documento
    ADD CONSTRAINT estatus_documento_pk PRIMARY KEY (id_estatus_documento);


--
-- TOC entry 2224 (class 2606 OID 19889)
-- Name: estatus estatus_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY estatus
    ADD CONSTRAINT estatus_pk PRIMARY KEY (id_estatus);


--
-- TOC entry 2232 (class 2606 OID 19891)
-- Name: foliatura foliatura_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliatura
    ADD CONSTRAINT foliatura_pk PRIMARY KEY (id_foliatura);


--
-- TOC entry 2238 (class 2606 OID 19893)
-- Name: libreria libreria_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY libreria
    ADD CONSTRAINT libreria_pk PRIMARY KEY (id_libreria);


--
-- TOC entry 2242 (class 2606 OID 19895)
-- Name: perfil perfil_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY perfil
    ADD CONSTRAINT perfil_pk PRIMARY KEY (id_perfil);


--
-- TOC entry 2240 (class 2606 OID 19897)
-- Name: lista_desplegables pk_combo; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lista_desplegables
    ADD CONSTRAINT pk_combo PRIMARY KEY (id_lista);


--
-- TOC entry 2216 (class 2606 OID 19899)
-- Name: configuracion pk_configuracion; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY configuracion
    ADD CONSTRAINT pk_configuracion PRIMARY KEY (id_configuracion);


--
-- TOC entry 2218 (class 2606 OID 19901)
-- Name: dato_adicional pk_dato_adicional; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dato_adicional
    ADD CONSTRAINT pk_dato_adicional PRIMARY KEY (id_dato_adicional);


--
-- TOC entry 2220 (class 2606 OID 19903)
-- Name: datos_infodocumento pk_datos_infodocumento; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datos_infodocumento
    ADD CONSTRAINT pk_datos_infodocumento PRIMARY KEY (id_datos);


--
-- TOC entry 2228 (class 2606 OID 19905)
-- Name: expedientes pk_expedientes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expedientes
    ADD CONSTRAINT pk_expedientes PRIMARY KEY (id_expedientes);


--
-- TOC entry 2230 (class 2606 OID 19907)
-- Name: fabrica pk_fabrica; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fabrica
    ADD CONSTRAINT pk_fabrica PRIMARY KEY (usuario);


--
-- TOC entry 2234 (class 2606 OID 19909)
-- Name: indices pk_indice; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indices
    ADD CONSTRAINT pk_indice PRIMARY KEY (id_indice);


--
-- TOC entry 2236 (class 2606 OID 19911)
-- Name: infodocumento pk_infordocumento; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY infodocumento
    ADD CONSTRAINT pk_infordocumento PRIMARY KEY (id_infodocumento);


--
-- TOC entry 2252 (class 2606 OID 19913)
-- Name: valor_dato_adicional pk_valor_dato_adicional; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY valor_dato_adicional
    ADD CONSTRAINT pk_valor_dato_adicional PRIMARY KEY (id_valor);


--
-- TOC entry 2244 (class 2606 OID 19915)
-- Name: rol rol_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rol
    ADD CONSTRAINT rol_pk PRIMARY KEY (id_rol);


--
-- TOC entry 2246 (class 2606 OID 19917)
-- Name: subcategoria subcategoria_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subcategoria
    ADD CONSTRAINT subcategoria_pk PRIMARY KEY (id_subcategoria);


--
-- TOC entry 2248 (class 2606 OID 19919)
-- Name: tipodocumento tipodocumento_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tipodocumento
    ADD CONSTRAINT tipodocumento_pk PRIMARY KEY (id_documento);


--
-- TOC entry 2250 (class 2606 OID 19921)
-- Name: usuario usuario_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pk PRIMARY KEY (id_usuario);


--
-- TOC entry 2254 (class 2606 OID 20018)
-- Name: categoria fk_categoria_estatus; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT fk_categoria_estatus FOREIGN KEY (id_estatus) REFERENCES estatus(id_estatus);


--
-- TOC entry 2253 (class 2606 OID 20008)
-- Name: categoria fk_categoria_libreira; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT fk_categoria_libreira FOREIGN KEY (id_libreria) REFERENCES libreria(id_libreria);


--
-- TOC entry 2255 (class 2606 OID 19922)
-- Name: dato_adicional fk_dato_adicional_tipodoc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dato_adicional
    ADD CONSTRAINT fk_dato_adicional_tipodoc FOREIGN KEY (id_documento) REFERENCES tipodocumento(id_documento);


--
-- TOC entry 2256 (class 2606 OID 19927)
-- Name: datos_infodocumento fk_datoc_infodoc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datos_infodocumento
    ADD CONSTRAINT fk_datoc_infodoc FOREIGN KEY (id_infodocumento) REFERENCES infodocumento(id_infodocumento);


--
-- TOC entry 2257 (class 2606 OID 19932)
-- Name: datos_infodocumento fk_datos_doc_eliminado; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datos_infodocumento
    ADD CONSTRAINT fk_datos_doc_eliminado FOREIGN KEY (id_doc_eliminado) REFERENCES documento_eliminado(id_doc_eliminado);


--
-- TOC entry 2258 (class 2606 OID 19937)
-- Name: expedientes fk_expedientes_categoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expedientes
    ADD CONSTRAINT fk_expedientes_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);


--
-- TOC entry 2259 (class 2606 OID 19942)
-- Name: expedientes fk_expedientes_libreria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expedientes
    ADD CONSTRAINT fk_expedientes_libreria FOREIGN KEY (id_libreria) REFERENCES libreria(id_libreria);


--
-- TOC entry 2260 (class 2606 OID 19947)
-- Name: fabrica fk_fabrica_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fabrica
    ADD CONSTRAINT fk_fabrica_usuario FOREIGN KEY (usuario) REFERENCES usuario(id_usuario);


--
-- TOC entry 2262 (class 2606 OID 20038)
-- Name: foliatura fk_foliatura_infodocumento; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliatura
    ADD CONSTRAINT fk_foliatura_infodocumento FOREIGN KEY (id_infodocumento) REFERENCES infodocumento(id_infodocumento);


--
-- TOC entry 2261 (class 2606 OID 20033)
-- Name: foliatura fk_foliatura_tipodocumento; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foliatura
    ADD CONSTRAINT fk_foliatura_tipodocumento FOREIGN KEY (id_documento) REFERENCES tipodocumento(id_documento);


--
-- TOC entry 2263 (class 2606 OID 19952)
-- Name: indices fk_indice_categoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indices
    ADD CONSTRAINT fk_indice_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);


--
-- TOC entry 2264 (class 2606 OID 19957)
-- Name: infodocumento fk_infodoc_statusdoc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY infodocumento
    ADD CONSTRAINT fk_infodoc_statusdoc FOREIGN KEY (estatus_documento) REFERENCES estatus_documento(id_estatus_documento);


--
-- TOC entry 2265 (class 2606 OID 19962)
-- Name: infodocumento fk_infodoc_tipodoc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY infodocumento
    ADD CONSTRAINT fk_infodoc_tipodoc FOREIGN KEY (id_documento) REFERENCES tipodocumento(id_documento);


--
-- TOC entry 2266 (class 2606 OID 20013)
-- Name: libreria fk_librerira_estatus; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY libreria
    ADD CONSTRAINT fk_librerira_estatus FOREIGN KEY (id_estatus) REFERENCES estatus(id_estatus);


--
-- TOC entry 2267 (class 2606 OID 19967)
-- Name: perfil fk_perfil_categoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY perfil
    ADD CONSTRAINT fk_perfil_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);


--
-- TOC entry 2268 (class 2606 OID 19972)
-- Name: perfil fk_perfil_libreria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY perfil
    ADD CONSTRAINT fk_perfil_libreria FOREIGN KEY (id_libreria) REFERENCES libreria(id_libreria);


--
-- TOC entry 2269 (class 2606 OID 19977)
-- Name: perfil fk_perfil_rol; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY perfil
    ADD CONSTRAINT fk_perfil_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol);


--
-- TOC entry 2270 (class 2606 OID 19982)
-- Name: perfil fk_perfil_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY perfil
    ADD CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario);


--
-- TOC entry 2271 (class 2606 OID 20023)
-- Name: subcategoria fk_subcategoria_categoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subcategoria
    ADD CONSTRAINT fk_subcategoria_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);


--
-- TOC entry 2272 (class 2606 OID 20028)
-- Name: subcategoria fk_subcategoria_estatus; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subcategoria
    ADD CONSTRAINT fk_subcategoria_estatus FOREIGN KEY (id_estatus) REFERENCES estatus(id_estatus);


--
-- TOC entry 2273 (class 2606 OID 19987)
-- Name: tipodocumento fk_tipodoc_categoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tipodocumento
    ADD CONSTRAINT fk_tipodoc_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);


--
-- TOC entry 2274 (class 2606 OID 19992)
-- Name: tipodocumento fk_tipodoc_subcategoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tipodocumento
    ADD CONSTRAINT fk_tipodoc_subcategoria FOREIGN KEY (id_subcategoria) REFERENCES subcategoria(id_subcategoria);


--
-- TOC entry 2275 (class 2606 OID 20043)
-- Name: tipodocumento fk_tipodocumento_estatus; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tipodocumento
    ADD CONSTRAINT fk_tipodocumento_estatus FOREIGN KEY (id_estatus) REFERENCES estatus(id_estatus);


--
-- TOC entry 2276 (class 2606 OID 19997)
-- Name: usuario fk_usuario_estatus; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT fk_usuario_estatus FOREIGN KEY (id_estatus) REFERENCES estatus(id_estatus);


--
-- TOC entry 2277 (class 2606 OID 20002)
-- Name: valor_dato_adicional fk_valor_indice_da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY valor_dato_adicional
    ADD CONSTRAINT fk_valor_indice_da FOREIGN KEY (id_dato_adicional) REFERENCES dato_adicional(id_dato_adicional);


-- Completed on 2017-09-16 22:17:23

--
-- PostgreSQL database dump complete
--

