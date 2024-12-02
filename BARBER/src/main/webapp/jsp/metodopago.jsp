<%@ include file="conexion.jsp" %>

<%
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM metodos_pago ORDER BY id_metodo_pago ASC");

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
            responseMessage = "Error al listar los m?todos de pago: " + e;
        }
    } else if ("cargar".equals(action)) {
        String metodo = request.getParameter("metodo");

        try {
            Statement st = conn.createStatement();
            
            // Verificar duplicados en m?todo
            ResultSet rsMetodo = st.executeQuery("SELECT * FROM metodos_pago WHERE metodo='" + metodo + "'");
            if (rsMetodo.next()) {
                responseMessage = "<span style='color: red;'>Ya existe un m?todo de pago con el mismo nombre.</span>";
            } else {
                st.executeUpdate("INSERT INTO metodos_pago (metodo) VALUES ('" + metodo + "')");
                responseMessage = "<span style='color: green;'>Datos cargados</span>";
            }
        } catch (Exception e) {
            responseMessage = "Error al cargar el m?todo de pago: " + e;
        }
    } else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String metodo = request.getParameter("metodo");

        try {
            Statement st = conn.createStatement();
            ResultSet rsMetodo = st.executeQuery("SELECT * FROM metodos_pago WHERE metodo='" + metodo + "' AND id_metodo_pago != '" + pk + "'");
            if (rsMetodo.next()) {
                responseMessage = "<span style='color: red;'>Ya existe un m?todo de pago con el mismo nombre.</span>";
            } else {
                st.executeUpdate("UPDATE metodos_pago SET metodo='" + metodo + "' WHERE id_metodo_pago=" + pk);
                responseMessage = "<span style='color: green;'>Datos actualizados</span>";
            }
        } catch (Exception e) {
            responseMessage = "Error al modificar el m?todo de pago: " + e;
        }
    } else if ("eliminar".equals(action)) {
        String pk = request.getParameter("pkdel");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM metodos_pago WHERE id_metodo_pago='" + pk + "'");
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error al eliminar el m?todo de pago: " + e;
        }
    }
    
    out.print(responseMessage);
%>


