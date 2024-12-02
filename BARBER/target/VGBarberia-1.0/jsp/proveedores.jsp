<%@ include file="conexion.jsp" %>
<%
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT p.id_proveedor, p.nombre, p.ruc, p.telefono, p.correo, ci.nombre AS nombre_ciudad FROM proveedores p INNER JOIN ciudades ci ON p.id_ciudad = ci.id_ciudad ORDER BY p.id_proveedor ASC;");
            
            while (rs.next()) {      
%>  
<tr>
    <td style="color: black;"><%= rs.getString(1) %></td>
    <td style="color: black;"><%= rs.getString(2) %></td>
    <td style="color: black;"><%= rs.getString(3) %></td>
    <td style="color: black;"><%= rs.getString(4) %></td>
    <td style="color: black;"><%= rs.getString(5) %></td>
    <td style="color: black;"><%= rs.getString(6) %></td>
    <td>
        <button class="btn btn-outline-success" onclick="rellenado('<%= rs.getString(1) %>', '<%= rs.getString(2) %>', '<%= rs.getString(3) %>', '<%= rs.getString(4) %>', '<%= rs.getString(5) %>', '<%= rs.getString(6) %>')" title="Editar">
          <img src="img/edicion.png" title="Editar">
        </button>
        <button class="btn btn-outline-secondary" onclick="$('#pkim').val('<%= rs.getString(1) %>')" title="Imprimir"> 
            <img src="img/impresora (1).png" title="Imprimir" data-toggle="modal" data-target="#Imprimir"> 
        </button>
        <button class="btn btn-outline-danger" onclick="$('#pkdel').val('<%= rs.getString("id_proveedor") %>')" title="Eliminar" data-toggle="modal" data-target="#Eliminar">
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
        String ruc = request.getParameter("ruc");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String id_ciudad = request.getParameter("id_ciudad");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("INSERT INTO proveedores (nombre, ruc, telefono, correo, id_ciudad) VALUES ('" + nombre + "', '" + ruc + "', '" + telefono + "', '" + correo + "', " + id_ciudad + ")");
            responseMessage = "<span style='color: green;'>Datos cargados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String nombre = request.getParameter("nombre");
        String ruc = request.getParameter("ruc");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String id_ciudad = request.getParameter("id_ciudad");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("UPDATE proveedores SET nombre = '" + nombre + "', ruc = '" + ruc + "', telefono = '" + telefono + "', correo = '" + correo + "', id_ciudad = " + id_ciudad + " WHERE id_proveedor = " + pk);
            responseMessage = "<span style='color: green;'>Datos actualizados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("eliminar".equals(action)) {
        String pk = request.getParameter("pkdel");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM proveedores WHERE id_proveedor = " + pk);
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    }
    
    out.print(responseMessage);
%>
