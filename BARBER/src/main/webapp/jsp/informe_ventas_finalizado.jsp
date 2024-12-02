<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %> <!-- Asegúrate de agregar esta línea  -->
<%@ include file="conexion.jsp" %>

<%@ page contentType="application/pdf" pageEncoding="UTF-8"%>
<%
    try {
        File reportFile = new File(application.getRealPath("reportes/ventas_informe_finalizado.jasper"));
        System.out.println("Ruta del archivo Jasper: " + reportFile.getPath());

        Map<String, Object> parametros = new HashMap<>();

        String fechaDesdeStr = request.getParameter("fecha_desde");
        String fechaHastaStr = request.getParameter("fecha_hasta");

        // Formato de fecha esperado
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // Ajusta el formato según tu entrada
        Date fechaDesde = sdf.parse(fechaDesdeStr);
        Date fechaHasta = sdf.parse(fechaHastaStr);

        // Agregar fechas al mapa de parámetros
        parametros.put("fecha_desde", fechaDesde);
        parametros.put("fecha_hasta", fechaHasta);

        System.out.println("Generando el PDF...");
        byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);

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
