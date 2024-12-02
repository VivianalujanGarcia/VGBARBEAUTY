<%@ include file="../jsp/conexion.jsp" %>
<%
   if (request.getParameter("listar").equals("buscaraarticulo")) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM productos WHERE id_categoria BETWEEN 1 AND 5;");
%>
            <option value="">Seleccione un producto:</option>
<%
            while (rs.next()) {
%>
            <option value="<% out.print(rs.getString(1)); %>,<% out.print(rs.getString(5)); %>"><% out.print(rs.getString(3)); %></option>
<%
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        } 
    }
%>
