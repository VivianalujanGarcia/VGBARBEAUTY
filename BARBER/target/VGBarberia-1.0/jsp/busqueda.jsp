<%@ include file="../jsp/conexion.jsp" %>
<%
    if (request.getParameter("listar").equals("buscaralumno")) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select * from clientes;");
%>
            <option value="">Seleccione un cliente:</option>
<%
            while (rs.next()) {
%>
            <option value="<% out.print(rs.getString(1)); %>,<% out.print(rs.getString(3)); %>"  data-nombre=""><% out.print(rs.getString(2)); %> </option>
            
<%
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        } 
    } else if (request.getParameter("listar").equals("buscaraarticulo")) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select * from productos;");
%>
            <option value="">Seleccione un producto:</option>
<%
            while (rs.next()) {
%>
            <option value="<% out.print(rs.getString(1)); %>,<% out.print(rs.getString(4)); %>"><% out.print(rs.getString(3)); %></option>
<%
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        } 
    }
%>
