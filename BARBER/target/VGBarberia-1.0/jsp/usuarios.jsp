<%@ include file="conexion.jsp" %>

<%
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM usuarios;");
            
            while (rs.next()) {
%>
<tr>
    <td style="color: black;"><% out.print(rs.getString(1)); %></td>
    <td style="color: black;"><% out.print(rs.getString(2)); %></td>
    <td style="color: black;"><% out.print(rs.getString(3)); %></td>
    <td style="color: black;"><% out.print(rs.getString(4)); %></td>
    <td style="color: black;"><% out.print(rs.getString(5)); %></td>
    <td style="color: black;"><% out.print(rs.getString(6)); %></td>
    <td style="color: black;">
        <button class="btn btn-outline-success" onclick="rellenado('<% out.print(rs.getString(1)); %>', '<% out.print(rs.getString(2)); %>', '<% out.print(rs.getString(3)); %>', '<% out.print(rs.getString(4)); %>', '<% out.print(rs.getString(5)); %>', '<% out.print(rs.getString(6)); %>')" title="Editar">
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
        String datos = request.getParameter("datos");
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");
        String rol = request.getParameter("rol");
        String estado = request.getParameter("estado");

        try {
            Statement st = conn.createStatement();
            
            // Verificar duplicados en datos y usuario
            ResultSet rsDatos = st.executeQuery("SELECT * FROM usuarios WHERE datos='" + datos + "'");
            if (rsDatos.next()) {
                responseMessage = "<span style='color: red;'>Ya existe un usuario con el mismo dato.</span>";
            } else {
                ResultSet rsUsuario = st.executeQuery("SELECT * FROM usuarios WHERE usuario='" + usuario + "'");
                if (rsUsuario.next()) {
                    responseMessage = "<span style='color: red;'>Ya existe un usuario con el mismo usuario.</span>";
                } else {
                    st.executeUpdate("INSERT INTO usuarios(datos, usuario, clave, rol, estado) VALUES('" + datos + "','" + usuario + "','" + clave + "','" + rol + "','" + estado + "')");
                    responseMessage = "<span style='color: green;'>Datos cargados</span>";
                }
            }
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String datos = request.getParameter("datos");
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");
        String rol = request.getParameter("rol");
        String estado = request.getParameter("estado");
        try {
            Statement st = conn.createStatement();
            ResultSet rsDatos = st.executeQuery("SELECT * FROM usuarios WHERE datos='" + datos + "' AND id != '" + pk + "'");
            if (rsDatos.next()) {
                responseMessage = "<span style='color: red;'>Ya existe un usuario con el mismo dato.</span>";
            } else {
                ResultSet rsUsuario = st.executeQuery("SELECT * FROM usuarios WHERE usuario='" + usuario + "' AND id!= '" + pk + "'");
                if (rsUsuario.next()) {
                    responseMessage = "<span style='color: red;'>Ya existe un usuario con el mismo usuario.</span>";
                } else {
                    st.executeUpdate("UPDATE usuarios SET datos='" + datos + "', usuario='" + usuario + "', clave='" + clave + "', rol='" + rol + "', estado='" + estado + "' WHERE id=" + pk);
                    responseMessage = "<span style='color: green;'>Datos actualizados</span>";
                }
            }
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("eliminar".equals(action)) {
        String pk = request.getParameter("pkdel");
        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM usuarios WHERE id='" + pk + "'");
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    }
    
    out.print(responseMessage);
%>
