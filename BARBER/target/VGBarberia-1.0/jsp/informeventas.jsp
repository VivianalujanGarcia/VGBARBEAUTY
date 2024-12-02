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
                        File reportFile=new File(application.getRealPath("reportes/informeventas.jasper"));
                        /**/
                        Map parametros=new HashMap();
                        String id_cliente = request.getParameter("cod");
                        int iTest = Integer.parseInt(id_cliente)
                        String fechaDesde = request.getParameter("txt_fecha_desde");
                        String fechaHasta = request.getParameter("txt_fecha_hasta");
                        
                        parametros.put("detalle",iTest);
                        parametros.put("DESDE",new String(fechaDesde));
                        parametros.put("HASTA",new String(fechaHasta));
                        
                        byte [] bytes= JasperRunManager.runReportToPdf(reportFile.getPath(), parametros,conn);
                        response.setContentType("application/pdf");
                        response.setContentLength(bytes.length);

                        ServletOutputStream output=response.getOutputStream();
                        response.getOutputStream();
                        output.write(bytes,0,bytes.length);
                        output.flush();
                        output.close();
                        }
                        catch(java.io.FileNotFoundException ex)
                        {
                            ex.getMessage();
                        }
                    %>

