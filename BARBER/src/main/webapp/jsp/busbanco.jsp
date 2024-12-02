<%@ include file="../jsp/conexion.jsp" %>
out.printl("<option value="">Seleccione un banco:</option>");
<%
try {
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM Banco ;");
    while (rs.next()) {
%>
        <option value="<%= rs.getString(1) %>"><%= rs.getString(1) %> - <%= rs.getString(2) %></option>
<%
    }
    rs.close();
    st.close();
} catch (Exception e) {
    out.println("Error PSQL: " + e);
}
%>
