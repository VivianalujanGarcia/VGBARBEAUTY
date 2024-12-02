<%@ include file="conexion.jsp" %>

<%
    HttpSession sesion = request.getSession();
    int idusuario = 0;
    String idusuariostring = (String) sesion.getAttribute("id");

   
    String fecha = request.getParameter("fecha");
    String monto = request.getParameter("monto");

    Statement st = null;
    ResultSet rs = null;
    int idapertura = -1; // Variable para almacenar el id de apertura

    try {
        st = conn.createStatement();
        
        // Consultar el idapertura con estado 'ABIERTO'
        rs = st.executeQuery("SELECT id FROM abrircaja WHERE estado='ABIERTO'");
        if (rs.next()) {
            idapertura = rs.getInt("id");
        } else {
            out.print("DEBE ABRIR CAJA PARA CIERRE");
            return;
        }

        // Insertar el cierre de caja
        String sqlCierre = "INSERT INTO cerrarcaja(fecha, monto, estado, idabrircaja) VALUES ('" + fecha + "', '" + monto + "', 'CERRADO', '" + idapertura + "')";
        st.executeUpdate(sqlCierre);

        // Actualizar el estado de la apertura de caja a 'CERRADO'
        String sqlActualizacion = "UPDATE abrircaja SET estado='CERRADO' WHERE id=" + idapertura;
        st.executeUpdate(sqlActualizacion);

        out.print("Caja cerrada exitosamente");

    } catch (SQLException e) {
        out.print("Error al cerrar la caja: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
        } catch (SQLException e) {
            out.print("Error al cerrar los recursos: " + e.getMessage());
        }
    }
%>