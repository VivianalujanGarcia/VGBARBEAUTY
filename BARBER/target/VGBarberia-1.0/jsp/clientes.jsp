<%@ include file="conexion.jsp" %>
<%   
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT c.id_cliente, c.nombre, c.ci, c.direccion, c.telefono, ci.nombre AS nombre_ciudad FROM clientes c INNER JOIN ciudades ci ON c.id_ciudad = ci.id_ciudad ORDER BY c.id_cliente ASC;");
            
            while (rs.next()) {      
%>  
<tr>
    <td style="color: black;"><% out.print(rs.getString(1)); %></td>
    <td style="color: black;"><% out.print(rs.getString(2)); %></td>
    <td style="color: black;"><% out.print(rs.getString(3)); %></td>
    <td style="color: black;"><% out.print(rs.getString(4)); %></td>
    <td style="color: black;"><% out.print(rs.getString(5)); %></td>
    <td style="color: black;"><% out.print(rs.getString(6)); %></td>
   
  
 
    
    <td>
        <button class="btn btn-outline-success" onclick="rellenado('<% out.print(rs.getString(1)); %>', '<% out.print(rs.getString(2)); %>', '<% out.print(rs.getString(3));  %>', '<% out.print(rs.getString(4));  %>', '<% out.print(rs.getString(5));  %>', '<% out.print(rs.getString(6));  %>')" title="Editar">
            <img src="img/edicion.png" title="Editar">
        </button>
        <button class="btn btn-outline-secondary" onclick="$('#pkim').val('<%= rs.getString(1) %>')" title="Imprimir"> <img src="img/impresora (1).png" title="Imprimir" data-toggle="modal" data-target="#Imprimir"> 
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
        String ci = request.getParameter("ci");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String id_ciudad = request.getParameter("id_ciudad");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("INSERT INTO clientes (nombre, ci, direccion, telefono, id_ciudad) VALUES ('" + nombre + "', '" + ci + "', '" + direccion + "', '" + telefono + "', " + id_ciudad + ")");
            responseMessage = "<span style='color: green;'>Datos cargados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    }  else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String nombre = request.getParameter("nombre");
        String ci = request.getParameter("ci");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String id_ciudad = request.getParameter("id_ciudad");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("UPDATE clientes SET nombre = '" + nombre + "', ci = '" + ci + "', direccion = '" + direccion + "', telefono = '" + telefono + "', id_ciudad = " + id_ciudad + " WHERE id_cliente = " + pk);
            responseMessage = "<span style='color: green;'>Datos actualizados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("eliminar".equals(action)) {
        String pk = request.getParameter("pkdel");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM clientes WHERE id_cliente = " + pk);
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    }
    
    out.print(responseMessage);
%>
