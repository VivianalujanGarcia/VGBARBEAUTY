<%@ include file="conexion.jsp" %>

<%
    String action = request.getParameter("listar");
    String responseMessage = "";

    if ("listar".equals(action)) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.cantidad,p.iva ,c.nombre AS nombre_categoria, m.nombre AS nombre_marca FROM productos p INNER JOIN categorias c ON p.id_categoria = c.id_categoria INNER JOIN marcas m ON p.id_marca = m.id_marca ORDER BY p.id_producto ASC");
            
            while (rs.next()) {
%>
<tr>
    <td style="color: black;"><% out.print(rs.getString(1)); %></td>
    <td style="color: black;"><% out.print(rs.getString(2)); %></td>
    <td style="color: black;"><% out.print(rs.getString(3)); %></td>
    <td style="color: black;"><% out.print(rs.getString(4)); %></td>
    <td style="color: black;"><% out.print(rs.getString(5)); %></td>
    <td style="color: black;"><% out.print(rs.getString(6)); %></td>
    <td style="color: black;"><% out.print(rs.getString(7)); %></td>
    <td style="color: black;"><% out.print(rs.getString(8)); %></td>
    <td>
        <button class="btn btn-outline-success" onclick="rellenado('<% out.print(rs.getString(1)); %>', '<% out.print(rs.getString(2)); %>', '<% out.print(rs.getString(3)); %>', '<% out.print(rs.getString(4)); %>', '<% out.print(rs.getString(5)); %>', '<% out.print(rs.getString(6)); %>', '<% out.print(rs.getString(7)); %>', '<% out.print(rs.getString(8)); %>')" title="Editar">
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
        String descripcion = request.getParameter("descripcion");
        int precio = Integer.parseInt(request.getParameter("precio"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        int id_categoria = Integer.parseInt(request.getParameter("id_categoria"));
        int id_marca = Integer.parseInt(request.getParameter("id_marca"));
        int iva = Integer.parseInt(request.getParameter("iva"));
        try {
            Statement st = conn.createStatement();

            // Verificar duplicados en nombre y descripción
            ResultSet rsNombre = st.executeQuery("SELECT * FROM productos WHERE nombre='" + nombre + "'");
            if (rsNombre.next()) {
                responseMessage = "<span style='color: red;'>Ya existe un producto con el mismo nombre.</span>";
            } else {
                ResultSet rsDescripcion = st.executeQuery("SELECT * FROM productos WHERE descripcion='" + descripcion + "'");
                if (rsDescripcion.next()) {
                    responseMessage = "<span style='color: red;'>Ya existe un producto con la misma descripción.</span>";
                } else {
                    st.executeUpdate("INSERT INTO productos(nombre, descripcion, precio, cantidad, id_categoria, id_marca,iva) VALUES ('" + nombre + "', '" + descripcion + "', " + precio + ", " + cantidad + ", " + id_categoria + ", " + id_marca + ", " + iva + ")");
                    responseMessage = "<span style='color: green;'>Datos cargados</span>";
                }
            }
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("modificar".equals(action)) {
        String pk = request.getParameter("pk");
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        int precio = Integer.parseInt(request.getParameter("precio"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        int id_categoria = Integer.parseInt(request.getParameter("id_categoria"));
        int id_marca = Integer.parseInt(request.getParameter("id_marca"));
        int iva = Integer.parseInt(request.getParameter("iva"));
        try {
            Statement st = conn.createStatement();

            // Verificar duplicados en nombre y descripción
            ResultSet rsNombre = st.executeQuery("SELECT * FROM productos WHERE nombre='" + nombre + "' AND id_producto != '" + pk + "'");
            if (rsNombre.next()) {
                responseMessage = "<span style='color: red;'>Ya existe un producto con el mismo nombre.</span>";
            } else {
                ResultSet rsDescripcion = st.executeQuery("SELECT * FROM productos WHERE descripcion='" + descripcion + "' AND id_producto != '" + pk + "'");
                if (rsDescripcion.next()) {
                    responseMessage = "<span style='color: red;'>Ya existe un producto con la misma descripción.</span>";
                } else {
                    st.executeUpdate("UPDATE productos SET nombre = '" + nombre + "', descripcion = '" + descripcion + "', precio = " + precio + ", cantidad = " + cantidad + ", id_categoria = " + id_categoria + ", id_marca = " + id_marca + " , iva = " + iva + " WHERE id_producto = " + pk);
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
            st.executeUpdate("DELETE FROM productos WHERE id_producto = " + pk);
            responseMessage = "<span style='color: green;'>Datos eliminados</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    } else if ("compra".equals(action)) { // Incrementa cantidad
        String pk = request.getParameter("pk");
        int cantidadCompra = Integer.parseInt(request.getParameter("cantidadCompra"));
        
        try {
            Statement st = conn.createStatement();
            st.executeUpdate("UPDATE productos SET cantidad = cantidad + " + cantidadCompra + " WHERE id_producto = " + pk);
            responseMessage = "<span style='color: green;'>Cantidad aumentada por compra</span>";
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
        
    } else if ("venta".equals(action)) { // Reduce cantidad
        String pk = request.getParameter("pk");
        int cantidadVenta = Integer.parseInt(request.getParameter("cantidadVenta"));
        
        try {
            Statement st = conn.createStatement();
            
            // Validación para evitar cantidades negativas
            ResultSet rs = st.executeQuery("SELECT cantidad FROM productos WHERE id_producto = " + pk);
            if (rs.next()) {
                int cantidadActual = rs.getInt("cantidad");
                if (cantidadActual >= cantidadVenta) {
                    st.executeUpdate("UPDATE productos SET cantidad = cantidad - " + cantidadVenta + " WHERE id_producto = " + pk);
                    responseMessage = "<span style='color: green;'>Cantidad reducida por venta</span>";
                } else {
                    responseMessage = "<span style='color: red;'>Error: Stock insuficiente</span>";
                }
            }
        } catch (Exception e) {
            responseMessage = "Error PSQL: " + e;
        }
    }
    
    out.print(responseMessage);
%>
    
