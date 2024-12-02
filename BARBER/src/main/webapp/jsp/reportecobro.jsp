<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="conexion.jsp" %>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
                        try{
                        /*INDICAMOS EL LUGAR DONDE SE ENCUENTRA NUESTRO ARCHIVO JASPER*/
                        File reportFile=new File(application.getRealPath("reportes/reportecobro.jasper"));
                        /**/
                        Map parametros=new HashMap();
                       String pkim = request.getParameter("pkim");
                        int id = Integer.parseInt(pkim);
                        parametros.put("id",id);

                        
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
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar el reporte.");
                    }
                    %>

