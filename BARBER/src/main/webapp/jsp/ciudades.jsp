<%@ include file="conexion.jsp" %>

<%
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM ciudades ORDER BY id_ciudad ASC");

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
            responseMessage = "Error al listar las ciudades: " + e;
        }
    } else if ("cargar".equals(action)) {
        String nombre = request.getParameter("nombre");

        try {
            Statement st = conn.createStatement();
            
            // Verificar duplicados en nombre
            ResultSet rsNombre = st.executeQuery("SELECT * FROM ciudades WHERE nombre='" + nombre + "'");
            if (rsNombre.next()) {
                responseMessage = "<span style='color: red;'>Ya existe una ciudad con el mismo nombre.</span>";
            } else {
                st.executeUpdate("INSERT INTO ciudades (nombre) VALUES ('" + nombre + "')");
                responseMessage = "<span style='color: green;'>Datos cargados</span>";
            }
        } catch (Exception e) {
            responseMessage = "Error al cargar la ciudad: " + e;
        }
    } else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String nombre = request.getParameter("nombre");

        try {
            Statement st = conn.createStatement();
            ResultSet rsNombre = st.executeQuery("SELECT * FROM ciudades WHERE nombre='" + nombre + "' AND id_ciudad != '" + pk + "'");
            if (rsNombre.next()) {
                responseMessage = "<span style='color: red;'>Ya existe una ciudad con el mismo nombre.</span>";
            } else {
                st.executeUpdate("UPDATE ciudades SET nombre='" + nombre + "' WHERE id_ciudad=" + pk);
                responseMessage = "<span style='color: green;'>Datos actualizados</span>";
            }
        } catch (Exception e) {
            responseMessage = "Error al modificar la ciudad: " + e;
        }
    } else if ("eliminar".equals(action)) {
        String pk = request.getParameter("pkdel");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM ciudades WHERE id_ciudad='" + pk + "'");
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error al eliminar la ciudad: " + e;
        }
    }
    
    out.print(responseMessage);
%>
