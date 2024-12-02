<%@ include file="conexion.jsp" %>
<%   
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT p.id_personal, p.nombre, p.apellido, p.ci, p.fecha_nacimiento, p.direccion, p.telefono,  ci.nombre AS nombre_ciudad FROM personales p INNER JOIN ciudades ci ON p.idciudad = ci.id_ciudad ORDER BY p.id_personal ASC;");
            
            while (rs.next()) {      
%>  
<tr> 
 
            
    <td style="color: black;"><% out.print(rs.getString(1)); %></td>
    <td style="color: black;"><% out.print(rs.getString(2)); %></td>
    <td style="color: black;"><% out.print(rs.getString(3)); %></td>
    <td style="color: black;"><% out.print(rs.getString(4)); %></td>
    <td style="color: black;"><% out.print(rs.getDate(5)); %></td>
    <td style="color: black;"><% out.print(rs.getString(6)); %></td>
    <td style="color: black;"><% out.print(rs.getString(7)); %></td>
    <td style="color: black;"><% out.print(rs.getString(8)); %></td>
 
    
    <td>
        <button class="btn btn-outline-success" onclick="rellenado('<% out.print(rs.getString(1)); %>', '<% out.print(rs.getString(2)); %>', '<% out.print(rs.getString(3)); %>', '<% out.print(rs.getString(4)); %>', '<% out.print(rs.getDate(5)); %>', '<% out.print(rs.getString(6)); %>', '<% out.print(rs.getString(7)); %>', '<% out.print(rs.getString(8)); %>')" title="Editar">
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
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("cargar".equals(action)) {
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String ci = request.getParameter("ci");
        String fecha = request.getParameter("fecha");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
    
        String id_ciudad = request.getParameter("id_ciudad");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("INSERT INTO personales (nombre, apellido, ci, fecha_nacimiento, direccion, telefono,  idciudad) VALUES ('" 
                             + nombre + "', '" + apellido + "', '" + ci + "', '" + fecha + "', '" + direccion + "', '" + telefono + "', " + id_ciudad + ")");
            responseMessage = "<span style='color: green;'>Datos cargados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    }  else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String ci = request.getParameter("ci");
        String fecha = request.getParameter("fecha");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
 
        String id_ciudad = request.getParameter("id_ciudad");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("UPDATE personales SET nombre = '" + nombre + "', apellido = '" + apellido + "', ci = '" + ci + "', fecha_nacimiento = '" 
                             + fecha + "', direccion = '" + direccion + "', telefono = '" + telefono + "', id_ciudad = " 
                             + id_ciudad + " WHERE id_personal = " + pk);
            responseMessage = "<span style='color: green;'>Datos actualizados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("eliminar".equals(action)) {
        String pk = request.getParameter("pkdel");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM personales WHERE id_personal = " + pk);
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    }
    
    out.print(responseMessage);
%>
