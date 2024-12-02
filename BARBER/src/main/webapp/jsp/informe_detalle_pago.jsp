<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %> 
<%@ include file="conexion.jsp" %>

<%@ page contentType="application/pdf" pageEncoding="UTF-8"%>
<%
    try {
        // Ruta del archivo Jasper
        File reportFile = new File(application.getRealPath("reportes/pagos_informe_productos.jasper")); // Modificado para el reporte de pagos a proveedores
        System.out.println("Ruta del archivo Jasper: " + reportFile.getPath());

        // Obtener parámetros de la solicitud
        String fechaDesdeStr = request.getParameter("fecha_desde");
        String fechaHastaStr = request.getParameter("fecha_hasta");
        String id_proveedorStr = request.getParameter("id_proveedor"); // Cambio de id_cliente a id_proveedor

        // Formato de fecha esperado
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // Ajusta el formato según tu entrada
        Date fechaDesde = sdf.parse(fechaDesdeStr);
        Date fechaHasta = sdf.parse(fechaHastaStr);

        // Crear el mapa de parámetros para el reporte
        Map<String, Object> parametros = new HashMap<>();
        parametros.put("fecha_desde", fechaDesde);
        parametros.put("fecha_hasta", fechaHasta);

        // Agregar id_proveedor al mapa de parámetros si está presente
        if (id_proveedorStr != null && !id_proveedorStr.isEmpty()) {
            parametros.put("id_proveedor", Integer.parseInt(id_proveedorStr)); // Cambio de id_cliente a id_proveedor
        }

        // Generar el reporte en formato PDF
        System.out.println("Generando el PDF...");
        byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);

        // Configuración de la respuesta para enviar el PDF
        response.setContentType("application/pdf");
        response.setContentLength(bytes.length);

        ServletOutputStream output = response.getOutputStream();
        output.write(bytes, 0, bytes.length);
        output.flush();
        output.close();
    } catch (java.io.FileNotFoundException ex) {
        ex.printStackTrace();
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Archivo Jasper no encontrado.");
    } catch (ParseException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error al parsear las fechas.");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar el reporte.");
    }
%>
