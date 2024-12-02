<%@ include file="conexion.jsp" %>

<%
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM categorias ORDER BY id_categoria ASC");

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
            responseMessage = "Error al listar las categorías: " + e;
        }
    } else if ("cargar".equals(action)) {
        String nombre = request.getParameter("nombre");

        try {
            Statement st = conn.createStatement();
            
            // Verificar duplicados en nombre
            ResultSet rsNombre = st.executeQuery("SELECT * FROM categorias WHERE nombre='" + nombre + "'");
            if (rsNombre.next()) {
                responseMessage = "<span style='color: red;'>Ya existe una categoría con el mismo nombre.</span>";
            } else {
                st.executeUpdate("INSERT INTO categorias (nombre) VALUES ('" + nombre + "')");
                responseMessage = "<span style='color: green;'>Datos cargados</span>";
            }
        } catch (Exception e) {
            responseMessage = "Error al cargar la categoría: " + e;
        }
    } else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String nombre = request.getParameter("nombre");

        try {
            Statement st = conn.createStatement();
            ResultSet rsNombre = st.executeQuery("SELECT * FROM categorias WHERE nombre='" + nombre + "' AND id_categoria != '" + pk + "'");
            if (rsNombre.next()) {
                responseMessage = "<span style='color: red;'>Ya existe una categoría con el mismo nombre.</span>";
            } else {
                st.executeUpdate("UPDATE categorias SET nombre='" + nombre + "' WHERE id_categoria=" + pk);
                responseMessage = "<span style='color: green;'>Datos actualizados</span>";
            }
        } catch (Exception e) {
            responseMessage = "Error al modificar la categoría: " + e;
        }
    } else if ("eliminar".equals(action)) {
        String pk = request.getParameter("pkdel");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM categorias WHERE id_categoria='" + pk + "'");
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error al eliminar la categoría: " + e;
        }
    }
    
    out.print(responseMessage);
%>
