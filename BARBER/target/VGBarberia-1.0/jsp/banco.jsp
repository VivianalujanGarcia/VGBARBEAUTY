<%@ include file="conexion.jsp" %>

<%
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            // Modificación aquí: usar comillas dobles alrededor de "Banco"
            ResultSet rs = st.executeQuery("SELECT * FROM \"Banco\" ORDER BY id ASC");

            while (rs.next()) {
%>  
<tr>
    <td style="color: black;"><% out.print(rs.getString(1)); %></td>
    <td style="color: black;"><% out.print(rs.getString(2)); %></td>
    <td>
        <button class="btn btn-outline-success" onclick="rellenado('<% out.print(rs.getString(1)); %>', '<% out.print(rs.getString(2)); %>')" title="Editar">
           <img src="img/edicion.png" title="Editar">
        </button>
        <button class="btn btn-outline-secondary" onclick="$('#pkim').val('<%= rs.getString(1) %>')" title="Imprimir"> 
            <img src="img/impresora (1).png" title="Imprimir" data-toggle="modal" data-target="#Imprimir"> 
        </button>
        <button class="btn btn-outline-danger" onclick="$('#pkdel').val('<% out.print(rs.getString(1)); %>')" title="Eliminar" data-toggle="modal" data-target="#Eliminar">
            <img src="img/papelera-de-reciclaje.png">
        </button>      
    </td>
</tr>  
<%  
            }
        } catch (Exception e) {
            responseMessage = "Error al listar el banco: " + e;
        }
    } else if ("cargar".equals(action)) {
        String nombre = request.getParameter("nombre");

        try {
            Statement st = conn.createStatement();
            
            // Modificación aquí: usar comillas dobles alrededor de "Banco"
            ResultSet rsnombre = st.executeQuery("SELECT * FROM \"Banco\" WHERE nombre='" + nombre + "'");
            if (rsnombre.next()) {
                responseMessage = "<span style='color: red;'>Ya existe con el mismo nombre.</span>";
            } else {
                st.executeUpdate("INSERT INTO \"Banco\" (nombre) VALUES ('" + nombre + "')");
                responseMessage = "<span style='color: green;'>Datos cargados</span>";
            }
        } catch (Exception e) {
            responseMessage = "Error al cargar el método de pago: " + e;
        }
    } else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String nombre = request.getParameter("nombre");

        try {
            Statement st = conn.createStatement();
            // Modificación aquí: usar comillas dobles alrededor de "Banco"
            ResultSet rsnombre = st.executeQuery("SELECT * FROM \"Banco\" WHERE nombre='" + nombre + "' AND id != '" + pk + "'");
            if (rsnombre.next()) {
                responseMessage = "<span style='color: red;'>Ya existe con el mismo nombre.</span>";
            } else {
                st.executeUpdate("UPDATE \"Banco\" SET nombre='" + nombre + "' WHERE id=" + pk);
                responseMessage = "<span style='color: green;'>Datos actualizados</span>";
            }
        } catch (Exception e) {
            responseMessage = "Error al modificar el Banco: " + e;
        }
    } else if ("eliminar".equals(action)) {
        String pk = request.getParameter("pkdel");

        try {
            Statement st = conn.createStatement();
            // Modificación aquí: usar comillas dobles alrededor de "Banco"
            st.executeUpdate("DELETE FROM \"Banco\" WHERE id='" + pk + "'");
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error al eliminar el banco: " + e;
        }
    }
    
    out.print(responseMessage);
%>
