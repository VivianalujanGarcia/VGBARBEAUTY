
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%
        Connection conn = null;
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/VGBarberia","postgres","1");
        if (conn != null) {
            //out.print("conectado");
        }
%>
 
